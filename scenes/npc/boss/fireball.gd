class_name Fireball
extends Area2D

@export var speed: float = 200.0
var direction: Vector2 = Vector2.ZERO
@export var damage = 5

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.name == "Player":
		body.decrease_life(damage)  # Resta vida al jugador
		queue_free()  # Destruye la bola


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()  # Destruye la bola
