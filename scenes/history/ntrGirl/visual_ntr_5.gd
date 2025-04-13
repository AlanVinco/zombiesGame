extends Node

var nextScene = "res://scenes/history/ntrGirl/.tscn"
@onready var canvasImage =  $"../../TextureRect"
@onready var audio_player = $"../../AudioStreamPlayer"
@onready var visualNovelNode = $"../.."
var sceneName = "NTR5VISUAL"
var sceneCodeTxt = "ntr5_visual_txt"
var visualNovelName = "NTR5VISUAL"

func _ready() -> void:
	if Stats.visualNovel == visualNovelName:
		visualNovelNode.cargar_csv("res://languages/zombies1DialogV1.csv", sceneName, sceneCodeTxt)
		actos = visualNovelNode.actos
		visualNovelNode.on_all_texts_displayed.connect(_on_all_texts_displayed)
		mostrar_acto(Acto, actos)

var Acto = 0

var actos = {}

func mostrar_acto(acto_numero, actos):
	print(acto_numero)
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		
		if acto_numero >= 2 and acto_numero <=17:
			$"../..".shake_camera(1, 9.0)
		
		if acto_numero == 18:
			MusicManager.music_player["parameters/switch_to_clip"] = "EXTASIS_THEME"
			MusicManager.start_loop_for("EXTASIS_THEME")
		
		if acto_numero == 1:
			$"../..".shake_camera(1, 9.0)
			$RisasVillanos.play()
			#audio_player.stream = load("res://sound/sounds/estrujar.ogg")
			#audio_player.play()
		if acto_numero == 10:
			##CACHETADA y llorar
			audio_player.stream = load("res://sound/sounds/CACHETADA.mp3")
			audio_player.play()
			$LlorarQuejido1.play()
		if acto_numero == 18:
			$"../..".activate_moan = true
			###OCULTAAAAAAAAAR####
			$LlorarQuejido1.stop()
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../../Effect".play("SPEED")
			$"../../Animation".play("ntr5_scene1")
			$"../.."._set_random_speed()

		if acto_numero == 41:
			##CUM SENE*******************
			$"../..".shake_camera(4, 12.0)
			$"../..".activate_moan = false
			$"../../moanRandom".stop()
			audio_player.stream = load("res://sound/sounds/SX/cm/cum_girl4.ogg")
			audio_player.play()
			$"../../Animation".play("ntr5_cum1")
		if acto_numero == 44:
			$"../..".activate_moan = true
			$"../../Animation".play("ntr5_scene2")
		if acto_numero == 61:
			##CUM SENE*******************
			$"../..".shake_camera(4, 12.0)
			$"../..".activate_moan = false
			$"../../moanRandom".stop()
			audio_player.stream = load("res://sound/sounds/SX/cm/cumsound_girl_corto.ogg")
			audio_player.play()
			$"../../Animation".play("ntr5_cum2")
		if acto_numero == 64:
			$"../.."._set_random_speed()
			$"../..".activate_moan = true
			$"../../Animation".play("ntr5_scene3")
		if acto_numero == 79:
			##CUM SENE*******************
			$"../..".shake_camera(4, 12.0)
			$"../..".activate_moan = false
			$"../../moanRandom".stop()
			audio_player.stream = load("res://sound/sounds/SX/cm/cum_sound_largo1.ogg")
			audio_player.play()
			$"../../Animation".play("ntr5_cum3")
		if acto_numero == 82:
			$"../.."._set_random_speed()
			$"../..".activate_moan = true
			$"../../Animation".play("ntr5_scene4")
		if acto_numero == 96:
			$"../..".shake_camera(4, 12.0)
			$"../..".activate_moan = false
			$"../../moanRandom".stop()
			audio_player.stream = load("res://sound/sounds/SX/cm/cum_girl4.ogg")
			audio_player.play()
			##CUM SENE*******************
			$"../../GemidoLeve".stop()
			$GirlRespirarRapido.play()
			$"../../Animation".stop()
			canvasImage.visible = true
			$"../../Animation".visible = false
			$"../../Effect".visible = false
		if acto_numero == 102 or acto_numero == 105:
			$"../../GemidoLeve".stop()
			audio_player.stream = load("res://sound/sounds/estrujar.ogg")
			audio_player.play()
		if acto_numero == 109:
			##FALTA SONIDO DE ENTRAR ANUS
			audio_player.stream = load("res://sound/sounds/SX/SLIME1.ogg")
			audio_player.play()
		if acto_numero == 115:
			$"../..".activate_moan = true
			$GirlRespirarRapido.stop()
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../../Animation".play("ntr5_scene5")
			$"../.."._set_random_speed()
		if acto_numero == 128:
			$"../../Animation".play("ntr5_scene6")
		if acto_numero == 141:
			$"../../Animation".play("ntr_5_scene7")
		if acto_numero == 152:
			$"../..".shake_camera(4, 12.0)
			$"../..".activate_moan = false
			$"../../moanRandom".stop()
			audio_player.stream = load("res://sound/sounds/SX/cm/grito_climax1.ogg")
			audio_player.play()
			$"../../GemidoLeve".stop()
			$"../../Animation".play("ntr5_cum4")
		if acto_numero == 156 or acto_numero == 158 or acto_numero == 159 or acto_numero == 160 or acto_numero == 162 or acto_numero == 164 or acto_numero == 166:
			##FALTAN TODAS LAS DE ABAJO
			$"../..".shake_camera(1, 9.0)
			canvasImage.visible = true
			$"../../Animation".visible = false
			$"../../Effect".visible = false
			$"../NTR3/GemidoLeve2".play()
			audio_player.stream = load("res://sound/sounds/estrujar.ogg")
			audio_player.play()
		if acto_numero == 174:
			$"../NTR3/GemidoLeve2".stop()
			##SONIDO EXTRA THICK CUM 
			$"../..".shake_camera(10, 15.0)
			audio_player.stream = load("res://sound/sounds/SX/cm/cum_girl3.ogg")
			audio_player.play()
			$Xtremecumsound.play()
		if acto_numero == 177:
			##SONIDO de loca falta
			$CaerCum.play()
			$GirlExtasisFinal.play()
			
		
		var acto_data = actos[acto_numero]
		visualNovelNode.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1


	elif acto_numero == 0:
		MusicManager.music_player["parameters/switch_to_clip"] = "VISUAL_TRES"
		MusicManager.start_loop_for("VISUAL_TRES")
		audio_player.stream = load("res://sound/sounds/convert_ntr_sound_reduce.ogg")
		audio_player.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)

	else:
		if Stats.is_recuerdo:
			GlobalTransitions.transition()
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file("res://scenes/maps/church.tscn")
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			audio_player.stream = load("res://sound/sounds/cerrar_puerta_fuerte.mp3")
			audio_player.play()
			GlobalTransitions.transition()
			GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
			GlobalTransitions.player_position_city = Vector2(342, -18)
			await get_tree().create_timer(0.5).timeout
			Stats.time = "day"
			Stats.MALO += 20
			get_tree().change_scene_to_file(nextScene)

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
	
	if $"../../Animation".animation == "ntr5_scene1" or  $"../../Animation".animation == "ntr5_scene3":
		if $"../../Animation".frame == 2:
			random_music(slap_paths, $"../../slap")
			random_music(bed_paths, $"../../bed")
			random_music(slime_paths, $"../../slime")
			$"../..".shake_camera(0.1, 2.0)
			#random_music(slime_paths, $"../../slime")
	if $"../../Animation".animation == "ntr5_scene4" or $"../../Animation".animation == "ntr5_scene5" or $"../../Animation".animation == "ntr5_scene6":
		if $"../../Animation".frame == 3:
			random_music(slap_paths, $"../../slap")
			random_music(bed_paths, $"../../bed")
			random_music(slime_paths, $"../../slime")
			$"../..".shake_camera(0.1, 2.0)
			#random_music(slime_paths, $"../../slime")
	if $"../../Animation".animation == "ntr5_scene2" or $"../../Animation".animation == "ntr_5_scene7":
		if $"../../Animation".frame == 4:
			random_music(slap_paths, $"../../slap")
			random_music(bed_paths, $"../../bed")
			random_music(slime_paths, $"../../slime")
			$"../..".shake_camera(0.1, 2.0)
