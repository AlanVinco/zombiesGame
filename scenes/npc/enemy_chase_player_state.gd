class_name EnemyChasePlayerState
extends State

@export var actor: EnemyBoss
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D

var player: Node2D = null

signal lost_player
signal charge_signal  # Nueva señal para activar la carga

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	$"../../AreaDañarPlayer/CollisionShape2D".disabled = false
	$"../../AnimatedSprite2D".visible = true
	$"../../Animations".visible = false
	set_physics_process(true)
	player = $"../..".player_node
	animator.play("walk")
	$"../../Animations".play("walk")
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

	# Si el jugador está muy cerca, hacer que el jefe cargue
	if actor.global_position.distance_to(player.global_position) < 100.0:
		charge_signal.emit()
	
	if vision_cast.is_colliding():
		var collider = vision_cast.get_collider()
		if collider and !collider.name == "Player":
			lost_player.emit()
