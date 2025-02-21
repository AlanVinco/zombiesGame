extends CharacterBody2D

@export var player: NodePath
@onready var player_node = get_node(player)
@export var follow_distance: float = 50.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	animated_sprite.play("idle")
	if player_node:
		position = player_node.position - Vector2(follow_distance, 0)

func _process(delta):
	if player_node:
		var direction = (player_node.position - position)
		
		# Si el NPC está lo suficientemente cerca, lo consideramos quieto
		if direction.length() < 1.0:
			direction = Vector2.ZERO

		# Calcular la posición objetivo con la distancia de seguimiento
		var target_position = player_node.position - direction.normalized() * follow_distance
		
		if player_node.last_direction.x > 0:  # Jugador mirando a la derecha
			target_position = player_node.position - Vector2(follow_distance, 0)
		elif player_node.last_direction.x < 0:  # Jugador mirando a la izquierda
			target_position = player_node.position + Vector2(follow_distance, 0)
		elif player_node.last_direction.y > 0:  # Jugador mirando hacia abajo
			target_position = player_node.position - Vector2(0, follow_distance)
		elif player_node.last_direction.y < 0:  # Jugador mirando hacia arriba
			target_position = player_node.position + Vector2(0, follow_distance)

		# Interpolación para suavizar el movimiento
		position = position.lerp(target_position, 0.1)

		# Actualizar la animación
		update_animation(target_position)

func update_animation(target_position: Vector2):
	var movement = position.distance_to(target_position)

	if movement < 1.0:  # Si la distancia al objetivo es mínima, cambiar a idle
		animated_sprite.play("idle")
	elif abs(target_position.x - position.x) > abs(target_position.y - position.y):  # Movimiento horizontal
		if target_position.x > position.x:
			animated_sprite.play("walk_right")
			animated_sprite.flip_h = false
		else:
			animated_sprite.play("walk_right")
			animated_sprite.flip_h = true
	else:  # Movimiento vertical
		if target_position.y > position.y:
			animated_sprite.play("walk_front")
		else:
			animated_sprite.play("walk_front")
