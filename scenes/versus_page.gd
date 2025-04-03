extends Control

@onready var protagonist = $Versus/Player
@onready var boss = $Versus/Boss
@onready var vs_logo = $Versus/Vs
@onready var tween = get_tree().create_tween()  # Crear el Tween correctamente
@export var mission = 1
@export var scene = ""

signal intro_finished  # Señal para indicar que terminó la animación

func _ready():
	
	match mission:
		1:
			scene = "res://scenes/history/misiones/mision_1.tscn"
			MusicManager.music_player["parameters/switch_to_clip"] = "BATTLE_1_THEME"

		2:
			boss.texture = load("res://assets/monsters/PORTADA/BIGZOMBIEBOSS.png")
			scene = "res://scenes/history/misiones/mision_2.tscn"
		3:
			boss.texture = load("res://assets/monsters/PORTADA/MAGUEBOSS.png")
			scene = "res://scenes/history/misiones/mision_3.tscn"
		4:
			boss.texture = load("res://assets/monsters/PORTADA/CHAINBOSS.png")
			scene = "res://scenes/history/misiones/mission_4.tscn"
		5:
			MusicManager.music_player["parameters/switch_to_clip"] = "FINAL_BATTLE_THEME"
			scene = "res://scenes/history/misiones/mission_final.tscn"
	
	start_intro()
	

func start_intro():
	# Posiciones iniciales (fuera de la pantalla)
	protagonist.position.x = -300  # Fuera de la izquierda
	boss.position.x = get_viewport_rect().size.x + 200  # Fuera de la derecha
	vs_logo.scale = Vector2(0, 0)  # Oculto inicialmente

	# Mover los sprites al centro con efecto "retroceso"
	tween.tween_property(protagonist, "position:x", -80, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(boss, "position:x", get_viewport_rect().size.x - 200, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	await tween.finished  # Esperar a que terminen de moverse
	
	# Aparecer el "VS" con efecto de escala rebote
	tween = get_tree().create_tween()  # Nuevo tween para evitar conflictos
	tween.tween_property(vs_logo, "scale", Vector2(1, 1), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	
	await tween.finished

	# Esperar 2 segundos con la animación en pantalla
	await get_tree().create_timer(2.0).timeout

	# Desvanecer todo
	tween = get_tree().create_tween()
	tween.tween_property(protagonist, "modulate:a", 0, 0.5)
	tween.tween_property(boss, "modulate:a", 0, 0.5)
	tween.tween_property(vs_logo, "modulate:a", 0, 0.5)

	await tween.finished

	# Emitir la señal para indicar que la intro terminó
	intro_finished.emit()
	get_tree().change_scene_to_file(scene)
