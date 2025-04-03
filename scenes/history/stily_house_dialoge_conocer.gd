extends Node2D

@onready var office = $".."
@onready var player = $"../Player"
@onready var text =$"../TEXT"
@export var nexScene = "res://scenes/maps/house.tscn"
@export var sceneName = "STILYFIRST"
@export var sceneCodeTxt = "stily_dialogue_txt"
var sumando = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#condicionar
	office.dialogue.connect(dialogues_history)
	
func dialogues_history():
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

var Acto = 1

var actos = {}

func mostrar_acto(acto_numero, actos):
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
			
		var acto_data = actos[acto_numero]
		office.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + sumando
	else:
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		player.move = true

func _on_all_texts_displayed():
	text.cargar_csv("res://languages/zombies1DialogV1.csv", sceneName, sceneCodeTxt)
	actos = text.actos
	var new_actos = office.transformar_actos(text.actos)
	actos = new_actos
	mostrar_acto(Acto, actos)
	
