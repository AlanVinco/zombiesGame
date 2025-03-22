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
			audio_player.stream = load("res://sound/sounds/cumsound1.mp3")
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
			###OCULTAAAAAAAAAR####
			canvasImage.visible = false
			$"../../Effect".visible = true
			$"../../Animation".visible = true
			$"../../Animation".play("sexDayNTR3")
			$SexSecoV1.play()
			$RechinarCama.play()
		if acto_numero == 242:
			Stats.time = "afternoon"
			$"../../Animation".play("sexAfternoonNTR3")
			#$"../../Animation".speed_scale = 1.5
			$SexSecoV1.stop()
			$SexSecov2.play()
		if acto_numero == 252:
			Stats.time = "night"
			$"../../Animation".play("sexNightNTR3")
			#$"../../Animation".speed_scale = 2.0
			$SexSecov2.stop()
			$SexSuperwetV2.play()
		if acto_numero == 277:
			$"../../Effect".visible = false
			$"../../Animation".visible = false
			canvasImage.visible = true
			$SexSuperwetV2.stop()
			$RechinarCama.stop()
			audio_player.stream = load("res://sound/sounds/bed.mp3")
			audio_player.play()
			
		var acto_data = actos[acto_numero]
		visualNovelNode.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1


	elif acto_numero == 0:
		audio_player.stream = load("res://sound/sounds/convert_ntr_sound_reduce.ogg")
		audio_player.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
	#elif acto_numero == 9 or acto_numero == 19:
		#Acto = acto_numero + 1
		#mostrar_acto(Acto, actos)
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
