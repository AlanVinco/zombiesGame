class_name MageHurtState
extends State

@export var actor: MageBoss

func _enter_state():
	actor.update_text("le duele")
	actor.animator.play("hurt")
	await get_tree().create_timer(1.0).timeout
	actor.state_machine.change_state("IdleState")
