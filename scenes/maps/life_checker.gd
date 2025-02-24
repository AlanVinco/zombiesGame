extends Node2D

@export var player: NodePath
@onready var player_node = get_node(player)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	check_life()
	
func check_life():
	if Stats.life <=0 and Stats.hearts >= 0:
		GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
		GlobalTransitions.player_position_city = Vector2(342, -18)
		print("Se desmayo")
		#Escena de  havany diciendole que lo encontraron tirado
		Stats.life = 1
		player_node.health = 1
		player_node.show_stats()
	if Stats.life <=0 and Stats.hearts < 0:
		GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
		GlobalTransitions.player_position_city = Vector2(342, -18)
		player_node.move = false
		await get_tree().create_timer(0.1).timeout
		get_tree().change_scene_to_file("res://scenes/gameover.tscn")
		print("GAME OVER")
		#pantalla de game over
