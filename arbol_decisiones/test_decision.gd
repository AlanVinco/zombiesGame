extends Node

var actos = {}

func _ready():
	cargar_csv("res://languages/zombies1DialogV1.csv", "market1")
	print("Datos filtrados:", actos)

func cargar_csv(ruta, escena_filtrada):
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
		var clave_texto = "vnmkt1_txt" + str(i + 1)  

		actos[index] = {
			"textos": [clave_texto],  
			"image": fila.get("image", ""),
			"personaje": fila.get("personaje", ""),
			"emocion": fila.get("emocion", "NORMAL")
		}
		
		index += 1  
