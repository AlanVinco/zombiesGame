extends Node2D

@onready var office = $".."
@onready var player = $"../Player"
@onready var text = $"../TEXT"
@export var nexScene = "res://scenes/maps/house.tscn"
@export var sceneName = "HAVANYWORKTXT"
@export var sceneCodeTxt = "girl_work_dialoge_txt"
var sumando = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#condicionar
	if Stats.girlWork == 1:
		office.havany_work_dialogue.connect(dialogues_history)
		office.pedir_aumento.connect(dialogues_aumento_history)
	if Stats.girlWork == 2:
		office.pedir_aumento.connect(dialogues_aumento_history2)
	if Stats.girlWork == 3:
		office.pedir_aumento.connect(dialogues_aumento_history3)

func dialogues_aumento_history():
	sceneName = "AUMENTOGIRL1"
	nexScene = "res://scenes/maps/house.tscn"
	sceneCodeTxt = "aumento_girl1_txt"
	Acto = 1
	GlobalTransitions.transition()
	text.on_all_texts_displayed.connect(_on_all_texts_displayed)
	await get_tree().create_timer(0.5).timeout
	$"../NPCS/HavanyWork".position = Vector2(79, -24)
	
	$"../NPCS/HavanyWork/Area2D/CollisionShape2D".disabled = true
	player.visible = false
	
	player.move = false
	office.on_all_texts_displayed.connect(_on_all_texts_displayed)
	await get_tree().create_timer(1.0).timeout
	var new_actos = office.transformar_actos(text.actos)
	actos = new_actos
	_on_all_texts_displayed()
	
func dialogues_aumento_history2():
	sceneName = "AUMENTOGIRL2"
	nexScene = "res://scenes/maps/house.tscn"
	sceneCodeTxt = "aumento_girl2_txt"
	Acto = 1
	GlobalTransitions.transition()
	text.on_all_texts_displayed.connect(_on_all_texts_displayed)
	await get_tree().create_timer(0.5).timeout
	$"../NPCS/HavanyWork".position = Vector2(79, -24)
	$"../NPCS/HavanyWork".visible = true
	$"../NPCS/HavanyWork/Area2D/CollisionShape2D".disabled = true
	player.visible = false
	
	player.move = false
	office.on_all_texts_displayed.connect(_on_all_texts_displayed)
	await get_tree().create_timer(1.0).timeout
	var new_actos = office.transformar_actos(text.actos)
	actos = new_actos
	_on_all_texts_displayed()

func dialogues_aumento_history3():
	sceneName = "BARFINAL1"
	nexScene = "res://scenes/maps/bar.tscn"
	sceneCodeTxt = "barfinal_txt"
	Acto = 1
	GlobalTransitions.transition()
	text.on_all_texts_displayed.connect(_on_all_texts_displayed)
	await get_tree().create_timer(0.5).timeout
	player.move = false
	office.on_all_texts_displayed.connect(_on_all_texts_displayed)
	await get_tree().create_timer(1.0).timeout
	var new_actos = office.transformar_actos(text.actos)
	actos = new_actos
	_on_all_texts_displayed()

func dialogues_history():
	Acto = 1
	nexScene = "res://scenes/maps/house.tscn"
	sceneName = "HAVANYWORKTXT"
	sceneCodeTxt = "girl_work_dialoge_txt"
	GlobalTransitions.transition()
	text.on_all_texts_displayed.connect(_on_all_texts_displayed)
	await get_tree().create_timer(0.5).timeout
	player.move = false
	office.on_all_texts_displayed.connect(_on_all_texts_displayed)
	await get_tree().create_timer(1.0).timeout
	var new_actos = office.transformar_actos(text.actos)
	actos = new_actos
	_on_all_texts_displayed()

var Acto = 1

var actos = {}

func mostrar_acto(acto_numero, actos):
	if acto_numero in actos:
		sumando = 1
		await get_tree().create_timer(0.5).timeout
		if sceneName == "AUMENTOGIRL1":
			print(acto_numero)
			if acto_numero == 5 and Stats.MALO >=60:
				sumando = 3
				Stats.girlWork = 2
			if acto_numero == 7 and Stats.MALO <60:
				sumando = 50
			else:
				pass
		if sceneName == "AUMENTOGIRL2":
			print(acto_numero)
			if acto_numero == 4 and Stats.MALO >=80:
				sumando = 3
				Stats.girlWork = 3
			if acto_numero == 6 and Stats.MALO <80:
				sumando = 50
			else:
				pass
			
		var acto_data = actos[acto_numero]
		office.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + sumando
	else:
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		if Stats.girlWork == 2 or Stats.girlWork == 3:
			Stats.time = "night"
			get_tree().change_scene_to_file(nexScene)
			player.move = true
		else:
			$"../NPCS/HavanyWork".position = Vector2(-13, -34)
			$"../NPCS/HavanyWork/Area2D/CollisionShape2D".disabled = false
			player.visible = true
			player.move = true
			sumando = 1
			

func _on_all_texts_displayed():
	text.cargar_csv("res://languages/zombies1DialogV1.csv", sceneName, sceneCodeTxt)
	actos = text.actos
	var new_actos = office.transformar_actos(text.actos)
	actos = new_actos
	mostrar_acto(Acto, actos)
	
