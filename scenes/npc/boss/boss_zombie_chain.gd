class_name ZombieChain
extends CharacterBody2D

@export var player: NodePath
@onready var player_node = get_node(player)

@export var max_speed = 40.0
@export var acceleration = 50.0

@onready var label = $Label
@onready var fsm: FiniteStateMachine = $FiniteStateMachine as FiniteStateMachine

@export var damage = 5
@export var life = 100
@export var animator: AnimatedSprite2D

var is_dead = false  # Nueva variable
@export var is_invulnerable = true

@onready var chain_idle_state: ChainIdleState = $FiniteStateMachine/ChainIdleState as ChainIdleState
@onready var spin_attack_state: SpinAttackState = $FiniteStateMachine/SpinAttackState as SpinAttackState
@onready var hook_attack_state: HookAttackState = $FiniteStateMachine/HookAttackState as HookAttackState
@onready var explosion_state: ExplosionState = $FiniteStateMachine/ExplosionState as ExplosionState
@onready var chain_die_state: DieState = $FiniteStateMachine/ChainDieState as DieState

@export var is_scene = false
@export var move_manually = false
@export var move_to: Vector2

@onready var animations = $Animations

signal animMorir 
signal endScene
signal all_zombies_defeated

@export var player_local_position = 0

var sprite_offset = Vector2(-28, -31)  # Offset fijo para centrar el sprite

@export var total_zombie = 0

func _ready():
	updateHPbar()
	
	# No cambiar estados si está muerto
	chain_idle_state.spin_attack.connect(func(): if !is_dead: fsm.change_state(spin_attack_state))
	chain_idle_state.explosion_attack.connect(func(): if !is_dead: fsm.change_state(explosion_state))
	chain_idle_state.hook_attack.connect(func(): if !is_dead: fsm.change_state(hook_attack_state))
	spin_attack_state.termino_de_girar.connect(func(): if !is_dead: fsm.change_state(chain_idle_state))
	hook_attack_state.termino_de_hookear.connect(func(): if !is_dead: fsm.change_state(chain_idle_state))
	explosion_state.termino_de_explotar.connect(func(): if !is_dead: fsm.change_state(chain_idle_state))

	
@onready var ray_cast_2d = $RayCast2D

func _process(delta: float) -> void:
	if player_node:
		# Convierte la posición global del jugador a coordenadas locales del enemigo
		player_local_position = to_local(player_node.global_position)
		ray_cast_2d.target_position = player_local_position
		#update_sprite_direction()

func update_text(txt):
	if label:
		label.text = str(txt)

func updateHPbar():
	$CanvasLayer/ProgressBar.value = life

func _on_area_baja_salud_area_entered(area: Area2D) -> void:
	if area.name == "Hitbox":
		decrease_boos_life()


func check_death():
	if life <= 0 and !is_dead:
		is_dead = true  
		fsm.set_physics_process(false)  # 🔴 Desactivar FSM
		fsm.change_state(chain_die_state)
		await get_tree().create_timer(1.0).timeout
		endScene.emit()
		


func _on_enemy_died():
	await get_tree().create_timer(1.0).timeout
	endScene.emit()

func _on_make_damage_timeout() -> void:
	player_node.decrease_life(damage)

func _on_areaa_daño_player_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$makeDamage.start()
		body.decrease_life(damage)


func _on_areaa_daño_player_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$makeDamage.stop()


func _on_area_entra_daño_area_entered(area: Area2D) -> void:
	if area.name == "Hitbox":
		if is_invulnerable == false:
			life -= player_node.damage
			updateHPbar()

		if life <= 0:  # Si la vida llega a 0, activa el estado de muerte
			check_death()


func decrease_boos_life():
	if is_invulnerable == false:
		life -= player_node.damage
		updateHPbar()

		if life <= 0:  # Si la vida llega a 0, activa el estado de muerte
			check_death()


func _on_explosion_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.decrease_life(damage + 30)
