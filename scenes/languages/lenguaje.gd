extends Node

var scene = "res://scenes/menu.tscn"

func _ready() -> void:
	logo_animation()
	MusicManager.music_player.stop()
	var source_path = "res://languages/zombies1DialogV1.csv"
	var user_path = "res://languages/zombies1DialogV1.csv"

	# Verifica si el archivo ya existe en el directorio de usuario
	if not FileAccess.file_exists(user_path):
		_copy_file(source_path, user_path)

	# Cargar las traducciones desde el directorio de usuario
	TranslationManager.load_translations(user_path)


func _copy_file(source: String, destination: String) -> void:
	# Abrir el archivo de origen
	var source_file = FileAccess.open(source, FileAccess.READ)
	if source_file == null:
		print("Error: No se pudo abrir el archivo de origen.")
		return

	# Leer el contenido del archivo de origen
	var content = source_file.get_buffer(source_file.get_length())
	source_file.close()

	# Escribir el contenido en el archivo de destino
	var destination_file = FileAccess.open(destination, FileAccess.WRITE)
	if destination_file == null:
		print("Error: No se pudo crear el archivo de destino.")
		return

	destination_file.store_buffer(content)
	destination_file.close()
	print("Archivo copiado exitosamente a:", destination)


func _on_esp_pressed() -> void:
	$ButtonSound.play()
	TranslationServer.set_locale("es")
	TranslationManager.set_language("es")  # Actualiza el idioma en TranslationManager
	#GlobalTransition.transition()
	await get_tree().create_timer(0.5).timeout
	GlobalTransitions.transition()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(scene)

func _on_eng_pressed() -> void:
	$ButtonSound.play()
	TranslationServer.set_locale("en")
	TranslationManager.set_language("en")  # Actualiza el idioma en TranslationManager
	#GlobalTransition.transition()
	await get_tree().create_timer(0.5).timeout
	GlobalTransitions.transition()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(scene)

func logo_animation():
	play_entry_tween($Logo/TextureRect3)  # Entrada
	await get_tree().create_timer(0.6).timeout
	$RisaLogo.play()

	await get_tree().create_timer(3.4).timeout  # Espera simulando el diálogo

	await play_exit_tv_off_tween($Logo/TextureRect3)  # Salida tipo TV
	
	await get_tree().create_timer(1.0).timeout
	$Logo.visible = false

func play_entry_tween(node):
	node.visible = true
	node.modulate.a = 0.0
	node.scale = Vector2(1.2, 1.2)  # Un poco agrandado para efecto

	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func play_exit_tv_off_tween(node):
	var tween = create_tween()
	tween.tween_property(node, "scale:y", 0.05, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	#tween.tween_property(node, "scale:x", 0.0, 0.2).set_delay(0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	#tween.tween_property(node, "modulate:a", 0.0, 0.2).set_delay(0.5)

	await tween.finished
	node.queue_free()
