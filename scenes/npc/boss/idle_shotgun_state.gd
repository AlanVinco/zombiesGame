class_name IdleShotgunState
extends State

@export var actor: RatzwelFinalBoss

signal ShotgunBlast_State
signal PiercingShot_State
signal ShotgunSweep_State
signal CrazyShot_State

signal ImpactCharge_State
signal ButtStrike_State

func _ready() -> void:
	set_physics_process(false)

func _enter_state():
	actor.velocity = Vector2.ZERO
	set_physics_process(true)
	#$"../../AreaaDañoPlayer/CollisionShape2D".disabled = false
	actor.update_text("idle")
	actor.animator.play("idle")
	await get_tree().create_timer(2.0).timeout  # Espera antes de elegir acción
	
	var decision = randi_range(0, 3)
	print(decision)
	match decision:
		0:
			ShotgunBlast_State.emit()
		1:
			PiercingShot_State.emit()
		2:
			ShotgunSweep_State.emit()
		3:
			CrazyShot_State.emit()

func _exit_state() -> void:
	set_physics_process(false)
