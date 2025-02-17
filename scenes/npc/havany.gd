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
		var direction = (player_node.position - position).normalized()
		var target_position = player_node.position - direction * follow_distance
		
		# Ajustar la posición del NPC para que siempre esté detrás del jugador
		if player_node.last_direction.x > 0:  # Jugador mirando a la derecha
			target_position = player_node.position - Vector2(follow_distance, 0)
		elif player_node.last_direction.x < 0:  # Jugador mirando a la izquierda
			target_position = player_node.position + Vector2(follow_distance, 0)
		elif player_node.last_direction.y > 0:  # Jugador mirando hacia abajo
			target_position = player_node.position - Vector2(0, follow_distance)
		elif player_node.last_direction.y < 0:  # Jugador mirando hacia arriba
			target_position = player_node.position + Vector2(0, follow_distance)
		
		position = position.lerp(target_position, 0.1)
		
		# Actualizar la animación del NPC
		update_animation(direction)

func update_animation(direction: Vector2):
	animated_sprite.play("idle")
	#if direction.x > 0:
		#animated_sprite.play("walk_right")
		#animated_sprite.flip_h = false
	#elif direction.x < 0:
		#animated_sprite.play("walk_right")
		#animated_sprite.flip_h = true
	#elif direction.y > 0:
		#animated_sprite.play("walk_front")
	#elif direction.y < 0:
		#animated_sprite.play("walk_back")
