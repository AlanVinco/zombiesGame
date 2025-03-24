class_name HookAttackState
extends State

@export var actor: ZombieChain
@export var vision_cast: RayCast2D
@export var chain_scene: PackedScene  # Escena de la cadena

signal hit_player  # Emitida si atrapa al jugador
signal termino_de_hookear

func _ready() -> void:
	set_physics_process(false)

func _enter_state():
	$"../../ChainCadena1".play()
	$"../../TIRARCADENA".play()
	set_physics_process(true)
	actor.update_text("¡Lanzando cadena!")
	actor.animator.play("hook")
	await get_tree().create_timer(0.5).timeout  # Pequeño retardo antes del ataque

	# Instanciar la cadena
	var chain = chain_scene.instantiate()
	
	# Posicionar la cadena en la posición del enemigo
	chain.global_position = actor.global_position
	
	# Calcular la dirección hacia el jugador
	var direction_to_player = (actor.player_node.global_position - actor.global_position).normalized()
	
	# Calcular el ángulo de rotación usando atan2
	var angle = atan2(direction_to_player.y, direction_to_player.x)
	
	# Aplicar la rotación a la cadena
	chain.rotation = angle-64.4
	chain.hit_player.connect(_on_hit_player)
	# Añadir la cadena a la escena
	get_parent().add_child(chain)
	
	# Esperar un tiempo antes de terminar el estado
	await get_tree().create_timer(1.0).timeout
	termino_de_hookear.emit()

func _on_hit_player():
	actor.update_text("¡Atrapado!")
	actor.player_node.global_position = actor.global_position  # Teletransporta al jugador

func _exit_state() -> void:
	set_physics_process(false)
