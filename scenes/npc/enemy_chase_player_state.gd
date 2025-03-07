class_name EnemyChasePlayerState
extends State

@export var actor: EnemyBoss
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D

var player: Node2D = null

signal lost_player

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	player = $"../..".player_node
	animator.play("walk")
	actor.update_text("SEGUIR")

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta) -> void:
	if player == null:
		return

	animator.scale.x = -sign(actor.velocity.x)
	if animator.scale.x == 0.0: animator.scale.x = 1.0

	var direction = Vector2.ZERO.direction_to(player.global_position - actor.global_position)
	actor.velocity = actor.velocity.move_toward(direction * actor.max_speed, actor.acceleration * delta)
	actor.move_and_slide()

	if vision_cast.is_colliding():
		var collider = vision_cast.get_collider()
		if collider and !collider.name == "Player":  # Asegúrate de que el jugador esté en el grupo "player"
			lost_player.emit()
