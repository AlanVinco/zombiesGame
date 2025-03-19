class_name ChainIdleState
extends State

@export var actor: ZombieChain

signal spin_attack
signal hook_attack
signal explosion_attack

func _ready() -> void:
	set_physics_process(false)

func _enter_state():
	set_physics_process(true)
	#$"../../AreaaDañoPlayer/CollisionShape2D".disabled = false
	actor.update_text("idle")
	actor.animator.play("idle")
	await get_tree().create_timer(2.0).timeout  # Espera antes de elegir acción
	#spin_attack.emit()
	
	var decision = randi_range(0, 2)
	print(decision)
	match decision:
		0:
			explosion_attack.emit()
		1:
			spin_attack.emit()
		2:
			hook_attack.emit()

func _exit_state() -> void:
	set_physics_process(false)
