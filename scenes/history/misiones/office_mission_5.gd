extends Node2D

@onready var office = $"../.."
@onready var player = $"../../Player"
@onready var Havany = $"../../HavanyNpcState"
@onready var text = $"../../TEXT"
@export var nexScene = "res://scenes/visualnovel.tscn"
@export var sceneName = "NTR5TEXT"
@export var sceneCodeTxt = "ntr5_text"
@export var visualNovelName = "NTR5VISUAL"
@export var MISSION = 2
var versus_scene 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#condicionar
	if Stats.missions == MISSION:
		office.MISSION.connect(mission_history)


func mission_history():
	Stats.MALO += 80
	GlobalTransitions.transition()
	text.on_all_texts_displayed.connect(_on_all_texts_displayed)
	await get_tree().create_timer(0.5).timeout
	Havany.visible = true
	player.move = false
	player.visible = false
	office.on_all_texts_displayed.connect(_on_all_texts_displayed)
	await get_tree().create_timer(1.0).timeout
	var new_actos = office.transformar_actos(text.actos)
	actos = new_actos
	_on_all_texts_displayed()

var Acto = 1

var actos = {}

func mostrar_acto(acto_numero, actos):
	if acto_numero in actos:
		print(acto_numero)
		await get_tree().create_timer(0.5).timeout
		if acto_numero == 4:
			$"../../Sounds".stream = load("res://sound/sounds/TOCAR_PUERTA.ogg")
			$"../../Sounds".play()
		if acto_numero == 6:
			Havany.visible = false
			GlobalTransitions.transition()
			$"../../Sounds".stream = load("res://sound/sounds/door_open_close.mp3")
			$"../../Sounds".play()
			await get_tree().create_timer(0.5).timeout
			player.visible = true
			
		var acto_data = actos[acto_numero]
		office.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + 1
	else:
		Stats.MALO -= 80
		GlobalTransitions.transition()
		Stats.visualNovel = visualNovelName
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(nexScene)

func _on_all_texts_displayed():
	text.cargar_csv("res://languages/zombies1DialogV1.csv", sceneName, sceneCodeTxt)
	actos = text.actos
	var new_actos = office.transformar_actos(text.actos)
	actos = new_actos
	mostrar_acto(Acto, actos)
	
