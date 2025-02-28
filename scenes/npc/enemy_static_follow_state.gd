class_name EnemyStaticFollowState
extends State

@export var actor: Enemy
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D

var is_moving: bool = false  # Controlar si el NPC está en movimiento

signal move_manually_stop

func _ready() -> void:
	actor.max_speed = 40.0
	actor.acceleration = 50.0
	set_physics_process(false)
	move_to_target(actor.move_to)

func _enter_state() -> void:
	set_physics_process(true)
	animator.play("walk")
	actor.update_text("MOVIMIENTO MANUAL")
	move_to_target(actor.move_to)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if is_moving:
		# Calcular la dirección hacia el objetivo
		var direction = (actor.move_to - actor.global_position).normalized()
		
		# Mover al NPC usando la velocidad y la aceleración
		actor.velocity = actor.velocity.move_toward(direction * actor.max_speed, actor.acceleration * delta)
		actor.move_and_slide()
		
		# Verificar si el NPC está lo suficientemente cerca del objetivo
		if actor.global_position.distance_to(actor.move_to) < 5.0:  # Umbral de 5 píxeles
			is_moving = false  # Detener el movimiento
			actor.velocity = Vector2.ZERO  # Reiniciar la velocidad
			move_manually_stop.emit()  # Emitir la señal de detención
			actor.move_manually = false

# Función para iniciar el movimiento hacia un objetivo
func move_to_target(target_position: Vector2) -> void:
	is_moving = true
