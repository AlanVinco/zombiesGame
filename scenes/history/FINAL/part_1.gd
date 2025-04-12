extends Node

var nextScene = "res://scenes/versus_page.tscn"
@onready var canvasImage =  $"../../TextureRect"
@onready var audio_player = $"../../AudioStreamPlayer"
@onready var visualNovelNode = $"../.."
var sceneName = "BODAFINAL"
var sceneCodeTxt = "final1_txt"
var visualNovelName = "BODAFINAL"
var versus_scene

func _ready() -> void:
	if Stats.visualNovel == visualNovelName:
		versus_scene = load(nextScene).instantiate()
		visualNovelNode.cargar_csv("res://languages/zombies1DialogV1.csv", sceneName, sceneCodeTxt)
		actos = visualNovelNode.actos
		visualNovelNode.on_all_texts_displayed.connect(_on_all_texts_displayed)
		mostrar_acto(Acto, actos)

var Acto = 63

var actos = {}

func mostrar_acto(acto_numero, actos):
	print(acto_numero)
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		if acto_numero == 1:
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../../Effect".play("SPEED")
			$"../../Animation".play("boda_scene1")
			$"../../GemidoLeve".stream = load("res://sound/sounds/besos_sonido_loop.ogg")
			$"../../GemidoLeve".play()
		if acto_numero == 7:
			audio_player.stream = load("res://sound/sounds/POLICE_SEDIO_CUENTA.ogg")
			audio_player.play()
			canvasImage.visible = true
			$"../../Animation".visible = false
			$"../../Effect".visible = false
		if acto_numero == 12:
			audio_player.stream = load("res://sound/sounds/cerrar_puerta_fuerte.mp3")
			audio_player.play()
			$"../../GemidoLeve".stop()			
		if acto_numero == 25:
			audio_player.stream = load("res://sound/sounds/CAMPANA.ogg")
			audio_player.play()
		if acto_numero == 27:
			MusicManager.music_player["parameters/switch_to_clip"] = "BODA_DOS"
			$"../../GemidoLeve".stream = load("res://sound/sounds/MULTITUD.mp3")
			$"../../GemidoLeve".play()
			
		if acto_numero == 33:
			audio_player.stream = load("res://sound/sounds/DOOR CHURCH OPEN.mp3")
			audio_player.play()
		if acto_numero == 45:
			$"../../GemidoLeve".stream = load("res://sound/sounds/GEMIDO/GEMIDNO_SUAVE3.ogg")
			$"../../GemidoLeve".play()
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../../Animation".play("boda_scene2")
		if acto_numero == 63:
			MusicManager.music_player["parameters/switch_to_clip"] = "BODA_TRES"
			canvasImage.visible = true
			$"../../Animation".visible = false
			$"../../Effect".visible = false
			$"../../Animation".stop()
			audio_player.stream = load("res://sound/sounds/PLAYERBODA1.ogg")
			audio_player.play()
			$"../../sonido2".stream = load("res://sound/sounds/DOOR CHURCH OPEN.mp3")
			$"../../sonido2".play()
		if acto_numero == 68:
			audio_player.stream = load("res://sound/sounds/PLAYERBODA2.ogg")
			audio_player.play()
			$"../../GemidoLeve".stream = load("res://sound/sounds/PLAYERBODA3.ogg")
			$"../../GemidoLeve".play()
		if acto_numero == 74:
			$"../../GemidoLeve".stream = load("res://sound/sounds/PLAYERBODA4.ogg")
			$"../../GemidoLeve".play()
		if acto_numero == 84:
			$"../../NTR/NTR5/LlorarQuejido1".play()
			$"../../GemidoLeve".stream = load("res://sound/sounds/RATZWELBODA2.ogg")
			$"../../GemidoLeve".play()
		
		if acto_numero == 92:
			$"../../GemidoLeve".stop()
			$"../../NTR/NTR5/LlorarQuejido1".stop()
			audio_player.stream = load("res://sound/sounds/GOLPE.ogg")
			audio_player.play()
			
		if acto_numero == 96:
			$"../../GemidoLeve".stream = load("res://sound/sounds/RATZWELBODA4.ogg")
			$"../../GemidoLeve".play()
		if acto_numero == 108:
			$"../../NTR/NTR5/LlorarQuejido1".play()
		if acto_numero == 115:
			$"../../NTR/NTR5/LlorarQuejido1".stop()
			$"../../GemidoLeve".stream = load("res://sound/sounds/PLAYERBODA6.ogg")
			$"../../GemidoLeve".play()
			
		var acto_data = actos[acto_numero]
		visualNovelNode.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1


	elif acto_numero == 0:
		MusicManager.music_player["parameters/switch_to_clip"] = "BODA_UNO"
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
	#elif acto_numero == 9 or acto_numero == 19:
		#Acto = acto_numero + 1
		#mostrar_acto(Acto, actos)
	else:
		if Stats.is_recuerdo:
			GlobalTransitions.transition()
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file("res://scenes/maps/church.tscn")
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$"../../GemidoLeve".stop()
			MusicManager.music_player["parameters/switch_to_clip"] = "BODA_END"
			await get_tree().create_timer(15.0).timeout
			GlobalTransitions.transition()
			GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
			GlobalTransitions.player_position_city = Vector2(342, -18)
			await get_tree().create_timer(0.5).timeout
			Stats.time = "night"
			versus_scene.mission = 5
			get_tree().current_scene.queue_free()  # Liberar la escena actual
			get_tree().root.add_child(versus_scene)  # Agregar la nueva escena
			get_tree().current_scene = versus_scene  # Definirla como la escena actual

func _on_all_texts_displayed():
	mostrar_acto(Acto, actos)

func random_music(music_paths, audio):
	var random_index = randi() % music_paths.size()
	var random_path = music_paths[random_index]
			
			# Cargar el sonido aleatorio en $slime
	audio.stream = load(random_path)
			
			# Reproducir el sonido
	audio.play()


func _on_animation_frame_changed() -> void:
	# Array con las rutas de los sonidos
	var slap_paths = [
		"res://sound/sounds/SX/SLAP1.ogg",
		"res://sound/sounds/SX/SLAP2.ogg",
		"res://sound/sounds/SX/SLAP3.ogg",
		"res://sound/sounds/SX/SLAP4.ogg"
	]
	var bed_paths = [
		"res://sound/sounds/SX/BED1.ogg",
		"res://sound/sounds/SX/BED2.ogg",
		"res://sound/sounds/SX/BED3.ogg",
		"res://sound/sounds/SX/BED4.ogg",
	]
	var slime_paths = [
		"res://sound/sounds/SX/SLIME1.ogg",
		"res://sound/sounds/SX/SLIME2.ogg",
		"res://sound/sounds/SX/SLIME3.ogg",
		"res://sound/sounds/SX/SLIME4.ogg",
		"res://sound/sounds/SX/SLIME5.ogg",
		"res://sound/sounds/SX/SLIME6.ogg",
		"res://sound/sounds/SX/SLIME7.ogg",
	]
	
	if $"../../Animation".animation == "boda_scene2":
		if $"../../Animation".frame == 2:
			#random_music(slap_paths, $"../../slap")
			#random_music(bed_paths, $"../../bed")
			random_music(slime_paths, $"../../slime")
