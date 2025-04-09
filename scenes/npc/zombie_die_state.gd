class_name ZombieDieState
extends State

@export var actor: EnemyBoss
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D

signal muerto  

func _enter_state() -> void:
	$"../../Voice".stream = load("res://sound/sounds/Nueva carpeta/EXPLOSION.ogg")
	$"../../Voice".play()
	actor.update_text("muerto")
	$"../../AreaDañarPlayer/CollisionShape2D".disabled = true
	$"../../AreaBajaSalud/CollisionShape2D".disabled = true
	animator.visible = true
	actor.velocity = Vector2.ZERO
	actor.set_physics_process(false)
	actor.set_process(false)
	actor.set_process_input(false)

	if actor.has_node("CollisionShape2D"):
		actor.get_node("CollisionShape2D").disabled = true  

	animator.play("dead")
	actor.update_text("MUERTO")

	await get_tree().create_timer(3.0).timeout  
	muerto.emit()  
