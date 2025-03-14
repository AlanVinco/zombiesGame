class_name MageInvulnerableState
extends State

@onready var mago = $"../.."
@export var actor: MageBoss
@export var fireball_scene: PackedScene  # Escena de la bola de energía
var zombie_count = 0

signal señal_poder_golpearlo_

func _enter_state():
	
	actor.update_text("invulnerable disparar")
	actor.animator.play("invulnerable")
	actor.all_zombies_defeated.connect(_on_all_zombies_defeated)  # Conectar la señal
	
	while actor.summoned_zombies.size() > 0:
		_shoot_fireball()
		await get_tree().create_timer(1.0).timeout  # Dispara cada segundo

func _on_all_zombies_defeated():
	actor.update_text("Se vuelve vulnerable")
	actor.is_invulnerable = false
	señal_poder_golpearlo_.emit()


func _shoot_fireball():
	var fireball = fireball_scene.instantiate()
	fireball.global_position = actor.global_position
	
	fireball.direction = (mago.player_local_position - actor.global_position).normalized()
	get_parent().add_child(fireball)
	
