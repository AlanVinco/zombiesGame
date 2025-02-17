extends Node

@export var player_position_house_hall:Vector2 = Vector2(18, 22)
@export var player_position_house_room:Vector2 = Vector2()
@export var player_position_city:Vector2 = Vector2(342, -18)
@export var player_position_forest:Vector2 = Vector2()

@onready var canvas = $CanvasModulate

# Función para cambiar el color del ambiente según la hora
func update_time_visuals():
	match Stats.time:
		"night":
			canvas.color = Color("#54469f")
		"afternoon":
			canvas.color = Color("#e27c20")
		_:
			canvas.color = Color("#ffffff")

# Escucha cambios en el tiempo cada vez que se actualiza
func _process(delta):
	update_time_visuals()
