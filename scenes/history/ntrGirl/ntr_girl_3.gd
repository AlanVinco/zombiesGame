extends Node2D

@onready var office = $"../.."
@onready var player = $"../../Player"
@onready var Havany = $"../../HavanyNpcState"
@onready var text = $"../../TEXT"
@export var escenevisual = "res://scenes/visualnovel.tscn"
@export var sceneName = "NTRDIALOGUE3"
@export var sceneCodeTxt = "ntr_dialogue3_txt"
@export var visualNovelName = "ntrvisual3"
@export var porcentNTRCondition = 40
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#condicionar
	if Stats.MALO == porcentNTRCondition:
		office.NTR_GIRL.connect(ntr_history)
		text.on_all_texts_displayed.connect(_on_all_texts_displayed)


func ntr_history():
	GlobalTransitions.transition()
	await get_tree().create_timer(0.5).timeout
	player.visible = false
	player.move = false
	Havany.visible = true
	office.on_all_texts_displayed.connect(_on_all_texts_displayed)
	await get_tree().create_timer(1.0).timeout
	_on_all_texts_displayed()

var Acto = 1

var actos = {}

func mostrar_acto(acto_numero, actos):
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		office.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + 1
	else:
		Stats.visualNovel = visualNovelName
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(escenevisual)

func _on_all_texts_displayed():
	text.cargar_csv("res://languages/zombies1DialogV1.csv", sceneName, sceneCodeTxt)
	actos = text.actos
	mostrar_acto(Acto, actos)
	
