extends Area2D

@export var direction = 0

signal hit_player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ChainCadena2.play()
	$AnimatedSprite2D.play("chain")
	await get_tree().create_timer(0.3).timeout
	$CollisionShape2D.disabled = false
	await get_tree().create_timer(1.0).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		hit_player.emit()
		queue_free()
