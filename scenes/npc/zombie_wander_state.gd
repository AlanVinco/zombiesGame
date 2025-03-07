class_name EnemyWanderState
extends State

@export var actor: EnemyBoss
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D

signal found_player
signal jump

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	animator.play("idle")
	actor.update_text("DEAMBULAR")
	if actor.velocity == Vector2.ZERO:
		actor.velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * actor.max_speed
	
	$"../../Timer".start()

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	animator.scale.x = -sign(actor.velocity.x)
	if animator.scale.x == 0.0: animator.scale.x = 1.0
	
	actor.velocity = actor.velocity.move_toward(actor.velocity.normalized() * actor.max_speed, actor.acceleration * delta)
	var collision = actor.move_and_collide(actor.velocity * delta)
	if collision:
		var bounce_velocity = actor.velocity.bounce(collision.get_normal())
		actor.velocity = bounce_velocity
	if vision_cast.is_colliding():
		var collider = vision_cast.get_collider()
		if collider and collider.name == "Player":  # Asegúrate de que el jugador esté en el grupo "player"
			found_player.emit()
			$"../../Timer".stop()
			#await get_tree().create_timer(3.0).timeout
			#jump.emit()

func _on_timer_timeout() -> void:
	jump.emit()
