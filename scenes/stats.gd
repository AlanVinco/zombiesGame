extends Node2D


@export var life = 100
@export var stamina = 50
@export var damage = 5
@export var armor = 0
@export var speed = 200
@export var cor = 100
@export var hambre = 100
@export var day = 0
@export var WIFE = 100
@export var time = "day"
@export var actions_left: int = 3  # Acciones restantes por día
@export var hearts = 3
@export var missions = 1
# Función para avanzar el tiempo según la acción realizada
func advance_time():
	hunger(20)
	locura(20)
	if actions_left > 1:
		actions_left -= 1
		match time:
			"day":
				time = "afternoon"
			"afternoon":
				time = "night"
	else:
		# Si ya no hay acciones, resetea el día
		reset_day()

	print("Nuevo tiempo:", time, "- Acciones restantes:", actions_left)

# Función para reiniciar el día al dormir
func reset_day():
	day += 1
	time = "day"
	actions_left = 3
	print("Nuevo día iniciado")

func new_mission():
	missions += 1

func hunger(value):
	hambre -=value

func locura(value):
	cor -=value
