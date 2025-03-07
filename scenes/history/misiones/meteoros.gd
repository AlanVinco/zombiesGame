class_name MeteorArea
extends Area2D

@export var meteor_scene: PackedScene  # Escena del meteoro (AnimatedSprite2D)
@export var meteor_fall_interval: float = 1.0  # Intervalo entre meteoros
@export var active: bool = false  # Bandera para activar/desactivar la caída de meteoros
@onready var player = $"../Player"

@onready var timer: Timer = $"../Timer"

func _ready():
	timer.wait_time = meteor_fall_interval
	timer.timeout.connect(_on_timer_timeout)
	set_active(active)  # Configura el estado inicial

func set_active(is_active: bool):
	active = is_active
	if active:
		timer.start()  # Inicia el Timer si la bandera está activada
	else:
		timer.stop()   # Detiene el Timer si la bandera está desactivada

func _on_timer_timeout():
	if active:
		spawn_meteor()

func spawn_meteor():
	# Obtén un punto aleatorio dentro del Area2D
	var random_position = Vector2(
		randf_range(global_position.x, global_position.x + $CollisionShape2D.shape.get_rect().size.x),
		randf_range(global_position.y, global_position.y + $CollisionShape2D.shape.get_rect().size.y)
	)
	
	# Instancia el meteoro
	var meteor = meteor_scene.instantiate()
			# Convierte la posición global del jugador a coordenadas locales del enemigo
	var player_local_position = to_local(player.global_position)
	meteor.global_position = player_local_position
	add_child(meteor)
	
	# Conecta la señal para eliminar el meteoro cuando termine su animación
	meteor.play("meteoro")
