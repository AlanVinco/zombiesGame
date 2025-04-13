extends Node

@onready var music_player = $AudioManager
var current_clip = ""
var clip_durations = {
	"FOREST_THEME": 309.0,  # Duración en segundos
	"CHURCH_THEME": 28.0,
	"ROMANTIC_THEME": 90.0,
	"BATTLE_1_THEME": 192.0,
	"BAR_THEME": 204.6,
	"HAVANY_HAPPY": 137.4,
	"HAVANY_PREOCUPADA": 393.6,
	"HAVANY_CORRUPTED": 12.0,
	"HAVANY_NORMAL": 262.8,
	"HAVANY_OTRA": 87.0,
	"RATZWEL_THEME": 300.0,
	"RATZWEL_OFFICE": 282.0,
	"CITY_THEME": 187.2,
	"ZEKION_THEME": 202.2,
	"STILY_HOUSE": 273.0,
	"MARKET_THEME": 130.8,
	"GUN_THEME": 204.6,
	"GYM_THEME": 258.6,
	"FINAL_BATTLE_THEME": 141.6,
	"BATTLE_4_THEME": 190.8,
	"BATTLE_2_THEME": 188.4,
	"SAD_THEME": 211.2,
	"RATZWEL_WIN": 73.8,
	"RATZWEL_DEAD_THEME": 25.0,
	"EL_TRISTE": 205.2,
	"MENU_THEME": 389.4,
	"BREEF_BATTLE": 196.8,
	"EXTASIS_THEME": 57.0,
	"VISUAL_UNO": 65.4,
	"VISUAL_DOS": 181.8,
	"VISUAL_TRES": 88.2,
	"BAR_DANCE": 249,
	"BODA_END": 24.0,
	"BODA_UNO": 306.6,
	"BODA_DOS": 151.2,
	"BODA_TRES": 154.8,
	"FINAL1": 502.2,
	# Agrega más clips y su duración aquí
}

var loop_timer: Timer

func _ready() -> void:
	music_player.play()
	start_loop_for("FOREST_THEME")  # Canción inicial

func start_loop_for(clip_name: String) -> void:
	current_clip = clip_name
	music_player["parameters/switch_to_clip"] = clip_name

	if loop_timer:
		loop_timer.stop()
		loop_timer.queue_free()

	# Crear nuevo timer con la duración del clip
	loop_timer = Timer.new()
	var duration = clip_durations.get(clip_name, 60.0)  # Valor por defecto si no se encuentra
	loop_timer.wait_time = duration
	loop_timer.one_shot = true
	loop_timer.timeout.connect(_on_timer_timeout)
	add_child(loop_timer)
	loop_timer.start()

func _on_timer_timeout() -> void:
	# Reproduce de nuevo el mismo clip
	start_loop_for(current_clip)

func stop_music() -> void:
	music_player.stop()
	if loop_timer:
		loop_timer.stop()

func set_music_volume(volume: float) -> void:
	music_player.volume_db = volume
