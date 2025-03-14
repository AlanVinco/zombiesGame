class_name Meteor
extends AnimatedSprite2D

@onready var punchArea = $Meteoros/CollisionShape2D
@export var damage = 5

func _ready() -> void:
	$Animacion.play("metorFinal")
	$Area2D/CollisionShape2D.disabled = true

func _on_animation_finished():
	queue_free()  # Elimina el meteoro cuando la animación termina


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.decrease_life(damage)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		print("no pEGOaaa")

func _on_animacion_frame_changed() -> void:
	if $Animacion.frame == 3:
		$Area2D/CollisionShape2D.disabled = false
	else:
		$Area2D/CollisionShape2D.disabled = true
