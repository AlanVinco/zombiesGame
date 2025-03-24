class_name DieState
extends State

@export var actor: ZombieChain
signal muerto 

func _ready() -> void:
	set_physics_process(false)

func _enter_state():
	$"../../Chaindie".play()
	$"../../Explosion2".play()
	set_physics_process(true)
	actor.update_text("¡Muerto!")
	actor.animator.play("death")
	actor.is_dead = true
	await get_tree().create_timer(3.0).timeout  
	muerto.emit() 
	
func _exit_state() -> void:
	set_physics_process(false)
