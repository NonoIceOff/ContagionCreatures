extends Node2D

var speechbox =  preload("res://Scenes/speech_box_COMBAT.tscn")
var rng = RandomNumberGenerator.new()
var pv_player = 100
var pv_enemy = 100
var defense_player = 0
var buttonP : Button
var buttonE : Button
var animalP : Sprite2D
var animalE : Sprite2D
var background_rect_info : ColorRect
@onready var http_request: HTTPRequest = $HTTPRequest
@onready var player_creature_name = $ContainerPLAYER/Pseudo

@onready var player_progress_bar_hp  = $ContainerPLAYER/TextureProgressBar
@onready var player_percentage_hp  = $ContainerPLAYER/TextureProgressBar/Percentage

@onready var mob_progress_bar_hp  = $ContainerMob/TextureProgressBar
@onready var mob_pseudo_label  = $ContainerMob/Pseudo
@onready var mob_percentage_hp  = $ContainerMob/TextureProgressBar/Percentage

@onready var http_get_creatures = $GetCreaturesEnemy
@onready var http_get_creatures_spells = $GetSpellsPlayer
@onready var http_get_enemy_spells = $GetSpellsEnnemy

const API_URL = "https://contagioncreaturesapi.vercel.app/api/creatures"  # Remplacez par votre URL d'API
const CREATURES_FILE_PATH = "res://Constantes/creatures.json"  # Chemin vers le fichier JSON local
var creatures_data = []
var enemy_creatures_data = []
var creatures_spells = []
var enemy_creatures_spells = []



func _ready():
	# Obtenir le mob de l'ennemi
	var enemy_mob_id = randi_range(1,10)
	http_get_creatures.request(API_URL+"/"+str(enemy_mob_id))
	
	# Obtenir les spells de l'ennemi
	http_get_enemy_spells.request(API_URL+"/"+str(enemy_mob_id)+"/attacks")
	
	
	
	
	
	_load_local_json()
	activate_buttons()
	creatures_data = _load_local_json()
	
	# Obtenir les spells du joueur
	print("ok")
	http_get_creatures_spells.request(API_URL+"/"+str(creatures_data[0].id)+"/attacks")
	#print(creatures_spells)
	
	

	
	var i = 0
	for key in Global.actual_animal:
		if Global.animals_player[key] == Global.animals_player[PlayerStats.animal_id]:
			
			animalP = Sprite2D.new()
			animalP.name = "Sprite"
			animalP.texture = load(Global.actual_animal[PlayerStats.animal_id]["texture_animal_fight"])
			animalP.texture_filter =  CanvasItem.TEXTURE_FILTER_NEAREST 
			animalP.position = Vector2(774,995)
			animalP.z_index = 0
			animalP.scale = Vector2(5.1,5.1)
			add_child(animalP)
			
			buttonP = Button.new()
			buttonP.name = "info_buttonP"
			buttonP.name = str(key)
			buttonP.connect("pressed", Callable(self, "_create_and_display_label_player").bind(creatures_data[0]["name"], creatures_data[0]["type"], creatures_data[0]["description"]))
			buttonP.position = Vector2(660,890)
			buttonP.custom_minimum_size = Vector2(70,70)
			add_child(buttonP)
			
			var sprite = Sprite2D.new()
			sprite.name = "Sprite"
			sprite.texture = load("res://Textures/Info.png")
			sprite.scale = Vector2(2,2)
			sprite.position = Vector2(35,35)
			buttonP.add_child(sprite)
		
		
	for key in Global.animals_enemy:
		if Global.animals_enemy[key] == Global.animals_enemy[PlayerStats.animal_id]:
			
			
			
			animalE = Sprite2D.new()
			animalE.name = "Sprite_animal_enemy"
			animalE.texture = load(Global.animals_enemy[PlayerStats.animal_id]["texture_infected"])
			print("Animal enemy: " + str(Global.animals_enemy[PlayerStats.animal_id]["name"]) +" et de type: " + str(Global.animals_enemy[PlayerStats.animal_id]["type"][0]))
			animalE.texture_filter =  CanvasItem.TEXTURE_FILTER_NEAREST 
			animalE.position = Vector2(1102,841)
			animalE.z_index = 0
			animalE.scale = Vector2(5.1,5.1)
			add_child(animalE)
			
			buttonE = Button.new()
			buttonE.name = "info_buttonE"
			buttonE.name = str(key)
			buttonE.position = Vector2(1200,821)
			buttonE.connect("pressed", Callable(self, "_create_and_display_label_enemy"))			
			buttonE.modulate = Color(1, 0.54902, 0, 1)
			buttonE.custom_minimum_size = Vector2(70,70)
			add_child(buttonE)
			
			var sprite = Sprite2D.new()
			sprite.name = "Sprite"
			sprite.texture = load("res://Textures/Info.png")
			sprite.scale = Vector2(2,2)
			sprite.position = Vector2(35,35)
			buttonE.add_child(sprite)
			
			
	if PlayerStats.animal_id != -1:
		for key in Global.actual_animal:
			for keys in Global.attacks:
				if Global.actual_animal[key]["type"] == Global.attacks[keys]["type"]:
						print(Global.actual_animal[key]["type"][0])
						print(Global.attacks[keys]["type"][0])
						var boost_animal = Global.attacks[keys]["value"] * 2
						Global.attacks[keys]["value"] += boost_animal
					
	

func _load_local_json():


	var json_as_text = FileAccess.get_file_as_string(CREATURES_FILE_PATH)
	var parse_result = JSON.parse_string(json_as_text)

	if parse_result == null:
		print("Erreur lors du chargement du fichier JSON local.")
	else:
		print("Type de données JSON correct pour le fichier local.")
	print(parse_result[0].name)
	player_creature_name.text = parse_result[0].name
	if parse_result == null:
		print("Erreur lors du chargement du fichier JSON local.")
		return []
		
	return parse_result
	
		
func _create_and_display_label_player(name, type, description):
	if background_rect_info != null:
		return 

	# Création et configuration du panneau
	background_rect_info = ColorRect.new()
	var screen_size = get_viewport_rect().size
	background_rect_info.size = Vector2(800, 600)
	background_rect_info.position = (screen_size - background_rect_info.size) / 2
	background_rect_info.color = Color(0.0, 0.0, 0.2, 0.9)
	add_child(background_rect_info)

	# Configuration du label d'information
	var label_info = Label.new()
	label_info.text = name
	label_info.add_theme_font_override("font", load("res://Font/8-BIT_WONDER.TTF"))
	label_info.scale = Vector2(2, 2)
	label_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label_info.position.x = background_rect_info.size.x / 2.5
	label_info.position.y = background_rect_info.size.y / 2
	background_rect_info.add_child(label_info)

	# Configuration du label de type
	var effects_label = Label.new()
	effects_label.text = "Description : " + str(description)
	effects_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	effects_label.size = Vector2(700, 50)
	effects_label.add_theme_font_override("font", load("res://Font/8-BIT_WONDER.TTF"))
	effects_label.scale = Vector2(1, 1)
	effects_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	effects_label.position = Vector2((background_rect_info.size.x - effects_label.size.x) / 2, background_rect_info.size.y - effects_label.size.y - 10)
	background_rect_info.add_child(effects_label)
	
	var type_label = Label.new()
	type_label.text = "Type: " + str(type)
	type_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	type_label.size = Vector2(700, 50)
	type_label.add_theme_font_override("font", load("res://Font/8-BIT_WONDER.TTF"))
	type_label.scale = Vector2(1, 1)
	type_label.position = Vector2((background_rect_info.size.x - type_label.size.x) / 2, effects_label.position.y - type_label.size.y - 10)
	background_rect_info.add_child(type_label)
	# Configuration du bouton de fermeture
	var close_button = Button.new()
	close_button.custom_minimum_size = Vector2(70, 70)
	close_button.position = Vector2(background_rect_info.size.x - close_button.size.x - 80, 10)
	close_button.connect("pressed", Callable(self, "_close_info_animalP"))
	background_rect_info.add_child(close_button)

	var sprite = Sprite2D.new()
	sprite.texture = load("res://Textures/Cross_Close.png")
	sprite.scale = Vector2(2.5, 2.5)
	sprite.position = Vector2(close_button.size.x / 2, close_button.size.y / 2)
	close_button.add_child(sprite)

	desactivate_buttons()
	
func _create_and_display_label_enemy():
	
	background_rect_info = ColorRect.new()
	var screen_size = get_viewport_rect().size
	var center_position = screen_size / 2
	background_rect_info.size = Vector2(800, 600)
	background_rect_info.position = (screen_size - background_rect_info.size) / 2
	background_rect_info.color = Color(0.2, 0.0, 0.0, 0.9)  
	add_child(background_rect_info)
	
	var sprite_animal_info = Sprite2D.new()
	sprite_animal_info.texture_filter =  CanvasItem.TEXTURE_FILTER_NEAREST
	if Global.animals_enemy[PlayerStats.animal_id]["infected"] == false:
		sprite_animal_info.texture = load(Global.animals_enemy[PlayerStats.animal_id]["textureA"])
	else:
		sprite_animal_info.texture = load(Global.animals_enemy[PlayerStats.animal_id]["texture_infected"])				
	sprite_animal_info.scale = Vector2(6,6)
	sprite_animal_info.position = Vector2(background_rect_info.size.x /2 , background_rect_info.size.y /3) 
	background_rect_info.add_child(sprite_animal_info)
	
	var label_info = Label.new()
	label_info.text = enemy_creatures_data.name
	label_info.add_theme_font_override("font", load("res://Font/8-BIT_WONDER.TTF"))
	label_info.scale = Vector2(2, 2)
	label_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label_info.position.x = background_rect_info.size.x / 2.5
	label_info.position.y = background_rect_info.size.y / 2
	background_rect_info.add_child(label_info)
	
	var close_button = Button.new()
	close_button.scale = Vector2(1,1)
	close_button.custom_minimum_size = Vector2(70,70)
	close_button.position = Vector2(background_rect_info.size.x - close_button.size.x - 80, 10)
	close_button.connect("pressed" , Callable( self , "_close_info_animalE"))
	background_rect_info.add_child(close_button)
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://Textures/Cross_Close.png")
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST 
	sprite.scale = Vector2(2.5,2.5)
	sprite.position = Vector2(close_button.size.x / 2, close_button.size.y / 2)
	close_button.add_child(sprite)
	
	var effects_label = Label.new()
	effects_label.text = "Description : " + enemy_creatures_data.description
	effects_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	effects_label.size = Vector2(700, 50)
	effects_label.add_theme_font_override("font", load("res://Font/8-BIT_WONDER.TTF"))
	effects_label.scale = Vector2(1, 1)
	effects_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	effects_label.position = Vector2((background_rect_info.size.x - effects_label.size.x) / 2, background_rect_info.size.y - effects_label.size.y - 10)
	background_rect_info.add_child(effects_label)
	
	var type_label = Label.new()
	type_label.text = "Type: " + enemy_creatures_data.type
	type_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	type_label.size = Vector2(700, 50)
	type_label.add_theme_font_override("font", load("res://Font/8-BIT_WONDER.TTF"))
	type_label.scale = Vector2(1, 1)
	type_label.position = Vector2((background_rect_info.size.x - type_label.size.x) / 2, effects_label.position.y - type_label.size.y - 10)
	background_rect_info.add_child(type_label)
	desactivate_buttons()

func _close_info_animalP():
	if background_rect_info != null:
		background_rect_info.queue_free()
		background_rect_info = null  # Reset to allow re-creation
		activate_buttons()
		
func _close_info_animalE():
	if background_rect_info != null:
		background_rect_info.queue_free()
		activate_buttons()
		
func activate_buttons():
	if buttonP != null and buttonE != null:
		buttonP.disabled = false
		buttonE.disabled = false
		get_node("Button").disabled = false
		get_node("Button2").disabled = false
		
	else:
		print("Les boutons ne sont pas initialisés.")

func desactivate_buttons():
	if buttonP != null and buttonE != null:
		buttonP.disabled = true
		buttonE.disabled = true
		get_node("Button").disabled = true
		get_node("Button2").disabled = true
		
	else:
		print("Les boutons ne sont pas initialisés.")

func spawn_dialogue(custom_texts):
	var dialogue = speechbox.instantiate()
	dialogue.position = Vector2(0,-380)
	dialogue.texts = custom_texts
	add_child(dialogue)

func _process(delta):
	rng.randomize()

	# Progress bar de HP du joueur
	if (creatures_data != []):
		player_progress_bar_hp.max_value = creatures_data[0].hp
		player_progress_bar_hp.value = creatures_data[0].hp
		player_percentage_hp.text = str(creatures_data[0].hp)+"/"+str(player_progress_bar_hp.max_value)
	
	# Progress bar de HP du joueur
	if enemy_creatures_data.size() > 1:
		mob_progress_bar_hp.max_value = enemy_creatures_data.hp
		mob_progress_bar_hp.value = enemy_creatures_data.hp
		mob_percentage_hp.text = str(enemy_creatures_data.hp)+"/"+str(mob_progress_bar_hp.max_value)
		mob_pseudo_label.text = enemy_creatures_data.name
	
	if (creatures_spells != []):
		get_node("Spell1").text = creatures_spells[0].name
		get_node("Spell2").text = creatures_spells[1].name
		get_node("Spell3").text = creatures_spells[2].name
		get_node("Spell4").text = creatures_spells[3].name


func _on_get_spells_player_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response_text = body.get_string_from_utf8()
	var parse_result = JSON.parse_string(response_text)
	creatures_spells = parse_result


func _on_get_spells_ennemy_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response_text = body.get_string_from_utf8()
	var parse_result = JSON.parse_string(response_text)
	enemy_creatures_spells = parse_result

func _on_get_creatures_enemy_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response_text = body.get_string_from_utf8()
	var parse_result = JSON.parse_string(response_text)
	enemy_creatures_data = parse_result
