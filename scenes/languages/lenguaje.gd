extends Node

var scene = "res://scenes/history/intro_0.tscn"

func _ready() -> void:
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
	TranslationServer.set_locale("es")
	TranslationManager.set_language("es")  # Actualiza el idioma en TranslationManager
	#GlobalTransition.transition()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(scene)

func _on_eng_pressed() -> void:
	TranslationServer.set_locale("en")
	TranslationManager.set_language("en")  # Actualiza el idioma en TranslationManager
	#GlobalTransition.transition()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(scene)
