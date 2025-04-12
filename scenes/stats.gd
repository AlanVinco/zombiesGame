extends Node2D

signal stat_changed
signal time_changed

# Variables con setters
@export var life: int = 10000:
	set(value):
		life = value
		emit_signal("stat_changed")
		#emit_signal("stat_changed", "life", value)

@export var stamina: int = 50:
	set(value):
		stamina = value
		emit_signal("stat_changed")

@export var damage: int = 5:
	set(value):
		damage = value
		emit_signal("stat_changed")

@export var armor: int = 0:
	set(value):
		armor = value
		emit_signal("stat_changed")

@export var speed: int = 200:
	set(value):
		speed = value
		emit_signal("stat_changed")

@export var cor: int = 100:
	set(value):
		cor = value
		emit_signal("stat_changed")

@export var hambre: int = 100:
	set(value):
		hambre = value
		emit_signal("stat_changed")

@export var day: int = 0:
	set(value):
		day = value
		emit_signal("stat_changed")

@export var HUSBAND: int = 100:
	set(value):
		HUSBAND = value
		emit_signal("stat_changed")

@export var MALO: int = 0:
	set(value):
		MALO = value
		emit_signal("stat_changed")

@export var ZOMBIE: int = 0:
	set(value):
		ZOMBIE = value
		emit_signal("stat_changed")

@export var time: String = "day":
	set(value):
		time = value
		emit_signal("stat_changed")
		emit_signal("time_changed")

@export var actions_left: int = 3:
	set(value):
		actions_left = value
		emit_signal("stat_changed")

@export var hearts: int = 3:
	set(value):
		hearts = value
		emit_signal("stat_changed")

@export var missions: int = 0:
	set(value):
		missions = value
		emit_signal("stat_changed")

@export var playerWork: int = 2:
	set(value):
		playerWork = value
		emit_signal("stat_changed")

@export var girlWork: int = 0:
	set(value):
		girlWork = value
		emit_signal("stat_changed")

@export var ntrGirl: int = 0:
	set(value):
		ntrGirl = value
		emit_signal("stat_changed")

@export var onMission: bool = false:
	set(value):
		onMission = value
		emit_signal("stat_changed")

@export var visualNovel = "":
	set(value):
		visualNovel = value
		if value not in unlocked_scenes:  # Verifica si el valor ya existe
			unlocked_scenes.append(value)  # Solo agrega si no está en la lista
		print(unlocked_scenes)

@export var unlocked_scenes = []

@export var is_recuerdo = false
# Función para avanzar el tiempo según la acción realizada
signal playerInanicion 
signal playerLocura
signal havanyMoney

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
	girl_work()
	print("Nuevo día iniciado")

func new_mission():
	missions += 1

func hunger(value):
	hambre -=value
	if hambre <=0:
		hambre = 1
		emit_signal("playerInanicion")

func locura(value):
	cor -=value
	if cor <=0:
		cor = 1
		emit_signal("playerLocura")

func sumar_esposa_points(person, value):
	if person == "HUSBAND":
		HUSBAND += value
	if person == "MALO":
		MALO += value
	if person == "ZOMBIE":
		ZOMBIE += value

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

func girl_work():
	if girlWork > 0:
		emit_signal("havanyMoney")
		
