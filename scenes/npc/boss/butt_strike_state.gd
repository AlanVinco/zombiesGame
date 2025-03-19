## Estado: Golpe con la Cacha
class_name ButtStrikeState
extends State

@export var actor: RatzwelFinalBoss

signal termino_de_golpear

func _enter_state():
	actor.update_text("¡Golpe con la cacha!")
	actor.animator.play("butt_strike")
	await get_tree().create_timer(0.5).timeout
	if actor.player_node and actor.global_position.distance_to(actor.player_node.global_position) < 50:
		actor.player_node.decrease_life(10)  # Daño al jugador
	termino_de_golpear.emit()

func _exit_state():
	pass
