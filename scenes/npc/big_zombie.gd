class_name EnemyBoss
extends CharacterBody2D

@export var player: NodePath
@onready var player_node = get_node(player)

@export var max_speed = 40.0
@export var acceleration = 50.0

@onready var label = $Label
@onready var fsm: FiniteStateMachine = $FiniteStateMachine as FiniteStateMachine


@onready var zombie_wander_state: ZombieWanderState = $FiniteStateMachine/ZombieWanderState as ZombieWanderState
@onready var zombie_idle_state: ZombieIdleState = $FiniteStateMachine/ZombieIdleState as ZombieIdleState
@onready var enemy_chase_player_state: EnemyChasePlayerState = $FiniteStateMachine/EnemyChasePlayerState as EnemyChasePlayerState
@onready var zombie_jump_state: ZombieJumpState = $FiniteStateMachine/ZombieJumpState as ZombieJumpState

@export var is_scene = false
@export var move_manually = false
@export var move_to: Vector2

func _ready():
	#DEAMBULAR
	zombie_wander_state.found_player.connect(fsm.change_state.bind(enemy_chase_player_state))
	#SEGUIR
	enemy_chase_player_state.lost_player.connect(fsm.change_state.bind(zombie_wander_state))
	#IDLE
	zombie_idle_state.see_player.connect(fsm.change_state.bind(zombie_wander_state))
	#JUMP
	zombie_wander_state.jump.connect(fsm.change_state.bind(zombie_jump_state))
	zombie_jump_state.terminar_de_brincar.connect(fsm.change_state.bind(zombie_wander_state))

@onready var ray_cast_2d = $RayCast2D

func _process(delta: float) -> void:
	if player_node:
		# Convierte la posición global del jugador a coordenadas locales del enemigo
		var player_local_position = to_local(player_node.global_position)
		ray_cast_2d.target_position = player_local_position

func update_text(txt):
	if label:
		label.text = str(txt)
