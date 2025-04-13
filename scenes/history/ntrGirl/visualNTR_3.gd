extends Node

var nextScene = "res://scenes/visualNovels/ntr_3_house.tscn"
@onready var canvasImage =  $"../../TextureRect"
@onready var audio_player = $"../../AudioStreamPlayer"
@onready var visualNovelNode = $"../.."
var sceneName = "NTR3"
var sceneCodeTxt = "ntr3_visual_txt"
var visualNovelName = "ntrvisual3"

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
		
		if acto_numero == 4 or acto_numero == 28 or acto_numero == 47 or acto_numero == 53 or acto_numero == 63 or acto_numero == 70 or acto_numero == 74 or acto_numero == 75 or acto_numero == 87  or acto_numero == 123 or acto_numero == 124 or acto_numero == 127 or acto_numero == 128 or acto_numero == 133 or acto_numero == 147 or acto_numero == 155 or acto_numero == 181 or acto_numero == 183 or acto_numero == 186 or (acto_numero >= 204 and acto_numero <= 212) or acto_numero == 271 or acto_numero == 272 or acto_numero == 273 or acto_numero == 275:
			$"../..".shake_camera(1, 9.0)
		if acto_numero == 4:
			MusicManager.music_player["parameters/switch_to_clip"] = "VISUAL_TRES"
			MusicManager.start_loop_for("VISUAL_TRES")
		if acto_numero == 28:
			MusicManager.music_player["parameters/switch_to_clip"] = "VISUAL_DOS"
			MusicManager.start_loop_for("VISUAL_DOS")
		if acto_numero == 214:
			MusicManager.music_player["parameters/switch_to_clip"] = "EXTASIS_THEME"
			MusicManager.start_loop_for("EXTASIS_THEME")
		
		if acto_numero == 10 or acto_numero == 18 or acto_numero == 13:
			audio_player.stream = load("res://sound/sounds/levantar_playera.mp3")
			audio_player.play()
		if acto_numero == 24:
			audio_player.stream = load("res://sound/sounds/estrujar.ogg")
			audio_player.play()
		if acto_numero == 28:
			###OCULTAAAAAAAAAR####
			canvasImage.visible = false
			$"../../Animation".visible = true
			$"../../Effect".visible = true
			$"../../Effect".play("SPEED")
			$"../../Animation".play("licklipsNTR3")
			$"../../Market1/kisses".play()
		if acto_numero == 47:
			$"../../Effect".visible = false
			$"../../Animation".visible = false
			canvasImage.visible = true
			$"../../Market1/kisses".stop()
			audio_player.stream = load("res://sound/sounds/bigKiss.mp3")
			audio_player.play()
		if acto_numero == 52:
			canvasImage.visible = false
			$"../../Effect".visible = true
			$"../../Animation".visible = true
			$"../../Animation".play("kisslipv2NTR3")
			$Besos.play()
			
		if acto_numero == 77:
			$Besos.stop()
			$"../../GemidoLeve".play()
			$"../../Animation".play("cunilingusNTR3")
			$cunilingus_sound.play()
		if acto_numero == 87:
			$"../../Animation".speed_scale = 2.0
			$"../../GemidoLeve".stop()
			$GemidoLeve2.play()
		if acto_numero == 114:
			$"../..".shake_camera(3, 11.0)
			$cunilingus_sound.stop()
			$"../../Animation".speed_scale = 1.0
			audio_player.stream = load("res://sound/sounds/squirt.mp3")
			$"../../sonido2".stream = load("res://sound/sounds/venirseMujer1.mp3")
			$GemidoLeve2.stop()
			$"../../sonido2".play()
			audio_player.play()
			$"../../Animation".play("NTR2SquirtStart")
		if acto_numero == 115:
			$"../../Market1/breath".play()
			$"../NTR2/Gota".play()
			$"../../Animation".play("NTR2squirt")
		if acto_numero == 123:
			##VOLVER AMOSTRAR##################
			$"../../Market1/breath".stop()
			$"../NTR2/Gota".stop()
			$"../../Effect".visible = false
			$"../../Animation".visible = false
			canvasImage.visible = true
			$"../NTR2/Gota".stop()
			audio_player.stream = load("res://sound/sounds/bragueta_sound.mp3")
			audio_player.play()
		if acto_numero == 127:
			audio_player.stream = load("res://sound/sounds/mosca.mp3")
			audio_player.play()
		if acto_numero == 133:
			$"../../Market1/kisses".play()
			canvasImage.visible = false
			$"../../Effect".visible = true
			$"../../Animation".visible = true
			$"../../Animation".play("fellatioNTR3")
			$"../../Market1/kisses".play()
		if acto_numero == 147:
			$"../../Animation".speed_scale = 2.0
		if acto_numero == 148:
			$"../../Market1/kisses".stop()
			$HFellaUrgency.play()
		if acto_numero == 155:
			$"../../Animation".play("fellatioCumNTR3")
			audio_player.stream = load("res://sound/sounds/SX/cm/cum_mouth_tocer.ogg")
			audio_player.play()
			$"../../sonido2".stream = load("res://sound/sounds/spermboca4.wav")
			$"../../sonido2".play()
		if acto_numero == 192:
			$HFellaUrgency.stop()
			$"../../Animation".speed_scale = 1.0
			$"../../Effect".visible = false
			$"../../Animation".visible = false
			canvasImage.visible = true
		if acto_numero == 196:
			audio_player.stream = load("res://sound/sounds/ponerCondom.mp3")
			audio_player.play()
		if acto_numero == 199:
			audio_player.stream = load("res://sound/sounds/bed.mp3")
			audio_player.play()
		if acto_numero == 213:
			$"../..".activate_moan = true
			###OCULTAAAAAAAAAR####
			canvasImage.visible = false
			$"../../Effect".visible = true
			$"../../Animation".visible = true
			$"../../Animation".play("sexDayNTR3")
			$"../.."._set_random_speed()
		if acto_numero == 242:
			Stats.time = "afternoon"
			$"../../Animation".play("sexAfternoonNTR3")
			#$"../../Animation".speed_scale = 1.5
		if acto_numero == 252:
			Stats.time = "night"
			$"../../Animation".play("sexNightNTR3")
			#$"../../Animation".speed_scale = 2.0
		if acto_numero == 277:
			$"../..".activate_moan = false
			$"../../moanRandom".stop()
			$"../../Animation".stop()
			$"../../Effect".visible = false
			$"../../Animation".visible = false
			canvasImage.visible = true
			audio_player.stream = load("res://sound/sounds/bed.mp3")
			audio_player.play()
			
		var acto_data = actos[acto_numero]
		visualNovelNode.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1


	elif acto_numero == 0:
		MusicManager.music_player["parameters/switch_to_clip"] = "VISUAL_UNO"
		MusicManager.start_loop_for("VISUAL_UNO")
		audio_player.stream = load("res://sound/sounds/convert_ntr_sound_reduce.ogg")
		audio_player.play()
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
			audio_player.stream = load("res://sound/sounds/cerrar_puerta_fuerte.mp3")
			audio_player.play()
			GlobalTransitions.transition()
			GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
			GlobalTransitions.player_position_city = Vector2(342, -18)
			await get_tree().create_timer(0.5).timeout
			Stats.time = "night"
			Stats.MALO += 20
			get_tree().change_scene_to_file(nextScene)

func _on_all_texts_displayed():
	mostrar_acto(Acto, actos)


func _on_animation_frame_changed() -> void:
	var slap_paths = [
		"res://sound/sounds/NEWSOUNDS/GOLPE1.ogg",
		"res://sound/sounds/NEWSOUNDS/GOLPE2.ogg",
		"res://sound/sounds/NEWSOUNDS/GOLPE3.ogg",
		"res://sound/sounds/NEWSOUNDS/GOLPE4.ogg",
		"res://sound/sounds/NEWSOUNDS/GOLPE5.ogg",
	]
	var bed_paths = [
		"res://sound/sounds/NEWSOUNDS/RECHINA1.ogg",
		"res://sound/sounds/NEWSOUNDS/RECHINA2.ogg",
		"res://sound/sounds/NEWSOUNDS/RECHINA3.ogg",
		"res://sound/sounds/NEWSOUNDS/RECHINA4.ogg",
		"res://sound/sounds/NEWSOUNDS/RECHINA5.ogg",
		"res://sound/sounds/NEWSOUNDS/RECHINA6.ogg",
	]
	var slime_paths = [
		"res://sound/sounds/NEWSOUNDS/AGUA1.ogg",
		"res://sound/sounds/NEWSOUNDS/AGUA2.ogg",
		"res://sound/sounds/NEWSOUNDS/AGUA3.ogg",
		"res://sound/sounds/NEWSOUNDS/AGUA4.ogg",
		"res://sound/sounds/NEWSOUNDS/AGUA5.ogg",
		"res://sound/sounds/NEWSOUNDS/AGUA6.ogg",
		"res://sound/sounds/NEWSOUNDS/AGUA7.ogg",
	]
	var espejo_paths = [
		"res://sound/sounds/NEWSOUNDS/ESPEJO1.ogg",
		"res://sound/sounds/NEWSOUNDS/ESPEJO2.ogg",
		"res://sound/sounds/NEWSOUNDS/ESPEJO3.ogg",
		"res://sound/sounds/NEWSOUNDS/ESPEJO4.ogg",
		"res://sound/sounds/NEWSOUNDS/ESPEJO5.ogg",
	]
	var splash_paths = [
		"res://sound/sounds/NEWSOUNDS/SPLASH1.ogg",
		"res://sound/sounds/NEWSOUNDS/SPLASH2.ogg",
		"res://sound/sounds/NEWSOUNDS/SPLASH3.ogg",
		"res://sound/sounds/NEWSOUNDS/SPLASH4.ogg",
		"res://sound/sounds/NEWSOUNDS/SPLASH5.ogg",
		"res://sound/sounds/NEWSOUNDS/SPLASH6.ogg",
	]
	
	var finger_paths = [
		"res://sound/sounds/NEWSOUNDS/FINGER1.ogg",
		"res://sound/sounds/NEWSOUNDS/FINGER2.ogg",
		"res://sound/sounds/NEWSOUNDS/FINGER3.ogg",
		"res://sound/sounds/NEWSOUNDS/FINGER4.ogg",
		"res://sound/sounds/NEWSOUNDS/FINGER5.ogg",
	]
	
	var bed2_paths = [
		"res://sound/sounds/SX/BED1.ogg",
		"res://sound/sounds/SX/BED2.ogg",
		"res://sound/sounds/SX/BED3.ogg",
		"res://sound/sounds/SX/BED4.ogg",
	]
	
	if $"../../Animation".animation == "sexDayNTR3" or $"../../Animation".animation == "sexNightNTR3" or  $"../../Animation".animation == "sexAfternoonNTR3":
		if $"../../Animation".frame == 1:
			random_music(slap_paths, $"../../slap")
			random_music(espejo_paths, $"../../espejo")
			random_music(slime_paths, $"../../slime")
			random_music(splash_paths, $"../../splash")
			random_music(bed_paths, $"../../bed")
			$"../..".shake_camera(0.1, 2.0)

func random_music(music_paths, audio):
	var random_index = randi() % music_paths.size()
	var random_path = music_paths[random_index]
			
			# Cargar el sonido aleatorio en $slime
	audio.stream = load(random_path)
			
			# Reproducir el sonido
	audio.play()
