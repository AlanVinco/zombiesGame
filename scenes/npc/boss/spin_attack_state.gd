class_name SpinAttackState
extends State

@export var actor: ZombieChain
@export var vision_cast: RayCast2D
var spin_duration = 10.0  # Duración del giro
var spin_speed = 300.0
var timer = 0.0

signal termino_de_girar

func _ready() -> void:
	set_physics_process(false)

func _enter_state():
	actor.max_speed = 300
	set_physics_process(true)
	actor.update_text("¡Gira como loco!")
	actor.animator.play("spin")
	timer = spin_duration
	actor.velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * actor.max_speed

func _physics_process(delta):
	if timer > 0:
		timer -= delta
		actor.velocity = actor.velocity.move_toward(actor.velocity.normalized() * actor.max_speed, actor.acceleration * delta)
		var collision = actor.move_and_collide(actor.velocity * delta)
		if collision:
			var bounce_velocity = actor.velocity.bounce(collision.get_normal())
			actor.velocity = bounce_velocity
	else:
		termino_de_girar.emit()

func _exit_state() -> void:
	set_physics_process(false)
