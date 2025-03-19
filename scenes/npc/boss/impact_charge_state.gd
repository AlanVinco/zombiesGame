## Estado: Carga de Impacto
class_name ImpactChargeState
extends State

@export var actor: RatzwelFinalBoss
@export var charge_speed: float = 250.0

signal termino_de_cargar

func _enter_state():
	actor.update_text("¡Carga de impacto!")
	actor.animator.play("charge")
	var direction = (actor.player_node.global_position - actor.global_position).normalized()
	actor.velocity = direction * charge_speed
	set_physics_process(true)

func _physics_process(delta):
	var collision = actor.move_and_collide(actor.velocity * delta)
	if collision:
		actor.update_text("¡Aturdido!")
		actor.animator.play("stunned")
		actor.velocity = Vector2.ZERO
		await get_tree().create_timer(2.0).timeout  # Tiempo de aturdimiento
		termino_de_cargar.emit()

func _exit_state():
	set_physics_process(false)
