extends RigidBody2D

class_name Bullet

var velocity = Vector2(1,0)
var speed = 400
@export var damage = 5

@export var bulletDamage = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("shot")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#position.x += speed * delta
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombie"):
		speed = 0
		$AnimatedSprite2D.play("destroy")
		var knockback_direction = (body.position - position).normalized()
		body.apply_knockback(knockback_direction)
		body.decrease_life(damage)
	if body.is_in_group("BOSS"):
		print("la bala le pego al boss")
		body.decrease_boos_life()

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "destroy":
		queue_free()
