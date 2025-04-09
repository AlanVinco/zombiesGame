class_name ZombieCaerState
extends State

@export var actor: EnemyBoss
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D

signal termino_de_caer

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	$"../../Voice".stream = load("res://sound/sounds/Nueva carpeta/gordo_3.ogg")
	$"../../Voice".play()
	$"../../AreaBajaSalud/CollisionShape2D".disabled = false
	$"../../CollisionShape2D".disabled = false
	set_physics_process(true)
	animator.play("caer")
	actor.update_text("CAER")
	##AQUI PONER IMAGEN DE DEBILIDAD
	await get_tree().create_timer(5.0).timeout
	termino_de_caer.emit()

func _exit_state() -> void:
	set_physics_process(false)
