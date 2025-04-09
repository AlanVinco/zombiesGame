## Estado: Disparo de Escopeta Normal
class_name ShotgunBlastState
extends State

@export var actor: RatzwelFinalBoss
@export var pellet_count: int = 6  # Cantidad de proyectiles
@export var spread_angle: float = PI / 4  # Ángulo de dispersión

signal termino_de_disparar

func _ready() -> void:
	set_physics_process(false)

func _enter_state():
	$"../../Shot".stream = load("res://sound/sounds/shotgun.mp3")
	$"../../Shot".play()
	$"../../Voice".stream = load("res://sound/sounds/Nueva carpeta/shotgun_blast.ogg")
	$"../../Voice".play()
	actor.update_text("¡Escopetazo!")
	actor.animator.play("shot")
	shoot_pellets()
	await get_tree().create_timer(1.0).timeout
	termino_de_disparar.emit()

func shoot_pellets():
	for i in range(pellet_count):
		var angle_offset = randf_range(-spread_angle / 2, spread_angle / 2)
		var direction = (actor.player_node.global_position - actor.global_position).normalized().rotated(angle_offset)
		actor.spawn_projectile(actor.global_position, direction)

func _exit_state() -> void:
	set_physics_process(false)
