extends Node2D

@onready var office = $"../.."
@onready var player = $PlayerNpc
@onready var Havany = $HavanyNpcState
@onready var text = $TEXT
@export var escenevisual = "res://scenes/maps/house.tscn"
@export var sceneName = "NTR3SUB"
@export var sceneCodeTxt = "ntr_3_dialogue_sub"
@export var visualNovelName = "res://scenes/maps/house.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#condicionar
	text.on_all_texts_displayed.connect(_on_all_texts_displayed)
	player.is_scene = true
	Havany.is_scene = true
	ntr_history()
	
func ntr_history():
	#office.on_all_texts_displayed.connect(_on_all_texts_displayed)
	await get_tree().create_timer(1.0).timeout
	_on_all_texts_displayed()

var Acto = 1

var actos = {}

func mostrar_acto(acto_numero, actos):
	if acto_numero in actos:
		await get_tree().create_timer(0.5).timeout
		var acto_data = actos[acto_numero]
		text.create_text(acto_data["textos"], acto_data["personaje"], acto_data["emocion"])
		Acto = acto_numero + 1
	else:
		#Stats.visualNovel = visualNovelName
		GlobalTransitions.transition()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file(escenevisual)

func _on_all_texts_displayed():
	text.cargar_csv("res://languages/zombies1DialogV1.csv", sceneName, sceneCodeTxt)
	var new_actos = transformar_actos(text.actos)
	actos = new_actos
	
	#var actos = { 
	#1: { "textos": ["ntr_3_dialogue_sub1"], "image": "", "personaje": "PLAYER", "emocion": "NORMAL" }, 
	#2: { "textos": ["ntr_3_dialogue_sub2"], "image": "", "personaje": "PLAYER", "emocion": "NORMAL" }, 
	#3: { "textos": ["ntr_3_dialogue_sub3"], "image": "", "personaje": "PLAYER", "emocion": "NORMAL" }, 
	#4: { "textos": ["ntr_3_dialogue_sub4"], "image": "", "personaje": "HAVANYCORTA2WET", "emocion": "NORMAL" }, 
	#5: { "textos": ["ntr_3_dialogue_sub5"], "image": "", "personaje": "HAVANYCORTA2WET", "emocion": "NORMAL" }, 
	#6: { "textos": ["ntr_3_dialogue_sub6"], "image": "", "personaje": "HAVANYCORTA2WET", "emocion": "NORMAL" }, 
	#7: { "textos": ["ntr_3_dialogue_sub7"], "image": "", "personaje": "HAVANYCORTA2WET", "emocion": "NORMAL" }, 
	#8: { "textos": ["ntr_3_dialogue_sub8"], "image": "", "personaje": "PLAYER", "emocion": "NORMAL" }, 
	#9: { "textos": ["ntr_3_dialogue_sub9"], "image": "", "personaje": "PLAYER", "emocion": "NORMAL" }, 
	#10: { "textos": ["ntr_3_dialogue_sub10"], "image": "", "personaje": "PLAYER", "emocion": "NORMAL" }, 
	#11: { "textos": ["ntr_3_dialogue_sub11"], "image": "", "personaje": "PLAYER", "emocion": "NORMAL" }, 
	#12: { "textos": ["ntr_3_dialogue_sub12"], "image": "", "personaje": "PLAYER", "emocion": "NORMAL" }, 
	#13: { "textos": ["ntr_3_dialogue_sub13"], "image": "", "personaje": "PLAYER", "emocion": "NORMAL" }, 
	#14: { "textos": ["ntr_3_dialogue_sub14"], "image": "", "personaje": "HAVANYCORTA2WET", "emocion": "NORMAL" }, 
	#15: { "textos": ["ntr_3_dialogue_sub15"], "image": "", "personaje": "PLAYER", "emocion": "NORMAL" }, 
	#16: { "textos": ["ntr_3_dialogue_sub16"], "image": "", "personaje": "HAVANYCORTA2WET", "emocion": "NORMAL" }, 
	#17: { "textos": ["ntr_3_dialogue_sub17"], "image": "", "personaje": "HAVANYCORTA2WET", "emocion": "NORMAL" } 
	#}
	
	#var actos2 = {
		#1:{ "textos": ["ntr_3_dialogue_sub1", "ntr_3_dialogue_sub2", "ntr_3_dialogue_sub3"], "image": "", "personaje": "PLAYER", "emocion": "NORMAL" },
		#2:{ "textos": ["ntr_3_dialogue_sub4, ntr_3_dialogue_sub5, ntr_3_dialogue_sub6", "ntr_3_dialogue_sub7"], "image": "", "personaje": "HAVANYCORTA2WET", "emocion": "NORMAL" },
		#3:{ "textos": ["ntr_3_dialogue_sub8", "ntr_3_dialogue_sub9", "ntr_3_dialogue_sub10", "ntr_3_dialogue_sub11", "ntr_3_dialogue_sub12", "ntr_3_dialogue_sub13"], "image": "", "personaje": "PLAYER", "emocion": "NORMAL" },
		#4:{ "textos": ["ntr_3_dialogue_sub14",], "image": "", "personaje": "HAVANYCORTA2WET", "emocion": "NORMAL" },
		#5:{ "textos": ["ntr_3_dialogue_sub15",], "image": "", "personaje": "PLAYER", "emocion": "NORMAL" },
		#6:{ "textos": ["ntr_3_dialogue_sub16", "ntr_3_dialogue_sub17"], "image": "", "personaje": "HAVANYCORTA2WET", "emocion": "NORMAL" },
	#}
	#print(actos)
	mostrar_acto(Acto, actos)

func transformar_actos(actos):
	var new_actos = {}
	var current_index = 1
	var last_personaje = null
	var last_emocion = null
	var last_image = null
	var textos_grupo = []
	
	for key in actos.keys():
		var entry = actos[key]
		var personaje = entry["personaje"]
		var emocion = entry["emocion"]
		var image = entry["image"]
		var texto = entry["textos"][0]
		
		# Si es el mismo personaje y emoción, agrupamos los textos
		if personaje == last_personaje and emocion == last_emocion:
			textos_grupo.append(texto)
		else:
			# Si cambia de personaje o emoción, guardamos el grupo anterior
			if textos_grupo.size() > 0:
				new_actos[current_index] = {
					"textos": textos_grupo,
					"image": last_image,
					"personaje": last_personaje,
					"emocion": last_emocion
				}
				current_index += 1
			
			# Iniciamos un nuevo grupo
			textos_grupo = [texto]
			last_personaje = personaje
			last_emocion = emocion
			last_image = image
	
	# Guardar el último grupo si hay textos pendientes
	if textos_grupo.size() > 0:
		new_actos[current_index] = {
			"textos": textos_grupo,
			"image": last_image,
			"personaje": last_personaje,
			"emocion": last_emocion
		}

	return new_actos
