extends Node

var nextScene = "res://scenes/maps/house.tscn"
@onready var canvasImage =  $"../TextureRect"
@onready var audio_player = $"../AudioStreamPlayer"
@onready var visualNovelNode = $".."

func _ready() -> void:
	print(actos)
	if Stats.visualNovel == "market1":
		visualNovelNode.cargar_csv("res://languages/zombies1DialogV1.csv", "market1", "vnmkt1_txt")
		actos = visualNovelNode.actos
		visualNovelNode.on_all_texts_displayed.connect(_on_all_texts_displayed)
		mostrar_acto(Acto, actos)

var Acto = 0

var actos = {}

func mostrar_acto(acto_numero, actos):
	print(acto_numero)
	if acto_numero in actos and Acto != 17 and Acto != 38 and Acto != 45 and Acto != 55 and Acto != 61 and Acto != 66 and Acto != 72 and Acto != 77 and Acto != 83 and Acto != 91 and Acto != 97 and Acto != 105 and Acto != 111 and Acto != 117 and Acto != 122 and Acto != 131 and Acto != 139 and Acto != 144 and Acto !=  154 and Acto != 159 and Acto != 169:
		await get_tree().create_timer(0.5).timeout
		if  acto_numero == 9 or acto_numero == 18 or acto_numero == 19 or acto_numero == 42 or acto_numero == 50 or acto_numero == 56 or acto_numero == 62 or acto_numero == 78 or acto_numero == 84 or acto_numero == 85 or acto_numero == 101 or acto_numero == 110 or acto_numero == 119 or acto_numero == 138 or acto_numero == 158 or acto_numero == 162 or acto_numero == 163 or acto_numero == 164 or acto_numero == 165 or acto_numero == 166 or acto_numero == 167 or acto_numero == 168 or acto_numero == 181 or acto_numero == 182:
			$"..".shake_camera(1, 9.0)
		var acto_data = actos[acto_numero]
		visualNovelNode.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		canvasImage.texture = load(acto_data["image"])
		Acto = acto_numero + 1
	elif acto_numero == 0:
		MusicManager.music_player["parameters/switch_to_clip"] = "VISUAL_UNO"
		MusicManager.start_loop_for("VISUAL_UNO")
		audio_player.stream = load("res://sound/sounds/door_knoc_and_ooen.mp3")
		audio_player.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		
		
	elif acto_numero == 17:
		MusicManager.music_player["parameters/switch_to_clip"] = "VISUAL_TRES"
		MusicManager.start_loop_for("VISUAL_TRES")
		$"../TextureRect".visible = false
		audio_player.stream = load("res://sound/sounds/bigKiss.mp3")
		audio_player.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
		$kisses.play()
		
	elif acto_numero == 38:
		$"../TextureRect".visible = false
		#$kisses.stream = load("res://sound/sounds/clothes-frotar.mp3")
		$kisses.stop()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
		
	elif acto_numero == 45:
		$"../TextureRect".visible = false
		$kisses.stream = load("res://sound/sounds/wet-mouth-sounds-asmr.mp3")
		$kisses.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
		
	elif acto_numero == 55:
		$"../TextureRect".visible = false
		#$kisses.stream = load("res://sound/sounds/wet-mouth-sounds-asmr.mp3")
		$kisses.stop()
		$"../AudioStreamPlayer".stream = load("res://sound/sounds/levantar_playera.mp3")
		$"../AudioStreamPlayer".play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
		
	elif acto_numero == 61:
		$"../TextureRect".visible = false
		$kisses.stream = load("res://sound/sounds/frotal_piel_debil.mp3")
		$kisses.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
		
	elif acto_numero == 66:
		$"../TextureRect".visible = false
		$kisses.stream = load("res://sound/sounds/mouth_sounds_2.mp3")
		$kisses.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
	elif acto_numero == 72:
		$"../TextureRect".visible = false
		$kisses.stream = load("res://sound/sounds/frotar_piel_fuerte.mp3")
		$kisses.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
	elif acto_numero == 77:
		$"../TextureRect".visible = false
		$kisses.stream = load("res://sound/sounds/kiss_boca1.mp3")
		$kisses.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
	elif acto_numero == 83:
		$"../TextureRect".visible = false
		$kisses.stream = load("res://sound/sounds/H_FellaKyo30.ogg")
		$kisses.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
	elif acto_numero == 91:
		$"../TextureRect".visible = false
		$kisses.stream = load("res://sound/sounds/frotar_piel_fuerte.mp3")
		$kisses.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
		
	elif acto_numero == 97:
		$"../TextureRect".visible = false
		$kisses.stream = load("res://sound/sounds/frotar_piel_fuerte.mp3")
		$kisses.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
		
	elif acto_numero == 105:
		$"../TextureRect".visible = false
		$kisses.stream = load("res://sound/sounds/frotar_piel_fuerte.mp3")
		$kisses.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
		
	elif acto_numero == 111:
		$"../TextureRect".visible = false
		$kisses.stream = load("res://sound/sounds/frotar_piel_fuerte.mp3")
		$kisses.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
	elif acto_numero == 117:
		$"../TextureRect".visible = false
		$kisses.stream = load("res://sound/sounds/bed.mp3")
		$kisses.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
	elif acto_numero == 122:
		MusicManager.music_player["parameters/switch_to_clip"] = "EXTASIS_THEME"
		MusicManager.start_loop_for("EXTASIS_THEME")
		$"../TextureRect".visible = false
		$kisses.stream = load("res://sound/sounds/lamerdebil.mp3")
		$breath.stream = load("res://sound/sounds/girl_respirando_suave.mp3")
		$kisses.play()
		$breath.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
	elif acto_numero == 131:
		$"../TextureRect".visible = false
		$kisses.stream = load("res://sound/sounds/H_FellaKyo30.ogg")
		$kisses.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
	elif acto_numero == 139:
		$"../TextureRect".visible = false
		$kisses.stop()
		$breath.stop()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
	elif acto_numero == 144:
		$"../TextureRect".visible = false
		$kisses.stop()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
	elif acto_numero == 154:
		$"../AudioStreamPlayer".stream = load("res://sound/sounds/levantar_playera.mp3")
		$"../AudioStreamPlayer".play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
		$"../TextureRect".visible = true
	elif acto_numero == 159:
		$"../TextureRect".visible = false
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout
	elif acto_numero == 169:
		$"../TextureRect".visible = false
		$kisses.stream = load("res://sound/sounds/mujer_llorando.mp3")
		$kisses.play()
		Acto = acto_numero + 1
		await get_tree().create_timer(1.0).timeout
		mostrar_acto(Acto, actos)
		await get_tree().create_timer(0.6).timeout

		
	else:
		$"../AudioStreamPlayer".stream = load("res://sound/sounds/cerrar_puerta_fuerte.mp3")
		$"../AudioStreamPlayer".play()
		if Stats.is_recuerdo:
			GlobalTransitions.transition()
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file("res://scenes/maps/church.tscn")
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			GlobalTransitions.transition()
			GlobalTransitions.player_position_house_hall = Vector2(-115, 204)
			GlobalTransitions.player_position_city = Vector2(342, -18)
			await get_tree().create_timer(0.5).timeout
			Stats.time = "night"
			get_tree().change_scene_to_file(nextScene)

func _on_all_texts_displayed():
	mostrar_acto(Acto, actos)
