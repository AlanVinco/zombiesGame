extends Node2D

@onready var Player = $".."
@onready var EnemyBar = $ProgressBar

@export var enemyHPvalue = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Player.BOSSHUD == true:
		visible = true
		enemyHPvalue = Player.HPBOSS
		updateHP()
	else:
		visible = false

func updateHP():
	print(Player.HPBOSS)
	EnemyBar.value = enemyHPvalue
