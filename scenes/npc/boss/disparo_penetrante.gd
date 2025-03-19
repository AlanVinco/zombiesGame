class_name PiercingProjectile
extends CharacterBody2D

@export var speed: float = 400.0
@export var max_distance: float = 1000.0  # Distancia máxima antes de desaparecer

var start_position: Vector2

func initialize(direction: Vector2):
	velocity = direction * speed
	start_position = global_position

func _physics_process(delta):
	move_and_slide()
	
	# Desaparecer si viaja demasiado lejos
	if global_position.distance_to(start_position) > max_distance:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
