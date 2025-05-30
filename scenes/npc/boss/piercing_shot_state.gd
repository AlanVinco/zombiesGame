## Estado: Disparo Perforante
class_name PiercingShotState
extends State

@export var actor: RatzwelFinalBoss

signal termino_de_disparar

func _ready() -> void:
	set_physics_process(false)

func _enter_state():
	$"../../Shot".stream = load("res://sound/sounds/load_shot.ogg")
	$"../../Shot".play()
	$"../../Voice".stream = load("res://sound/sounds/Nueva carpeta/piercing_shot.ogg")
	$"../../Voice".play()
	actor.update_text("¡Cargando disparo!")
	actor.animator.play("shot")
	actor.animator.stop()
	await get_tree().create_timer(1.5).timeout  # Tiempo de carga
	
	actor.update_text("¡Disparo perforante!")
	actor.animator.speed_scale = 3
	actor.animator.play("shot")
	var direction = (actor.player_node.global_position - actor.global_position).normalized()
	actor.spawn_piercing_projectile(actor.global_position, direction)
	
	await get_tree().create_timer(0.5).timeout
	termino_de_disparar.emit()

func _exit_state() -> void:
	set_physics_process(false)
