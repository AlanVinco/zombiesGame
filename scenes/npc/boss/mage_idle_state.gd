class_name MageIdleState
extends State

@export var actor: MageBoss

signal señal_invocar

func _enter_state():
	actor.is_invulnerable = true
	$"../../AreaaDañoPlayer/CollisionShape2D".disabled = false
	actor.update_text("idle")
	actor.animator.play("idle")
	await get_tree().create_timer(2.0).timeout  # Espera antes de elegir acción
	señal_invocar.emit()
	
	#var decision = randi_range(0, 1)
	#if decision == 0:
		#señal_invocar.emit()
	#else:
		#actor.state_machine.change_state("InvulnerableState")
