extends Node2D

@onready var player = $Player
@onready var boss = $RatzwelFinalBoss
var scene = "res://scenes/visualnovel.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.collect_item("Balas", 500)
	boss.endScene.connect(change_visual)


func change_visual():
	await get_tree().create_timer(3.0).timeout
	##AGREGAR RECOMPENSA
	Stats.missions = 5
	Stats.visualNovel = "ENDPART2"
	#player.collect_item("Comida", 8)
	GlobalTransitions.transition()
	GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
	GlobalTransitions.player_position_city = Vector2(342, -18)
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(scene)
