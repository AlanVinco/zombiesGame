extends Node2D

@onready var player = $Player

var scene_paths = {
	"gym": "res://scenes/maps/gym.tscn",
	"house": "res://scenes/maps/house.tscn",
	"forest": "res://scenes/maps/forest.tscn",
	"bar": "res://scenes/maps/bar.tscn",
	"office": "res://scenes/maps/office.tscn",
	"gunShop": "res://scenes/maps/gunshop.tscn",
	"shop": "res://scenes/maps/market.tscn",
	# Agrega más escenas aquí si es necesario
}

func _ready() -> void:
	player.position = GlobalTransitions.player_position_city
	position_npc()

	# Conectar dinámicamente las señales de todas las áreas
	for area in get_tree().get_nodes_in_group("transition_areas"):
		area.body_entered.connect(_on_area_entered.bind(area))
		area.body_exited.connect(_on_area_exited.bind(area))

func _on_area_entered(body: Node2D, area: Area2D) -> void:
	if body.name == "Player":
		var button = area.get_node_or_null("Button")
		if button:
			button.visible = true
			button.pressed.connect(_on_button_pressed.bind(area.name))

func _on_area_exited(body: Node2D, area: Area2D) -> void:
	if body.name == "Player":
		var button = area.get_node_or_null("Button")
		if button:
			button.visible = false
			button.pressed.disconnect(_on_button_pressed.bind(area.name))

func _on_button_pressed(area_name: String) -> void:
	if area_name in scene_paths:
		Transition()
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(scene_paths[area_name])

func Transition():
	GlobalTransitions.player_position_city = player.position

func position_npc():
	if Stats.girlWork == 3:
		$bar/NPCS3.visible = true
	else:
		$bar/NPCS3.visible = false
