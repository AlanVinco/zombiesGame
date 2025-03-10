extends Node2D

@onready var office = $"../.."
@onready var player = $PlayerNpc
@onready var Havany = $HavanyNpcState
@onready var text = $TEXT
@export var escenevisual = "res://scenes/maps/house.tscn"
@export var sceneName = "NTR3SUB"
@export var sceneCodeTxt = "ntr_3_dialogue_sub"
@export var visualNovelName = "res://scenes/maps/house.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#condicionar
	text.on_all_texts_displayed.connect(_on_all_texts_displayed)
	player.is_scene = true
	Havany.is_scene = true
	ntr_history()
	
func ntr_history():
	#office.on_all_texts_displayed.connect(_on_all_texts_displayed)
	await get_tree().create_timer(1.0).timeout
	_on_all_texts_displayed()

var Acto = 1

var actos = {}

func mostrar_acto(acto_numero, actos):
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		text.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + 1
	else:
		#Stats.visualNovel = visualNovelName
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(escenevisual)

func _on_all_texts_displayed():
	text.cargar_csv("res://languages/zombies1DialogV1.csv", sceneName, sceneCodeTxt)
	actos = text.actos
	mostrar_acto(Acto, actos)
