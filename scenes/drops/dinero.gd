extends Area2D

# Define una propiedad para identificar el tipo de ítem
@export var item_name: String = "Dinero"

func _ready():
	# Asegúrate de que el ítem esté en el grupo "item"
	add_to_group("item")
