## Estado: Barrido de Escopeta
class_name ShotgunSweepState
extends State

@export var actor: RatzwelFinalBoss
@export var spin_speed: float = PI  # Velocidad de giro

signal termino_de_disparar

func _ready() -> void:
	set_physics_process(false)

func _enter_state():
	$"../../Shot".stream = load("res://sound/sounds/shotgun.mp3")
	$"../../Shot".play()
	$"../../Voice".stream = load("res://sound/sounds/Nueva carpeta/shotgun_sweep.ogg")
	$"../../Voice".play()
	actor.update_text("¡Barrido de escopeta!")
	actor.animator.play("shot")
	var shots = 8
	for i in range(shots):
		var angle = (i / float(shots)) * TAU
		var direction = Vector2.RIGHT.rotated(angle)
		actor.spawn_projectile(actor.global_position, direction)
	await get_tree().create_timer(1.5).timeout
	termino_de_disparar.emit()

func _exit_state() -> void:
	set_physics_process(false)
