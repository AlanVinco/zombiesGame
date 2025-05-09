extends Node2D

@onready var Player = $Player
signal on_all_texts_displayed
signal dialogue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicManager.music_player["parameters/switch_to_clip"] = "STILY_HOUSE"
	$POLICEWOMAN.play("idle")
	if Stats.missions >= 4:
		$stily_house/CollisionShape2D.disabled = true
		Player.move = false
		show_visual()

func show_visual():
	Stats.visualNovel = "STILYHOUSE"
	GlobalTransitions.transition()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/visualnovel.tscn")


func _on_stily_house_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$stily_house/Button.visible = true


func _on_stily_house_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$stily_house/Button.visible = false

func _on_button_pressed() -> void:
	$stily_house/Button.visible = false
	GlobalTransitions.transition()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/maps/city.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$POLICEWOMAN/Area2D/CollisionShape2D/ButtonTalk.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$POLICEWOMAN/Area2D/CollisionShape2D/ButtonTalk.visible = false

func _on_button_talk_pressed() -> void:
	$POLICEWOMAN/Area2D/CollisionShape2D/ButtonTalk.visible = false
	dialogue.emit()

#TEXT
@export var TextScene: PackedScene

func create_text(texto, character, emotion) -> void:
	var text_box = TextScene.instantiate()
	text_box.position = Vector2(70, 0)
	add_child(text_box)
	#
	#text_box.finished_displaying.connect(self._on_finished_displaying)
	text_box.all_texts_displayed.connect(self._on_all_texts_displayed)

	# Pasar el array de textos
	text_box.start_typing_effect(texto, character, emotion)

func _on_all_texts_displayed():
	emit_signal("on_all_texts_displayed")
#NEXT

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
