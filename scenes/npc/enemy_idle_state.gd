class_name EnemyIdleState
extends State

@export var actor: Enemy
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D

signal see_player
signal move_manually_go

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	animator.play("idle")
	actor.update_text("PARADO")

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta) -> void:
	if not vision_cast.is_colliding() and actor.is_scene == false:
		see_player.emit()
	elif actor.move_manually == true and actor.is_scene == true:
		move_manually_go.emit()
