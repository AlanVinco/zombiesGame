class_name Projectile
extends CharacterBody2D

@export var speed: float = 300.0

@export var damage = 20

func initialize(direction: Vector2):
	velocity = direction * speed

func _physics_process(delta):
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.decrease_life(damage)  # Resta vida al jugador
		queue_free()  # Destruye la bola
