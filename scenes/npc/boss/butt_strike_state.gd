class_name DieRatzwelState
extends State

@export var actor: RatzwelFinalBoss
signal muerto 

func _ready() -> void:
	set_physics_process(false)

func _enter_state():
	print("entro en el state muerto")
	$"../../Voice".stream = load("res://sound/sounds/Nueva carpeta/EXPLOSION.ogg")
	$"../../Voice".play()
	set_physics_process(true)
	actor.update_text("¡Muerto!")
	actor.animator.play("dead")
	actor.is_dead = true
	await get_tree().create_timer(3.0).timeout  
	muerto.emit() 
	
func _exit_state() -> void:
	set_physics_process(false)
