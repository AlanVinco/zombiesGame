# En el script de la escena principal (main_scene.gd)
extends Node2D

@export var zombie_scene: PackedScene
@export var min_zombies: int = 3
@export var max_zombies: int = 6

var time_of_day: String = "day"  # Puede ser "day", "evening", "night"
var zombies_killed: int = 0  # Contador de zombies eliminados

# Definir cantidad de zombies según el tiempo del día
var zombie_counts = {
	"day": [25, 25],      # Menos zombies de día
}

func _ready():
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
		# Conectar la señal usando un Callable
		zombie.connect("zombie_killed", Callable(self, "_on_zombie_killed"))
		add_child(zombie)
		

func _on_zombie_killed():
	zombies_killed += 1
	print("Zombies eliminados: ", zombies_killed)
	if zombies_killed == 25:
		pass
		#siguiente escena
