extends Node2D

@onready var bar = $".."
@onready var player = $"../Player"
@onready var Havany = $"../HavanyNpcState"
@onready var decision_manager = $"../DecisionManager"
@onready var canvasDesicion = $"../CanvasLayer"

var nextScene = "res://scenes/maps/house.tscn"
var current_node = "hw1"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#condicionar
	
	if Stats.girlWork == 0:
		bar.pedir_trabajo.connect(pedir_trabajo)
		#DECISION
		decision_manager.decision_taken.connect(_on_decision_taken)
		decision_manager.current_node = current_node
		if Stats.MALO == 0:
			actos = {
				1: { "textos": ["girl_work1_txt1",], "personaje": "MESERO", "emocion": "NORMAL" },
				2: { "textos": ["girl_work1_txt2",], "personaje": "HAVANY", "emocion": "NORMAL" },
				3: { "textos": ["girl_work1_txt3", "girl_work1_txt4", "girl_work1_txt5", "girl_work1_txt6", "girl_work1_txt7"], "personaje": "MESERO", "emocion": "NORMAL" },
				4: { "textos": ["girl_work1_txt8",], "personaje": "HAVANY", "emocion": "NORMAL" },
				6: { "textos": ["girl_work1_resp1"], "personaje": "MESERO", "emocion": "NORMAL" },
				8: { "textos": ["girl_work1_resp2",], "personaje": "MESERO", "emocion": "NORMAL" },
			}
		elif Stats.MALO == 20:
			actos = {
				1: { "textos": ["girl_work1_txt1",], "personaje": "MESERO", "emocion": "NORMAL" },
				2: { "textos": ["girl_work1_txt2",], "personaje": "HAVANYCORTA", "emocion": "NORMAL" },
				3: { "textos": ["girl_work1_txt3", "girl_work1_txt4", "girl_work1_txt5", "girl_work1_txt6", "girl_work1_txt7"], "personaje": "MESERO", "emocion": "NORMAL" },
				4: { "textos": ["girl_work1_txt8",], "personaje": "HAVANYCORTA", "emocion": "NORMAL" },
				6: { "textos": ["girl_work1_resp1"], "personaje": "MESERO", "emocion": "NORMAL" },
				8: { "textos": ["girl_work1_resp2",], "personaje": "MESERO", "emocion": "NORMAL" },
			}
		elif Stats.MALO == 40:
			actos = {
				1: { "textos": ["girl_work1_txt1",], "personaje": "MESERO", "emocion": "NORMAL" },
				2: { "textos": ["girl_work1_txt2",], "personaje": "HAVANYCORTA2", "emocion": "NORMAL" },
				3: { "textos": ["girl_work1_txt3", "girl_work1_txt4", "girl_work1_txt5", "girl_work1_txt6", "girl_work1_txt7"], "personaje": "MESERO", "emocion": "NORMAL" },
				4: { "textos": ["girl_work1_txt8",], "personaje": "HAVANYCORTA2", "emocion": "NORMAL" },
				6: { "textos": ["girl_work1_resp1"], "personaje": "MESERO", "emocion": "NORMAL" },
				8: { "textos": ["girl_work1_resp2",], "personaje": "MESERO", "emocion": "NORMAL" },
			}
		elif Stats.MALO == 60:
			actos = {
				1: { "textos": ["girl_work1_txt1",], "personaje": "MESERO", "emocion": "NORMAL" },
				2: { "textos": ["girl_work1_txt2",], "personaje": "HAVANYCORTA3", "emocion": "NORMAL" },
				3: { "textos": ["girl_work1_txt3", "girl_work1_txt4", "girl_work1_txt5", "girl_work1_txt6", "girl_work1_txt7"], "personaje": "MESERO", "emocion": "NORMAL" },
				4: { "textos": ["girl_work1_txt8",], "personaje": "HAVANYCORTA3", "emocion": "NORMAL" },
				6: { "textos": ["girl_work1_resp1"], "personaje": "MESERO", "emocion": "NORMAL" },
				8: { "textos": ["girl_work1_resp2",], "personaje": "MESERO", "emocion": "NORMAL" },
			}
		else:
			actos = {
				1: { "textos": ["girl_work1_txt1",], "personaje": "MESERO", "emocion": "NORMAL" },
				2: { "textos": ["girl_work1_txt2",], "personaje": "HAVANYNUDE", "emocion": "NORMAL" },
				3: { "textos": ["girl_work1_txt3", "girl_work1_txt4", "girl_work1_txt5", "girl_work1_txt6", "girl_work1_txt7"], "personaje": "MESERO", "emocion": "NORMAL" },
				4: { "textos": ["girl_work1_txt8",], "personaje": "HAVANYNUDE", "emocion": "NORMAL" },
				6: { "textos": ["girl_work1_resp1"], "personaje": "MESERO", "emocion": "NORMAL" },
				8: { "textos": ["girl_work1_resp2",], "personaje": "MESERO", "emocion": "NORMAL" },
			}

func pedir_trabajo():
	GlobalTransitions.transition()
	await get_tree().create_timer(0.5).timeout
	player.visible = false
	player.move = false
	Havany.visible = true
	bar.on_all_texts_displayed.connect(_on_all_texts_displayed)
	await get_tree().create_timer(1.0).timeout
	mostrar_acto(Acto, actos)

var Acto = 1

var actos = {
	1: { "textos": ["girl_work1_txt1",], "personaje": "MESERO", "emocion": "NORMAL" },
	2: { "textos": ["girl_work1_txt2",], "personaje": "HAVANY", "emocion": "NORMAL" },
	3: { "textos": ["girl_work1_txt3", "girl_work1_txt4", "girl_work1_txt5", "girl_work1_txt6", "girl_work1_txt7"], "personaje": "RATZWEL", "emocion": "NORMAL" },
	4: { "textos": ["girl_work1_txt8",], "personaje": "HAVANY", "emocion": "NORMAL" },
	6: { "textos": ["girl_work1_resp1"], "personaje": "MESERO", "emocion": "NORMAL" },
	8: { "textos": ["girl_work1_resp2",], "personaje": "MESERO", "emocion": "NORMAL" },
	}

func mostrar_acto(acto_numero, actos):
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		if Stats.MALO == 20:
			if acto_data["personaje"] != "MESERO":
				acto_data["personaje"] = "HAVANYCORTA1"
		if Stats.MALO == 40:
			if acto_data["personaje"] != "MESERO":
				acto_data["personaje"] = "HAVANYCORTA2"
		if Stats.MALO == 60:
			if acto_data["personaje"] != "MESERO":
				acto_data["personaje"] = "HAVANYCORTA3"
		if Stats.MALO >= 80:
			if acto_data["personaje"] != "MESERO":
				acto_data["personaje"] = "HAVANYNUDE"
		bar.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + 1
	elif acto_numero == 5:
		$"../CanvasLayer".visible = true
		decision_manager.current_node = current_node
		decision_manager.mostrar_decision()
		
	elif acto_numero == 9:
		GlobalTransitions.transition()
		$"../CanvasLayer".visible = false
		await get_tree().create_timer(0.5).timeout
		Havany.visible = false
		player.visible = true
		player.move = true
		Acto = 1
		#audio_player.stream = load("res://sound/sounds/door_knoc_and_ooen.mp3")
		#audio_player.play()
		#Acto = acto_numero + 1
		#await get_tree().create_timer(1.0).timeout
		#mostrar_acto(Acto, actos)
	else:
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		Stats.time = "night"
		#Stats.ntrGirl = 1
		GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
		GlobalTransitions.player_position_city = Vector2(342, -18)
		get_tree().change_scene_to_file(nextScene)

func _on_all_texts_displayed():
	mostrar_acto(Acto, actos)

#NUEVO
func _on_decision_taken(opcion):
	if opcion == "aceptar":
		Stats.girlWork = 1
		mostrar_acto(6, actos)
	elif opcion == "rechazar":
		
		Stats.girlWork = 0
		mostrar_acto(8, actos)
