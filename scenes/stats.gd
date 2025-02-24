extends Node2D


@export var life = 100
@export var stamina = 50
@export var damage = 5
@export var armor = 0
@export var speed = 200
@export var cor = 100
@export var hambre = 100
@export var day = 0
#POINTS
@export var HUSBAND = 100
@export var MALO = 0
@export var ZOMBIE = 0
#POINTS
@export var time = "day"
@export var actions_left: int = 3  # Acciones restantes por día
@export var hearts = 3
@export var missions = 1
@export var playerWork = 0
@export var girlWork = 0
@export var ntrGirl = 0
# Función para avanzar el tiempo según la acción realizada
func advance_time():
	hunger(20)
	locura(20)
	if actions_left > 1:
		actions_left -= 1
		match time:
			"day":
				GlobalTransitions.transition()
				await get_tree().create_timer(0.5).timeout
				time = "afternoon"
			"afternoon":
				GlobalTransitions.transition()
				await get_tree().create_timer(0.5).timeout
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
	GlobalTransitions.nex_day_animation()
	print("Nuevo día iniciado")

func new_mission():
	missions += 1

func hunger(value):
	hambre -=value

func locura(value):
	cor -=value

func sumar_esposa_points(person, value):
	if person == "HUSBAND":
		HUSBAND += value
		print(" suma AHORA LOS PUNTOS DE HUSBAND SON: ", HUSBAND)
	if person == "MALO":
		MALO += value
		print("suma AHORA LOS PUNTOS DE HUSBAND SON: ", MALO)
	if person == "ZOMBIE":
		ZOMBIE += value
		print("suma AHORA LOS PUNTOS DE HUSBAND SON: ", ZOMBIE)

func restar_esposa_points(person, value):
	if person == "HUSBAND":
		HUSBAND -= value
		print(" resta AHORA LOS PUNTOS DE HUSBAND SON: ", HUSBAND)
	if person == "MALO":
		MALO -= value
		print("resta AHORA LOS PUNTOS DE HUSBAND SON: ", MALO)
	if person == "ZOMBIE":
		ZOMBIE -= value
		print("resta AHORA LOS PUNTOS DE HUSBAND SON: ", ZOMBIE)
