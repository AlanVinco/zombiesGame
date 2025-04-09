class_name ZombieJumpState
extends State

@export var actor: EnemyBoss
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D

signal terminar_de_brincar

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	$"../../Voice".stream = load("res://sound/sounds/Nueva carpeta/gordo_1_.ogg")
	$"../../Voice".play()
	$"../../AreaDañarPlayer/CollisionShape2D".disabled = true
	$"../../AreaBajaSalud/CollisionShape2D".disabled = true
	$"../../CollisionShape2D".disabled = true
	set_physics_process(true)
	animator.play("jump")
	actor.update_text("JUMP")
	
	await get_tree().create_timer(13.0).timeout
	terminar_de_brincar.emit()

func _exit_state() -> void:
	set_physics_process(false)

#func _on_animated_sprite_2d_animation_finished() -> void:
	#$"../../AnimatedSprite2D".stop()
	#$"../../AnimatedSprite2D".frame = 5
	#print("empezo a contar el tiempo")
	#await get_tree().create_timer(5.0).timeout
	#print("terminaron los 5s")
