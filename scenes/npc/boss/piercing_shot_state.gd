## Estado: Disparo Perforante
class_name PiercingShotState
extends State

@export var actor: RatzwelFinalBoss

signal termino_de_disparar

func _enter_state():
	actor.update_text("¡Cargando disparo!")
	actor.animator.play("charge_shot")
	await get_tree().create_timer(1.5).timeout  # Tiempo de carga
	
	actor.update_text("¡Disparo perforante!")
	actor.animator.play("piercing_shot")
	var direction = (actor.player_node.global_position - actor.global_position).normalized()
	actor.spawn_piercing_projectile(actor.global_position, direction)
	
	await get_tree().create_timer(0.5).timeout
	termino_de_disparar.emit()

func _exit_state():
	pass
