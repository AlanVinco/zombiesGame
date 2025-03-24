class_name MageSummonState
extends State

@export var actor: MageBoss
@export var zombie_scene: PackedScene  

signal señal_invulnerable_disparar

func _enter_state():
	$"../../VOICE".stream = load("res://sound/sounds/Nueva carpeta/MAGE1.ogg")
	$"../../VOICE".play()
	actor.update_text("INVOCAR")
	actor.animator.play("summon")
	actor.is_invulnerable = true
	actor.total_zombie += 1
	# ✅ Ahora los zombies se invocan en MageBoss, no en este estado
	actor.summon_zombies(zombie_scene, actor.total_zombie*3) 

	await get_tree().create_timer(1.5).timeout
	señal_invulnerable_disparar.emit()
