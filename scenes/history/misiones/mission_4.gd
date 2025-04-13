extends Node2D

@onready var player = $Player
@onready var boss = $BossZombieChain
var scene = "res://scenes/maps/house.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boss.endScene.connect(change_visual)

func change_visual():
	##AGREGAR RECOMPENSA
	Stats.missions = 5
	Stats.time = "night"
	#player.collect_item("Comida", 8)
	GlobalTransitions.transition()
	GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
	GlobalTransitions.player_position_city = Vector2(342, -18)
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(scene)
