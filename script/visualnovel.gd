extends Node

@onready var camera = $Camera2D
var smoothing_speed: float = 0.1
signal on_all_texts_displayed
var actos = {}

func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	camera.position = lerp(camera.position, mouse_position - Vector2(0, 0), smoothing_speed)

func _ready() -> void:
	#print("Datos filtrados:", actos)
	Stats.time = "day"

#TEXTO
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

func cargar_csv(ruta, escena_filtrada, keyWord):
	var file = FileAccess.open(ruta, FileAccess.READ)
	if not file:
		print("Error al abrir el archivo CSV")
		return

	var contenido = file.get_as_text()
	file.close()
	
	var lineas = contenido.split("\n")
	if lineas.size() <= 1:
		print("Archivo vacío o con solo encabezados")
		return

	var delimitador = "\t" if lineas[0].count("\t") > lineas[0].count(",") else ","
	var encabezados = lineas[0].split(delimitador)
	var data = []
	
	for i in range(1, lineas.size()):
		var columnas = lineas[i].split(delimitador)
		if columnas.size() != encabezados.size():
			continue  
		
		var fila = {}
		for j in range(encabezados.size()):
			fila[encabezados[j].strip_edges()] = columnas[j].strip_edges() if j < columnas.size() else ""  

		if fila.get("escena", "") == escena_filtrada:
			data.append(fila)

	if data.is_empty():
		print("⚠ No se encontraron datos para la escena:", escena_filtrada)
		return
	
	#print("Datos filtradosTODO:", data)  

	# **Nueva lógica para no agrupar textos**
	var index = 1  

	for i in range(data.size()):
		var fila = data[i]
		var clave_texto = keyWord + str(i + 1)  

		actos[index] = {
			"textos": [clave_texto],  
			"image": fila.get("image", ""),
			"personaje": fila.get("personaje", ""),
			"emocion": fila.get("emocion", "NORMAL")
		}
		
		index += 1  
