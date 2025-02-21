extends Node2D

var scene = "res://scenes/maps/house.tscn"

func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file(scene)
