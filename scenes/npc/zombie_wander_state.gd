class_name ZombieWanderState
extends State

@export var actor: EnemyBoss
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D

signal found_player
signal jump

var has_jumped = false  # Nueva bandera

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	$"../../AreaDañarPlayer/CollisionShape2D".disabled = false
	$"../../AnimatedSprite2D".visible = true
	$"../../Animations".visible = false
	set_physics_process(true)
	animator.play("idle")
	actor.update_text("DEAMBULAR")
	has_jumped = false  # Restablecer la bandera al entrar en el estado

	if actor.velocity == Vector2.ZERO:
		actor.velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * actor.max_speed

	$"../../Timer".start()

func _exit_state() -> void:
	set_physics_process(false)
	$"../../Timer".stop()  # Detener el temporizador cuando se salga del estado

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
		if collider and collider.name == "Player":  
			found_player.emit()
			$"../../Timer".stop()

func _on_timer_timeout() -> void:
	if not has_jumped:  # Solo emitir si aún no se ha emitido antes
		print("EMITEEE SEÑAAAAAL")
		jump.emit()
		has_jumped = true  # Marcar que ya se emitió
		$"../../Timer".stop()  # Detener el temporizador
