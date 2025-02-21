extends Node2D

@onready var player = $Player
@export var TextScene: PackedScene
var Acto = 1
var scene = "res://scenes/history/intro_3.tscn"


var actos = {
	1: { "textos": ["intro_2_txt1_d1"], "personaje": "PLAYER", "emocion": "NORMAL" },
	2: { "textos": ["intro_2_txt2_d2"], "personaje": "HAVANY", "emocion": "NORMAL" },
	3: { "textos": ["intro_2_txt3_d3"], "personaje": "RATZWEL", "emocion": "NORMAL" },
	4: { "textos": ["intro_2_txt4_d4"], "personaje": "HAVANY", "emocion": "NORMAL" },
	5: { "textos": ["intro_2_txt5_d5"], "personaje": "PLAYER", "emocion": "NORMAL" },
	6: { "textos": ["intro_2_txt6_d6"], "personaje": "RATZWEL", "emocion": "NORMAL" },
	7: { "textos": ["intro_2_txt7_d7"], "personaje": "PLAYER", "emocion": "NORMAL" },
	8: { "textos": ["intro_2_txt8_d8"], "personaje": "HAVANY", "emocion": "NORMAL" },
	9: { "textos": ["intro_2_txt9_d9", "intro_2_txt9_d10", "intro_2_txt9_d11", "intro_2_txt9_d12", 
	"intro_2_txt9_d13", "intro_2_txt9_d14", "intro_2_txt9_d15", "intro_2_txt9_d16", "intro_2_txt9_d17", 
	"intro_2_txt9_d18", "intro_2_txt9_d19", "intro_2_txt9_d20", "intro_2_txt9_d21", "intro_2_txt9_d22", 
	"intro_2_txt9_d23", "intro_2_txt9_d24", "intro_2_txt9_d25"], "personaje": "RATZWEL", "emocion": "NORMAL" },
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.move = false
	await get_tree().create_timer(2.0).timeout
	mostrar_acto(Acto)

func create_text(texto, character, emotion) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	#text_box.finished_displaying.connect(_on_finished_displaying)
	text_box.all_texts_displayed.connect(_on_all_texts_displayed)
	text_box.start_typing_effect(texto, character, emotion)

func mostrar_acto(acto_numero):
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + 1
	#elif acto_numero == 7:
		#pass
	#elif acto_numero == 10:
		#await get_tree().create_timer(0.5).timeout
		#get_tree().change_scene_to_file(scene)
	else:
		print("Fin del acto")
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(scene)


func _on_all_texts_displayed():
	mostrar_acto(Acto)

#func _on_finished_displaying():
	#sound1 += 1
	#if sound1 <= 2 or sound1 == 5 or sound1 == 8:
		#$knockMetal.play()
