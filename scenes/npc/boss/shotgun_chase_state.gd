class_name ShotgunChaseState
extends State

@export var actor: RatzwelFinalBoss
var explode_timer = 5.0  # Tiempo antes de explotar

signal  termino_de_caminar

func _ready() -> void:
	set_physics_process(false)

func _enter_state():
	set_physics_process(true)
	actor.update_text("Sigue al jugador")
	actor.animator.play("walkFront")  # Cambiar a animación de brillo
	await get_tree().create_timer(explode_timer).timeout  # Espera antes de explotar

	# Simular explosión
	actor.update_text("!Preparando habilidad!")
	actor.max_speed = 0
	await get_tree().create_timer(1.0).timeout
	#for body in actor.get_overlapping_bodies():
		#if body.name == "Player":
			#body.decrease_life(30)  # Daño al jugador
	termino_de_caminar.emit()

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta) -> void:
	var direction = (actor.player_node.global_position - actor.global_position).normalized()
	actor.velocity = direction * actor.max_speed
	actor.move_and_slide()
