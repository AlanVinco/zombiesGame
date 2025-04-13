extends Node

var nextScene = "res://scenes/maps/house.tscn"
@onready var canvasImage =  $"../../TextureRect"
@onready var audio_player = $"../../AudioStreamPlayer"
@onready var visualNovelNode = $"../.."
var sceneName = "ENDPART2"
var sceneCodeTxt = "end_part2_txt"
var visualNovelName = "ENDPART2"

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
		
		if acto_numero == 7:
			$golpes.stop()
			$"../..".shake_camera(1.0, 8)
			
		var acto_data = actos[acto_numero]
		visualNovelNode.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1


	elif acto_numero == 0:
		MusicManager.music_player["parameters/switch_to_clip"] = "CHURCH_THEME"
		MusicManager.start_loop_for("CHURCH_THEME")
		$golpes.start()
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
			MusicManager.stop_music()
			$"../../Button".visible = false
			$"../../CanvasLayer/ColorRect".color = Color("ffffff")
			audio_player.stream = load("res://sound/sounds/END/kill_shot.ogg")
			audio_player.play()
			canvasImage.visible = false
			await get_tree().create_timer(5.0).timeout
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			GlobalTransitions.transition()
			GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
			GlobalTransitions.player_position_city = Vector2(342, -18)
			await get_tree().create_timer(0.5).timeout
			
			if Stats.HUSBAND > Stats.MALO:
				nextScene = "res://scenes/visualnovel.tscn"
				Stats.visualNovel = "MUERTERATZWEL"
			else:
				nextScene = "res://scenes/visualnovel.tscn"
				Stats.visualNovel = "MUERTEPLAYER"
				
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

func _on_golpes_timeout() -> void:
	var slap_paths = [
		"res://sound/sounds/NEWSOUNDS/GOLPE1.ogg",
		"res://sound/sounds/NEWSOUNDS/GOLPE2.ogg",
		"res://sound/sounds/NEWSOUNDS/GOLPE3.ogg",
		"res://sound/sounds/NEWSOUNDS/GOLPE4.ogg",
		"res://sound/sounds/NEWSOUNDS/GOLPE5.ogg",
	]
	var quejido_paths = [
		"res://sound/sounds/END/RATZ_QUEJIDO_!.ogg",
		"res://sound/sounds/END/RATZ_QUEJIDO_2.ogg",
		"res://sound/sounds/END/RATZ_QUEJIDO_3.ogg",
		"res://sound/sounds/END/RATZ_QUEJIDO_4.ogg",
		"res://sound/sounds/END/RATZ_QUEJIDO_5.ogg",
		"res://sound/sounds/END/RATZ_QUEJIDO_6.ogg",
		"res://sound/sounds/END/RATZ_QUEJIDO_7.ogg",
		"res://sound/sounds/END/RATZ_QUEJIDO_8.ogg",
	]
	
	var golpe_paths = [
		"res://sound/sounds/END/GOLPE_1.ogg",
		"res://sound/sounds/END/GOLPE_2.ogg",
		"res://sound/sounds/END/GOLPE_3.ogg",
		"res://sound/sounds/END/GOLPE_4.ogg",
		"res://sound/sounds/END/GOLPE_5.ogg",
	]
	var splash = [
		"res://sound/sounds/NEWSOUNDS/SPLASH1.ogg",

	]
	
	random_music(slap_paths, $"../../slap")
	random_music(quejido_paths, $"../../splash")
	random_music(golpe_paths, $"../../slime")
	random_music(splash, $"../../espejo")
	
	$"../..".shake_camera(0.5, 12)
