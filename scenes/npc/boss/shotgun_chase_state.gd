class_name ShotgunChaseState
extends State

@export var actor: RatzwelFinalBoss

signal termino_de_caminar
signal ImpactCharge_State
signal ButtStrike_State

var has_emitted_charge = false
var checking_distance := true

func _ready() -> void:
	set_physics_process(false)

func _enter_state():
	has_emitted_charge = false
	checking_distance = true
	set_physics_process(true)
	actor.update_text("Sigue al jugador")
	actor.animator.play("walkFront")

	# Esperar solo si no se activa la carga de impacto
	await get_tree().create_timer(5.0).timeout

	if !has_emitted_charge:
		# Aún no emitimos nada, entonces sí podemos seguir con la lógica de explotar
		checking_distance = false
		actor.update_text("¡Preparando habilidad!")
		await get_tree().create_timer(1.0).timeout
		termino_de_caminar.emit()

func _physics_process(delta) -> void:
	if !checking_distance:
		return  # No seguimos verificando si ya explotamos

	var distance = actor.global_position.distance_to(actor.player_node.global_position)
	var direction = (actor.player_node.global_position - actor.global_position).normalized()
	actor.velocity = direction * actor.max_speed
	actor.move_and_slide()

	if distance < 100.0 and !has_emitted_charge:
		has_emitted_charge = true
		checking_distance = false
		set_physics_process(false)
		ImpactCharge_State.emit()
