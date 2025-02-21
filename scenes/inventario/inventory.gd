extends Node2D

@export var max_items: int = 10  # Capacidad máxima del inventario
@export var max_stack_per_item: Dictionary = {
	"botiquin": 5,  # Máximo 5 botiquines por stack
	"comida": 10,   # Máximo 10 comidas por stack
	"dinero": 9999, # Dinero no tiene límite
	"arma": 100,      # Las armas no se stackean
	"pistola": 100,      # Las armas no se stackean
	"armadura": 100,   # Las armaduras no se stackean
	"balas": 9999, # Dinero no tiene límite
}
var items = {}  # Diccionario para almacenar objetos y sus cantidades

func _ready():
	items = GlobalInventoryItems.totalItems
	# Verificar si "Control" existe
	var control_node = get_node_or_null("Control")
	
	if control_node == null:
		#print("Error: Control no encontrado en la escena")
		return  # Detener la ejecución si Control no existe

	# Verificar si "GridContainer" existe dentro de "Control"
	var grid_container = control_node.get_node_or_null("GridContainer")
	if grid_container == null:
		print("Error: GridContainer no encontrado dentro de Control")
		return  

	#print("Control y GridContainer encontrados correctamente")
	update_inventory_ui()


# Añade un objeto al inventario
func add_item(item_name: String, quantity):
	if items.size() < max_items or items.has(item_name):  # Si hay espacio o el objeto ya existe
		if items.has(item_name):
			if items[item_name] < max_stack_per_item.get(item_name, 9999):  # Verifica el límite de stack
				items[item_name] += quantity  # Incrementa la cantidad si el objeto ya existe
			else:
				print("Stack lleno para:", item_name)
				return
		else:
			items[item_name] = quantity  # Añade el objeto al inventario con cantidad 1
		update_inventory_ui()
		print("Item añadido:", item_name, "Cantidad:", items[item_name])
		print(items)
	else:
		print("Inventario lleno, no se puede añadir:", item_name)

# Elimina un objeto del inventario
func remove_item(item_name: String, amount: int):
	if items.has(item_name):
		items[item_name] -= amount
		if items[item_name] <= 0:
			items.erase(item_name)  # Elimina el objeto si la cantidad llega a 0
		update_inventory_ui()
		print("Item eliminado:", item_name, "Cantidad restante:", items.get(item_name, 0))
	else:
		print("El objeto no existe en el inventario:", item_name)

# Actualiza la interfaz de usuario del inventario
func update_inventory_ui():
	GlobalInventoryItems.totalItems = items
	# Limpia el GridContainer antes de actualizarlo
	for child in $Control/GridContainer.get_children():
		child.queue_free()
	
	# Añade los objetos al GridContainer
	for item in items:
		var hbox = HBoxContainer.new()  # Contenedor horizontal para icono y cantidad
		var texture_rect = TextureRect.new()
		var label = Label.new()
		label.add_theme_font_size_override("font_size", 8)
		# Asigna el icono correspondiente al objeto
		var texture = null
		match item:
			"Botiquin":
				texture_rect.texture = preload("res://assets/items/botiquin.png")
			"Comida":
				texture_rect.texture = preload("res://assets/items/comida.png")
			"Dinero":
				texture_rect.texture = preload("res://assets/items/money.png")
			"Arma":
				texture_rect.texture = preload("res://assets/items/knife.png")
			"Pistola":
				texture_rect.texture = preload("res://assets/items/gun.png")
			"Armadura":
				texture_rect.texture = preload("res://assets/items/armor.png")
			"Balas":
				texture_rect.texture = preload("res://assets/items/bullets.png")
		
		if texture:
			texture_rect.texture = texture
			print("Imagen cargada para:", item)
		
		label.text = "x" + str(items[item])  # Muestra la cantidad
		hbox.add_child(texture_rect)
		hbox.add_child(label)
		$Control/GridContainer.add_child(hbox)
