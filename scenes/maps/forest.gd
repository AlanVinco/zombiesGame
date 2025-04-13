extends Node2D

var scene = "res://scenes/maps/city.tscn"
@onready var player = $Player

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$Area2D/Button.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$Area2D/Button.visible = false

func _on_button_pressed() -> void:
	GlobalTransitions.transition()
	await get_tree().create_timer(0.5).timeout
	if Stats.time == "day" or Stats.time == "afternoon":
		Stats.advance_time()
	get_tree().change_scene_to_file(scene)

#SPAWN AREA

@export var zombie_scene: PackedScene
@export var min_zombies: int = 3
@export var max_zombies: int = 6

var time_of_day: String = "day"  # Puede ser "day", "evening", "night"

# Definir cantidad de zombies según el tiempo del día
var zombie_counts = {
	"day": [25, 30],      # Menos zombies de día
	"evening": [60, 80],  # Zombies moderados al atardecer
	"night": [100, 120]    # Más zombies de noche
}

func _ready():
	MusicManager.music_player["parameters/switch_to_clip"] = "FOREST_THEME"
	MusicManager.start_loop_for("FOREST_THEME")
	spawn_zombies()

func spawn_zombies():
	var spawn_area = $SpawnArea/CollisionShape2D.shape.get_rect()
	var spawn_range = zombie_counts.get(time_of_day, [min_zombies, max_zombies])
	var min_spawn = spawn_range[0]
	var max_spawn = spawn_range[1]
	var zombie_count = randi_range(min_spawn, max_spawn)

	for i in range(zombie_count):
		var zombie = zombie_scene.instantiate()
		var random_x = randf_range(spawn_area.position.x, spawn_area.end.x)
		var random_y = randf_range(spawn_area.position.y, spawn_area.end.y)
		zombie.position = Vector2(random_x, random_y)
		add_child(zombie)
