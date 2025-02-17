extends Node2D

@export var player = null

func _on_mancuernas_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		$mancuernas/ButtonDamage.visible = true

func _on_mancuernas_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player = null
		$mancuernas/ButtonDamage.visible = false

func _on_button_damage_pressed() -> void:
	Stats.damage += 1
	player.show_stats()
	
