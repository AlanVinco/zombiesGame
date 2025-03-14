class_name MageVulnerableState
extends State

@export var actor: MageBoss

signal señal_repetir_ciclo

func _enter_state():
	$"../../AreaaDañoPlayer/CollisionShape2D".disabled = true
	actor.update_text("vulnerable pegar")
	actor.animator.play("vulnerable")
	actor.is_invulnerable = false  # Ahora puede recibir daño
	await get_tree().create_timer(5.0).timeout  # Tiempo para que el jugador lo golpee
	señal_repetir_ciclo.emit()
