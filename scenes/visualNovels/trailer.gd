extends Node
@onready var canvasImage =  $"../TextureRect"

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#MusicManager.music_player.stop()
	#canvasImage.visible = false
	#$"../Animation".visible = true
	#$"../Effect".visible = true
	#$"../Effect".play("SPEED")
	#$"../Animation".play("Trailer2")
	#await get_tree().create_timer(2.0).timeout
	#$".."._set_random_speed()
	#$"..".activate_moan = true
	


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
	
	if $"../Animation".animation == "TRAILER1" or $"../Animation".animation == "Trailer2":
		if $"../Animation".frame == 0:
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
