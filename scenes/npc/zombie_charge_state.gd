class_name ZombieChargeState
extends State

@export var actor: EnemyBoss
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D

signal charge_finished

var charging = false
var charge_speed = 150.0  # Velocidad aumentada de la carga
var charge_duration = 1.5  # Tiempo que dura la carga
var direction = Vector2.ZERO  # Dirección de la carga

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	$"../../Voice".stream = load("res://sound/sounds/Nueva carpeta/gordo_2.ogg")
	$"../../Voice".play()
	set_physics_process(true)
	animator.play("charge")  # Asegúrate de tener una animación de carga en el Sprite
	actor.update_text("CARGAR")

	# Establecer dirección hacia el jugador
	if actor.player_node:
		direction = (actor.player_node.global_position - actor.global_position).normalized()
	else:
		direction = Vector2.RIGHT  # Si no hay jugador, mueve a la derecha
	
	charging = true
	await get_tree().create_timer(charge_duration).timeout  # Esperar el tiempo de la carga
	charging = false
	charge_finished.emit()  # Emitir la señal para cambiar de estado

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	if charging:
		actor.velocity = direction * charge_speed
		actor.move_and_slide()
