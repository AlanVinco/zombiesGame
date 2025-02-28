extends Node2D

@onready var office = $"../.."
@onready var player = $"../../Player"
@onready var Havany = $"../../HavanyNpcState"
var nextScene = "res://scenes/maps/house.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#condicionar
	if Stats.ntrGirl == 1:
		office.NTR_GIRL.connect(ntr_history)


func ntr_history():
	GlobalTransitions.transition()
	await get_tree().create_timer(0.5).timeout
	player.visible = false
	player.move = false
	Havany.visible = true
	office.on_all_texts_displayed.connect(_on_all_texts_displayed)
	await get_tree().create_timer(1.0).timeout
	mostrar_acto(Acto, actos)

var Acto = 1

var actos = {
	1: { "textos": ["NTR1",], "personaje": "RATZWEL", "emocion": "NORMAL" },
	}

func mostrar_acto(acto_numero, actos):
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		office.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + 1
	#elif acto_numero == 1:
		#audio_player.stream = load("res://sound/sounds/door_knoc_and_ooen.mp3")
		#audio_player.play()
		#Acto = acto_numero + 1
		#await get_tree().create_timer(1.0).timeout
		#mostrar_acto(Acto, actos)
	else:
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		Stats.ntrGirl = 2
		Stats.time = "night"
		GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
		GlobalTransitions.player_position_city = Vector2(342, -18)
		get_tree().change_scene_to_file(nextScene)

func _on_all_texts_displayed():
	mostrar_acto(Acto, actos)
