extends Node

var user = {}

# Matchmaking
var user_enemy = {}
var interact = false
var trigger = true
var brazero_numbers = 0
var paused = false
var can_move = true
var player_postion = Vector2(0,0)

var attack_index = 0
var attack_names = ["[color=red]avalanche de singes[/color]","[color=red]poele surpuissante[/color]","[color=red]dragibus noir[/color]","[color=red]douche[/color]"]
var attack_values = [11,23,2,20]
var enemy_attack = attack_values[attack_index]

var pin = Vector2(0,0)
var pinb = Vector2(0,0)
var pinr = Vector2(0,0)
var piny = Vector2(0,0)
var ping = Vector2(0,0)
var pin_temp = Vector2(0,0)

var grid_size = 31
var step_delay = 0
var allow_loops = false
var letters_to_show = []
var show_labels = false
var saved_point_position: Vector2 = Vector2.ZERO 

var tutorial = true
var tutorial_stade = 0
var tutorial_validate = false

var button_info_pressed_player = false
var button_info_pressed_enemy = false
var close_button_pressed = false

var current_hour: int = 19
var current_minute: int = 45
var current_day: int = 0
var last_color = Color(1, 1, 1, 1)
var target_color: Color

var sprint_multiplier: float = 1.5

var pianos = [0,0,0,0]
var current_map = ""

var start_cinematic = {
	0: "START_CINEMATIC_TEXT_0",
	1: "START_CINEMATIC_TEXT_1",
	2: "START_CINEMATIC_TEXT_2",
	3: "START_CINEMATIC_TEXT_3",
	4: "START_CINEMATIC_TEXT_4",
	5: "START_CINEMATIC_TEXT_5",
}

var daily_events = {
"aurora_borealis": {"chance": 95, "active": false},  
"snowstorm": {"chance": 70, "active": false},
"clear_sky": {"chance": 0.1, "active": false}
}

var items = {
	0: {
		"name":"ANTIDOTE",
		"value":0,
		"type":[0, "antidote"],
		"effets":"Possibilite de recuperer l'animal ennemi. A utiliser si l'ennemi est inférieur a 20 PV",
		"texture":"res://Textures/Items/Potion_verte.png",
		"quantity":0
	},
	1: {
		"name":"BLUE_GEM",
		"value":0,
		"type":[1.15, "def"],
		"effets":"15% de DEF",
		"texture":"res://Textures/Items/Gemme_bleu.png",
		"quantity":0
	},
	2: {
		"name":"CREPE",
		"value":0,
		"type":[1.1, "atk"],
		"effets":"10% d'ATK",
		"texture":"res://Textures/Items/Crepes.png",
		"quantity":0
	},
	3: {
		"name":"APPLE",
		"value":0,
		"type":[5, "regen"],
		"effets":"5 PV",
		"texture":"res://Textures/Items/Apple.png",
		"quantity":0
	},
	4: {
		"name":"N-KEY",
		"value":0,
		"type":[1, "key"],
		"effets":"Active une porte",
		"texture":"res://Textures/Items/nkey.png",
		"quantity":0
	},
	5: {
		"name":"CRAMPTE",
		"value":0,
		"type":[2, "atk"],
		"effets":"200% d'ATK",
		"texture":"res://Textures/Items/crapte.png",
		"quantity":0
	}
}

var attacks = {
	0: {
		"name":"BOW",
		"value":11,
		"type":['Relique'],
		"boost":0,
		"texture":"res://Textures/Items/ARC.png",
		"quantity":0
	},
	1: {
		"name":"SWORD",
		"value":17,
		"type":['Totem'],
		"boost":0,
		"texture":"res://Textures/Items/EPEE.png",
		"quantity":0
	},
	2: {
		"name":"AXE",
		"value":20,
		"type":['Echo'],
		"boost":0,
		"texture":"res://Textures/Items/HACHE.png",
		"quantity":0
	},
	3: {
		"name":"STOVE",
		"value":23,
		"type":['Prisme'],
		"boost":0,
		"texture":"res://Textures/Items/POELE.png",
		"quantity":0
	},
}


signal fringe_changed

var selected_index = 0
var buttons = []
var ui = []
var ui_visible = true

func _ready():
	ui = get_tree().get_nodes_in_group("ui")


var actual_animal = {
	
	0: {
		"name":"Deagle",
		"infected": false,
		"type":['Totem'],
		"boost":[ 1.1 , "def"], #+10% de DEF pour le joueur et plus 5% de plus si l'arme est du meme type
		"effets":["+ 10% d'attaque pour le joueur ( Cumulable 1 fois ) et * 2 si l'arme "],        
		"textureA":"res://Textures/Animals/EAGLE_.png",
		"texture_animal_fight":"res://Textures/Animals/eagle_Player.png",
	},
}

func _process(delta):
	ui = get_tree().get_nodes_in_group("ui")
	for i in range(ui.size()):
		ui[i].visible = ui_visible


	buttons = get_tree().get_nodes_in_group("buttons")
	var joypads = Input.get_connected_joypads()
	if joypads.size() >= 1 and buttons.size() > 0:
		if Input.is_action_just_pressed("ui_down"):
			selected_index = (selected_index + 1) % buttons.size()
			update_button_selection()
		if Input.is_action_just_pressed("ui_up"):
			selected_index = (selected_index - 1 + buttons.size()) % buttons.size()
			update_button_selection()
		if Input.is_action_just_pressed(Controllers.a_input):
			pressed_button(buttons[selected_index])
	if tutorial == false:
		tutorial_stade = -1

func update_button_selection() -> void:
	for i in range(buttons.size()):
		if i == selected_index:
			buttons[i].modulate = Color(1, 1, 1, 1)  # Highlight selected button
		else:
			buttons[i].modulate = Color(0.5, 0.5, 0.5, 1)  # Dim non-selected buttons


func pressed_button(button):
	if get_tree().get_nodes_in_group("Player_One").size() > 0 and paused == true:
		button.emit_signal("pressed")
	elif get_tree().get_nodes_in_group("Player_One").size() == 0:
		button.emit_signal("pressed")

func save():
	var save_file = ConfigFile.new()
	save_file.set_value("Tuto", "Stade", tutorial_stade)
	save_file.set_value("Tuto", "Type", tutorial)
	save_file.set_value("Tuto", "Validate", tutorial_validate)
	save_file.set_value("Tags", "Blue", pinb)
	save_file.set_value("Tags", "Red", pinr)
	save_file.set_value("Tags", "Yellow", piny)
	save_file.set_value("Tags", "Green", ping)

	save_file.set_value("Tutorial", "Stade", tutorial_stade)
	save_file.set_value("Tutorial", "Validate", tutorial_validate)
	save_file.set_value("Tutorial", "Tutorial", tutorial)
	
	save_file.set_value("Quests", "infos", Quests.quests)
	save_file.set_value("Quests", "current", Quests.current_quest_id)
	if get_node_or_null("/root/main_map/CanvasLayer/Minimap") != null:
		save_file.set_value("Quests", "radar_position", get_node("/root/main_map/CanvasLayer/Minimap").pin)
		save_file.set_value("Quests", "radar_enabled", true)
	else:
		save_file.set_value("Quests", "radar_position", Vector2(0, 0))
		save_file.set_value("Quests", "radar_enabled", false)

	save_file.set_value("Player", "pseudo", PlayerStats.pseudo)
	save_file.set_value("Player", "health", PlayerStats.health)
	save_file.set_value("Player", "skin", PlayerStats.skin)
	save_file.set_value("Player", "level", PlayerStats.level)
	save_file.set_value("Player", "monnaie", PlayerStats.money)

	var player_node = get_node_or_null("/root/"+current_map+"/TileMap/Player_One")
	if player_node:
		save_file.set_value("Player", "position", player_node.position)
	else:
		print("Le joueur n'est pas disponible pour la sauvegarde de position.")

	save_file.set_value("Time", "hour", current_hour)
	save_file.set_value("Time", "minute", current_minute)
	save_file.set_value("Time", "day", current_day)
	save_file.set_value("Time", "color", target_color)
	save_file.save_encrypted_pass("user://save.txt", "gentle_duck")
	print("Sauvegarde terminée.")

func load():
	var load_file = ConfigFile.new()
	var error = load_file.load_encrypted_pass("user://save.txt", "gentle_duck")
	if error != OK:
		print("Erreur de chargement du fichier de sauvegarde :", error)
		return

	tutorial_stade = load_file.get_value("Tuto", "Stade", tutorial_stade)
	tutorial = load_file.get_value("Tuto", "Type", tutorial)
	tutorial_validate = load_file.get_value("Tuto", "Validate", tutorial_validate)
	pinb = load_file.get_value("Tags", "Blue", pinb)
	pinr = load_file.get_value("Tags", "Red", pinr)
	piny = load_file.get_value("Tags", "Yellow", piny)
	ping = load_file.get_value("Tags", "Green", ping)
	tutorial_stade = load_file.get_value("Tutorial", "Stade", tutorial_stade)
	tutorial_validate = load_file.get_value("Tutorial", "Validate", tutorial_validate)
	tutorial = load_file.get_value("Tutorial", "Tutorial", tutorial)
	
	PlayerStats.pseudo = load_file.get_value("Player", "pseudo", PlayerStats.pseudo)
	PlayerStats.health = load_file.get_value("Player", "health", PlayerStats.health)
	PlayerStats.skin = load_file.get_value("Player", "skin", PlayerStats.skin)
	PlayerStats.level = load_file.get_value("Player", "level", PlayerStats.level)
	PlayerStats.money = load_file.get_value("Player", "money", PlayerStats.money)

	var player_node = get_node_or_null("/root/"+current_map+"/TileMap/Player_One")
	if player_node:
		player_node.position = load_file.get_value("Player", "position", Vector2(0, 0))
		print("Position joueur chargée :", player_node.position)
	else:
		print("Erreur : Le joueur n'a pas été trouvé dans la scène.")
	
	current_hour = load_file.get_value("Time", "hour", current_hour)
	current_minute = load_file.get_value("Time", "minute", current_minute)
	current_day = load_file.get_value("Time", "day", current_day)
	target_color = load_file.get_value("Time", "color", target_color)
	print("color:"+ str(target_color))

func load_position():
	# Appelle le chargement différé
	call_deferred("_apply_player_position")

func load_user():
	var load_file = ConfigFile.new()
	load_file.load_encrypted_pass("user://user.txt", "user_key")
	Global.user = load_file.get_value("User","Data",Global.user)
	
func load_localisation():
	var load_file = ConfigFile.new()
	load_file.load_encrypted_pass("user://languages.txt", "gentle_duck")
	TranslationServer.set_locale(load_file.get_value("Languages","Current",TranslationServer.get_locale()))
	
func save_localisation():
	var save_file = ConfigFile.new()
	save_file.set_value("Languages","Current",TranslationServer.get_locale())
	save_file.save_encrypted_pass("user://languages.txt", "gentle_duck")

func _apply_player_position():
	var load_file = ConfigFile.new()
	load_file.load_encrypted_pass("user://save.txt", "gentle_duck")

	var player_node = get_node_or_null("/root/"+current_map+"/TileMap/Player_One")
	if player_node:
		player_node.position = load_file.get_value("Player", "position", Vector2(32, 100))
		print("Position joueur appliquée :", player_node.position)
	else:
		print("Erreur : Le joueur n'a pas été trouvé dans la scène.")

func smooth_zoom(_camera, zoom, _position_target, speed):
	var zoom_target = Vector2(zoom, zoom)
	while _camera.zoom.distance_to(zoom_target) > 0.01:
		_camera.zoom = lerp(_camera.zoom, zoom_target, speed)
		_camera.position = lerp(_camera.position, _position_target, speed)
		await get_tree().create_timer(speed).timeout

func save_user():
	var save_file = ConfigFile.new()
	save_file.set_value("User","Data",Global.user)
	save_file.save_encrypted_pass("user://user.txt", "user_key")
