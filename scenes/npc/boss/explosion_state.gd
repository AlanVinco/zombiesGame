class_name ExplosionState
extends State

@export var actor: ZombieChain
var explode_timer = 3.0  # Tiempo antes de explotar

signal  termino_de_explotar

func _ready() -> void:
	set_physics_process(false)

func _enter_state():
	actor.max_speed = 100
	set_physics_process(true)
	actor.update_text("¡Va a explotar!")
	actor.animator.play("va_explotar")  # Cambiar a animación de brillo
	await get_tree().create_timer(explode_timer).timeout  # Espera antes de explotar

	# Simular explosión
	actor.update_text("¡BOOM!")
	$"../../Explosion/CollisionShape2D".disabled = false
	await get_tree().create_timer(0.1).timeout
	$"../../Explosion/CollisionShape2D".disabled = true
	actor.max_speed = 0
	actor.animator.play("exploto")
	await get_tree().create_timer(1.0).timeout
	#for body in actor.get_overlapping_bodies():
		#if body.name == "Player":
			#body.decrease_life(30)  # Daño al jugador
	termino_de_explotar.emit()

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta) -> void:
	var direction = (actor.player_node.global_position - actor.global_position).normalized()
	actor.velocity = direction * actor.max_speed
	actor.move_and_slide()
