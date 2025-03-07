extends CharacterBody2D

@export var player: NodePath
@onready var player_node = get_node(player)

signal havany_status

@export var TextScene: PackedScene
var Acto = 1

var actos = {
	1: { "textos": ["house_rep_txt1",], "personaje": "HAVANY", "emocion": "NORMAL" }, #HAPPY
	3: { "textos": ["intro_3_txt2_d1", "intro_3_txt2_d2", "intro_3_txt2_d3"], "personaje": "HAVANY", "emocion": "NORMAL" },
	5: { "textos": ["intro_3_txt3_d1",], "personaje": "HAVANY", "emocion": "NORMAL" },
	7: { "textos": ["intro_3_txt3_d1",], "personaje": "HAVANY", "emocion": "NORMAL" },
	9: { "textos": ["house_sex_txt1",], "personaje": "HAVANY", "emocion": "NORMAL" },
	11: { "textos": ["house_sex_txt2",], "personaje": "HAVANY", "emocion": "NORMAL" },
}
func create_text(texto, character, emotion) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	#
	#text_box.finished_displaying.connect(self._on_finished_displaying)
	text_box.all_texts_displayed.connect(self._on_all_texts_displayed)

	# Pasar el array de textos
	text_box.start_typing_effect(texto, character, emotion)

func mostrar_acto(acto_numero):
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + 1
	else:
		print("EMPIEZA EL JUEGO")
		player_node.move = true

func _on_all_texts_displayed():
	mostrar_acto(Acto)

func _ready() -> void:
	$AnimatedSprite2D.play("idle")

#AREAS
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$Area2D/btn_talk.visible = true
		$Area2D/btn_stay.visible = true
		if Stats.HUSBAND >= 50:
			$Area2D/btn_sex.visible = true
		#PONER CONDICION PARA EL SEXO, APARECER SI HUSBAND TIENE mas de 50

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$Area2D/btn_talk.visible = false
		$Area2D/btn_stay.visible = false
		$Area2D/btn_sex.visible = false

func _on_btn_talk_pressed() -> void:
	player_node.move = false
	$Area2D/btn_talk.visible = false
	$Area2D/btn_stay.visible = false
	$Area2D/btn_sex.visible = false
	if Stats.HUSBAND >= 75:
		#FELIZ
		mostrar_acto(1)
		

func _on_btn_sex_pressed() -> void:
	player_node.move = false
	$Area2D/btn_talk.visible = false
	$Area2D/btn_stay.visible = false
	$Area2D/btn_sex.visible = false
	if Stats.HUSBAND >= 30 and GlobalInventoryItems.totalItems.has("Condon"):
		#FELIZ y tiene condon
		mostrar_acto(11)
		player_node.use_item("Condon", 1)
	elif Stats.HUSBAND >= 30 and !GlobalInventoryItems.totalItems.has("Condon"):
		#FELIZ y no tiene condon
		mostrar_acto(9)
		Stats.HUSBAND += 5
		print("ESCENA DE SEXO")
	else:
		pass

func _on_btn_stay_pressed() -> void:
	#animacion de quedarse con ella con un beso.
	$Area2D/btn_talk.visible = false
	$Area2D/btn_stay.visible = false
	$Area2D/btn_sex.visible = false
	if Stats.HUSBAND >= 10:
		Stats.HUSBAND += 10
		await Stats.advance_time()
		emit_signal("havany_status")
	else:
		print("NO ES NECESARIO QUE PASES EL DIA CONMIGO TENGO COSAS QUE HACER.")
