extends Node

var translations = {}
var current_language = "es"  # Idioma predeterminado

func load_translations(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		print("No se pudo cargar el archivo de traducciones")
		return

	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		if line == "" or line.begins_with("#"):  # Ignorar líneas vacías o comentarios
			continue

		var columns = line.split(",")
		if columns.size() < 2:
			continue  # Ignorar líneas con datos incompletos

		var key = columns[0]
		translations[key] = {
			"es": columns[1],
			"en": columns[2]  # Ajusta según los idiomas en tu CSV
		}
	
	file.close()

func translate(key: String) -> String:
	if translations.has(key):
		return translations[key].get(current_language, key)
	return key  # Devuelve la clave original si no se encuentra traducción


func set_language(language: String):
	if language in ["es", "en"]:  # Asegúrate de que el idioma esté soportado
		current_language = language
	else:
		print("Idioma no soportado:", language)
