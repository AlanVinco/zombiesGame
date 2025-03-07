class_name EnemyJumpState
extends State

@export var actor: EnemyBoss
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D

signal terminar_de_brincar

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	animator.play("jump")
	actor.update_text("JUMP")

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta) -> void:
	pass
