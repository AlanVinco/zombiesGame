extends Node

var nextScene = "res://scenes/maps/house.tscn"
@onready var canvasImage =  $"../TextureRect"
@onready var audio_player = $"../AudioStreamPlayer"
@onready var visualNovelNode = $".."

func _ready() -> void:
	if Stats.visualNovel == "final1":
		visualNovelNode.cargar_csv("res://languages/zombies1DialogV1.csv", "ZOMBIE1", "zomb1_txt")
		actos = visualNovelNode.actos
		visualNovelNode.on_all_texts_displayed.connect(_on_all_texts_displayed)
		mostrar_acto(Acto, actos)
		MusicManager.music_player["parameters/switch_to_clip"] = "FINAL1"
		MusicManager.start_loop_for("FINAL1")
		

var Acto = 1

var actos = {}

func mostrar_acto(acto_numero, actos):
	if acto_numero in actos:
		print(acto_numero)
		
		if acto_numero == 1:
			audio_player.stream = load("res://sound/sounds/zombie-scream.mp3")
			audio_player.play()
		
		if acto_numero == 2 or acto_numero == 20 or acto_numero == 34 or acto_numero == 41:
			audio_player.stream = load("res://sound/sounds/zombie-scream.mp3")
			audio_player.play()
			$"../GemidoLeve".stop()
			$"..".shake_camera(1, 9.0)
		if acto_numero == 36 or acto_numero == 37 or acto_numero == 38 or acto_numero == 39 or acto_numero>44:
			$"..".shake_camera(1, 9.0)
		
		if acto_numero == 47:
			audio_player.stream = load("res://sound/sounds/bragueta_sound.mp3")
			audio_player.play()
		
		if acto_numero == 5 or acto_numero == 6:
			$"..".shake_camera(1, 9.0)
			
		if acto_numero ==8:
			$"..".shake_camera(1, 12.0)
			$"../GemidoLeve".stream = load("res://sound/sounds/FINAL1_QUEJIDO_PLAYER.ogg")
			$"../GemidoLeve".play()
			audio_player.stream = load("res://sound/sounds/golpe_cara1.ogg")
			audio_player.play()
		if acto_numero ==13:
			$"..".shake_camera(1, 12.0)
			audio_player.stream = load("res://sound/sounds/golpe_cara2.ogg")
			audio_player.play()
			$"../GemidoLeve".stream = load("res://sound/sounds/FINAL1_QUEJIDO_PLAYER2.ogg")
			$"../GemidoLeve".play()
		
		if acto_numero ==19:
			$"../GemidoLeve".stop()
			$"..".shake_camera(1, 12.0)
			audio_player.stream = load("res://sound/sounds/END/CAER.ogg")
			audio_player.play()
			
		if acto_numero == 22:
			$"../GemidoLeve".stream = load("res://sound/sounds/running.ogg")
			$"../GemidoLeve".play()
			
		if acto_numero == 39:
			audio_player.stream = load("res://sound/sounds/ROMPER_ROPA.ogg")
			audio_player.play()
		
		if acto_numero == 53:
			$"..".activate_moan = true
			canvasImage.visible = false
			$"../Animation".visible = true
			$"../Effect".visible = true
			$"../Effect".play("SPEED")
			$"../Animation".play("final1_scene1")
			$".."._set_random_speed()
			$"../GemidoLeve".stream = load("res://sound/sounds/missions/voice_breath.ogg")
			$"../GemidoLeve".play()
		
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		visualNovelNode.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1
	#elif acto_numero == 1:
		#audio_player.stream = load("res://sound/sounds/door_knoc_and_ooen.mp3")
		#audio_player.play()
		#Acto = acto_numero + 1
		#await get_tree().create_timer(1.0).timeout
		#mostrar_acto(Acto, actos)
	else:
		if Stats.is_recuerdo:
			GlobalTransitions.transition()
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file("res://scenes/maps/church.tscn")
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
			GlobalTransitions.player_position_city = Vector2(342, -18)
			GlobalTransitions.transition()
			await get_tree().create_timer(5.0).timeout
			$"../THE END".mostrar_the_end()

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
	
	if $"../Animation".animation == "final1_scene1":
		if $"../Animation".frame == 3:
			random_music(slap_paths, $"../slap")
			random_music(espejo_paths, $"../espejo")
			random_music(slime_paths, $"../slime")
			random_music(splash_paths, $"../splash")
			$"..".shake_camera(0.1, 2.0)

func random_music(music_paths, audio):
	var random_index = randi() % music_paths.size()
	var random_path = music_paths[random_index]
			
			# Cargar el sonido aleatorio en $slime
	audio.stream = load(random_path)
			
			# Reproducir el sonido
	audio.play()
