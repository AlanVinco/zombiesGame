class_name CrazyShotState
extends State

@export var actor: RatzwelFinalBoss
@export var shot_interval: float = 0.3  # Tiempo entre disparos
@export var full_rotation_time: float = 3.0  # Tiempo total para completar 360°
@export var random_shot_duration: float = 2.0  # Duración de disparos aleatorios

signal termino_de_disparar

func _enter_state():
	actor.update_text("¡Disparo loco!")
	actor.animator.play("crazy_shot")
	start_spiral_shooting()

func start_spiral_shooting():
	var total_shots = int(full_rotation_time / shot_interval) * 2  # Dos vueltas
	for i in range(total_shots):
		if not get_tree():  # Verifica si la escena sigue activa
			return  # Evita el error si el jugador muere y la escena cambia

		var angle = ((i / float(total_shots)) * TAU)  # TAU = 2*PI (360°)
		var direction = (actor.player_node.global_position - actor.global_position).normalized().rotated(angle)
		actor.spawn_projectile(actor.global_position, direction)

		await get_tree().create_timer(shot_interval).timeout

	start_random_shooting()

func start_random_shooting():
	var end_time = Time.get_ticks_msec() + int(random_shot_duration * 1000)
	while Time.get_ticks_msec() < end_time:
		if not get_tree():  # Verifica si la escena sigue activa
			return  # Evita errores si la escena cambia

		var random_angle = randf_range(0, TAU)
		var direction = Vector2.RIGHT.rotated(random_angle)
		actor.spawn_projectile(actor.global_position, direction)

		await get_tree().create_timer(shot_interval).timeout

	termino_de_disparar.emit()

func _exit_state():
	pass
