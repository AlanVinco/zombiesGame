## Estado: Golpe con la Cacha
class_name ButtStrikeState
extends State

@export var actor: RatzwelFinalBoss
@export var knockback_force: float = 300.0  # Intensidad del empuje

signal termino_de_golpear

func _enter_state():
	$"../../Voice".stream = load("res://sound/sounds/Nueva carpeta/butt_strike.ogg")
	$"../../Voice".play()
	set_physics_process(true)
	actor.update_text("¡Golpe con la cacha!")
	actor.animator.play("shot")
	apply_knockback()
	await get_tree().create_timer(0.5).timeout
	termino_de_golpear.emit()

func apply_knockback():
	var direction = (actor.player_node.global_position - actor.global_position).normalized() * -1
	if actor.player_node.has_method("apply_force"):
		actor.player_node.apply_force(direction * knockback_force)

func _exit_state():
	set_physics_process(false)
