extends Node2D

@export var player: Node2D = null
@export var TextScene: PackedScene

var scene = "res://scenes/history/intro2.tscn"
var sound1 = 0
var Acto = 1
var current_node = "inicio"
var npc_reputation = {}

const SAVE_FILE = "user://decision_tree_save.json"

@onready var lbl_texto = $CanvasLayer/DecisionLabel
@onready var opciones_container = $CanvasLayer/ChoicesContainer
@onready var decision_manager = $DecisionManager

# Diccionario con los diálogos de cada acto
var actos = {
	1: { "textos": ["intro_1_txt1_d1", "intro_1_txt1_d2", "intro_1_txt1_d3"], "personaje": "PLAYER", "emocion": "NORMAL" },
	2: { "textos": ["intro_1_txt2_d1"], "personaje": "RATZWEL", "emocion": "NORMAL" },
	3: { "textos": ["intro_1_txt3_d1", "intro_1_txt3_d2"], "personaje": "PLAYER", "emocion": "NORMAL" },
	4: { "textos": ["intro_1_txt4_d3"], "personaje": "RATZWEL", "emocion": "NORMAL" },
	5: { "textos": ["intro_1_txt5_d1"], "personaje": "HAVANY", "emocion": "NORMAL" },
	6: { "textos": ["intro_1_txt6_d1", "intro_1_txt6_d2", "intro_1_txt6_d3", "intro_1_txt6_d4", "intro_1_txt6_d5"], "personaje": "RATZWEL", "emocion": "NORMAL" },
	9: { "textos": ["intro_1_resp1"], "personaje": "RATZWEL", "emocion": "NORMAL" },
	11: { "textos": ["intro_1_resp2"], "personaje": "RATZWEL", "emocion": "NORMAL" },
}


func _ready() -> void:
	#var source_path = "res://languages/DIALOGOS.csv"
	#var user_path = "user://DIALOGOS.csv"
	## Cargar las traducciones desde el directorio de usuario
	#TranslationManager.load_translations(user_path)
	Stats.time = "night"
	decision_manager.decision_taken.connect(_on_decision_taken)
	decision_manager.cargar_arbol("res://arbol.json")
	decision_manager.cargar_progreso()
	print(decision_manager.npc_reputation)
	#decision_manager.borrar_progreso()
	_exist_decision_taken()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		player.move = false
		mostrar_acto(Acto)

func create_text(texto, character, emotion) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	text_box.finished_displaying.connect(_on_finished_displaying)
	text_box.all_texts_displayed.connect(_on_all_texts_displayed)
	text_box.start_typing_effect(texto, character, emotion)

func mostrar_acto(acto_numero):
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + 1
	elif acto_numero == 7:
		decision_manager.mostrar_decision()
	elif acto_numero == 10:
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(scene)
	else:
		print("Fin del acto")
		player.move = true
		print(acto_numero)
		Acto = 11


func _on_all_texts_displayed():
	mostrar_acto(Acto)

func _on_finished_displaying():
	sound1 += 1
	if sound1 <= 2 or sound1 == 5 or sound1 == 8:
		$knockMetal.play()

func _on_decision_taken(opcion):
	if opcion == "aceptar":
		mostrar_acto(9)
		Acto = 11
	elif opcion == "rechazar":
		mostrar_acto(11)

###SI EXISTE DECISION AGREGAR EL ACTO
func _exist_decision_taken():
	if has_value(decision_manager.npc_reputation, "npc_1"):
		if decision_manager.npc_reputation.npc_1 == 1:
			Acto = 9
		else:
			Acto = 11
	else:
		print("El diccionario NO tiene un valor para 'npc_1'.")
	
func has_value(dict: Dictionary, key: String) -> bool:
	# Verifica si la clave existe en el diccionario y si su valor no es nulo o vacío
	return dict.has(key) and dict[key] != null
