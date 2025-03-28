extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("idle")
	randomize_color()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func randomize_color():
	# Verificamos si el sprite tiene un ShaderMaterial
	if animated_sprite.material:
		# Creamos una COPIA ÚNICA del material para este zombie
		var new_material = animated_sprite.material.duplicate()
		animated_sprite.material = new_material
		
		# Establecemos el color objetivo (el que queremos reemplazar)
		new_material.set_shader_parameter("target_color", Color(0.26, 0.26, 0.26, 1)) # #424242
		
		# Generamos un color aleatorio
		var random_color = Color(randf(), randf(), randf(), 1.0) 
		
		# Aplicamos el color aleatorio solo a este zombie
		new_material.set_shader_parameter("new_color", random_color)
