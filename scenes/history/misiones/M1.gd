extends Node2D

var scene = "res://scenes/maps/house.tscn"
@onready var player = $Player

@onready var text = $TEXT
#SPAWN AREA

@export var zombie_scene: PackedScene
@export var min_zombies: int = 3
@export var max_zombies: int = 6
var zombie_count = 0

var time_of_day: String = "day"  # Puede ser "day", "evening", "night"

# Definir cantidad de zombies según el tiempo del día
var zombie_counts = {
	"day": [25, 25],      # Menos zombies de día
	"evening": [60, 80],  # Zombies moderados al atardecer
	"night": [100, 120]    # Más zombies de noche
}

var actos = {}
var Acto = 1
func _ready():
	text.cargar_csv("res://languages/zombies1DialogV1.csv", "MISSION1FIN", "ms1_fin_txt")
	actos = text.actos
	text.on_all_texts_displayed.connect(_on_all_texts_displayed)
	player.collect_item("Balas", 500)
	player.collect_item("Botiquin", 500)
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
		zombie.zombie_killed.connect(zombie_die)

func zombie_die():
	print("murio zombie")
	zombie_count += 1
	if zombie_count == 25:
		player.move = false
		mostrar_acto(Acto, actos)

func mostrar_acto(acto_numero, actos):
	print(acto_numero)
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		text.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + 1
		
	else:
		Stats.missions = 2
		player.collect_item("Comida", 8)
		GlobalTransitions.transition()
		GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
		GlobalTransitions.player_position_city = Vector2(342, -18)
		await get_tree().create_timer(0.5).timeout
		Stats.time = "night"
		get_tree().change_scene_to_file(scene)

func _on_all_texts_displayed():
	mostrar_acto(Acto, actos)
