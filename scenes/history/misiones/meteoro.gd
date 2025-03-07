class_name Meteor
extends AnimatedSprite2D

func _ready():
	play("fall")  # Reproduce la animación de caída

func play_animation():
	play("fall")  # Reproduce la animación de caída

func _on_animation_finished():
	queue_free()  # Elimina el meteoro cuando la animación termina
