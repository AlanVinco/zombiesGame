extends CharacterBody2D

@export var player: NodePath
@onready var player_node = get_node(player)

@onready var player_is_dead = false

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
	if acto_numero == 12:
		Stats.visualNovel = "loveSex"
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/visualnovel.tscn")
	
	else:
		print("EMPIEZA EL JUEGO")
		player_node.move = true

func _on_all_texts_displayed():
	mostrar_acto(Acto)

func _ready() -> void:
	if Stats.MALO >= 80:
		$AnimatedSprite2D.play("idle_naked")
	else:
		$AnimatedSprite2D.play("idle")
	text.on_all_texts_displayed.connect(_on_all_texts_displayedTXT)
	player_node.murio_player.connect(is_dead_player)

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
	
	if Stats.MALO < 20:
		text.cargar_csv("res://languages/zombies1DialogV1.csv", "REPUTATION0", "house_rep_txt")
		var new_actos = transformar_actos(text.actos)
		actosTxt = new_actos
		ActoTxt = 1
		_on_all_texts_displayedTXT()
		
	elif Stats.MALO >= 20 and Stats.MALO < 40:
		text.cargar_csv("res://languages/zombies1DialogV1.csv", "REPUTATION1", "house_rep_txt2_txt")
		var new_actos = transformar_actos(text.actos)
		actosTxt = new_actos
		ActoTxt = 1
		_on_all_texts_displayedTXT()
		
	elif Stats.MALO >= 40 and Stats.MALO < 60:
		text.cargar_csv("res://languages/zombies1DialogV1.csv", "REPUTATION2", "house_rep_txt3_txt")
		var new_actos = transformar_actos(text.actos)
		actosTxt = new_actos
		ActoTxt = 1
		_on_all_texts_displayedTXT()
		
	elif Stats.MALO >= 60 and Stats.MALO < 80:
		text.cargar_csv("res://languages/zombies1DialogV1.csv", "REPUTATION3", "house_rep_txt4_txt")
		var new_actos = transformar_actos(text.actos)
		actosTxt = new_actos
		ActoTxt = 1
		_on_all_texts_displayedTXT()
		
	elif Stats.MALO >= 80:
		text.cargar_csv("res://languages/zombies1DialogV1.csv", "REPUTATION4", "house_rep_txt5_txt")
		actosTxt = text.actos
		ActoTxt = 1
		_on_all_texts_displayedTXT()
	
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
	if Stats.MALO < 80:
		await Stats.advance_time()
		Stats.HUSBAND += 10
		emit_signal("havany_status")
		player_node.move = false
		$CanvasLayer/TextureRect.texture = load("res://art/cutscenes/STAY.png")
		$CanvasLayer.visible = true
		await get_tree().create_timer(2.0).timeout
		$CanvasLayer.visible = false
		player_node.move = true
		player_is_dead = false
	else:
		player_node.move = false
		text.cargar_csv("res://languages/zombies1DialogV1.csv", "STAYNO", "stay_no_txt")
		actosTxt = text.actos
		ActoTxt = 1
		_on_all_texts_displayedTXT()

#CARGAR TEXTOS
var ActoTxt = 1
var scene = ""
var actosTxt = {}
@onready var text = $TEXT

func mostrar_actoTXT(acto_numero, actos):
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		text.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		ActoTxt += 1
		
	else:
		
		player_node.move = true
		ActoTxt = 1
		actos = {
	1: { "textos": ["house_rep_txt1",], "personaje": "HAVANY", "emocion": "NORMAL" }, #HAPPY
	3: { "textos": ["intro_3_txt2_d1", "intro_3_txt2_d2", "intro_3_txt2_d3"], "personaje": "HAVANY", "emocion": "NORMAL" },
	5: { "textos": ["intro_3_txt3_d1",], "personaje": "HAVANY", "emocion": "NORMAL" },
	7: { "textos": ["intro_3_txt3_d1",], "personaje": "HAVANY", "emocion": "NORMAL" },
	9: { "textos": ["house_sex_txt1",], "personaje": "HAVANY", "emocion": "NORMAL" },
	11: { "textos": ["house_sex_txt2",], "personaje": "HAVANY", "emocion": "NORMAL" },}
		#GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
		#GlobalTransitions.player_position_city = Vector2(342, -18)
		#await get_tree().create_timer(0.5).timeout
		#get_tree().change_scene_to_file(scene)

func _on_all_texts_displayedTXT():
	mostrar_actoTXT(ActoTxt, actosTxt)

func transformar_actos(actos):
	var new_actos = {}
	var current_index = 1
	var last_personaje = null
	var last_emocion = null
	var last_image = null
	var textos_grupo = []
	
	for key in actos.keys():
		var entry = actos[key]
		var personaje = entry["personaje"]
		var emocion = entry["emocion"]
		var image = entry["image"]
		var texto = entry["textos"][0]
		
		# Si es el mismo personaje y emoción, agrupamos los textos
		if personaje == last_personaje and emocion == last_emocion:
			textos_grupo.append(texto)
		else:
			# Si cambia de personaje o emoción, guardamos el grupo anterior
			if textos_grupo.size() > 0:
				new_actos[current_index] = {
					"textos": textos_grupo,
					"image": last_image,
					"personaje": last_personaje,
					"emocion": last_emocion
				}
				current_index += 1
			
			# Iniciamos un nuevo grupo
			textos_grupo = [texto]
			last_personaje = personaje
			last_emocion = emocion
			last_image = image
	
	# Guardar el último grupo si hay textos pendientes
	if textos_grupo.size() > 0:
		new_actos[current_index] = {
			"textos": textos_grupo,
			"image": last_image,
			"personaje": last_personaje,
			"emocion": last_emocion
		}

	return new_actos


func is_dead_player():
	print("SE EJECUTO ESTA MRDA")
	player_is_dead = true
