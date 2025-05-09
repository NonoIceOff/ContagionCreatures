extends Node

var user = {}
var level = 1  # Store the player's level globally
var skill_points = 0

var current_xp = 0  # Store the player's current XP globally
var target_xp = 0   # Store the target XP globally
var xp_to_next_level = 100  # Store the XP required for the next level globally

# Matchmaking
var user_enemy = {}
var interact = false
var trigger = true
var brazero_numbers = 0
var player_postion = Vector2(0,0)
var game_paused = false
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

var is_speedrun_timer = false
var is_minimap = true
var is_eternal_day = FLAG_PROCESS_THREAD_MESSAGES_PHYSICS
var is_daycycle = true

var grid_size = 31
var step_delay = 0
var allow_loops = false
var letters_to_show = []
var show_labels = false
var saved_point_position: Vector2 = Vector2.ZERO 

var tutorial = true
var tutorial_stade = 6
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

var starters_id = [0,0,0]

var party_timer_seconds = 0

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
var animals_player = {

	0: {
		"name":"GentleDuck",
		"infected": false,
		"type":['Prisme'],
		"boost":[ 1.08 , 1.06 , "atk/def"], #+8% d'ATK et 6% DEF pour le joueur et * 2 si arme du meme type
		"effets":["+6% d'attaque et +6% de defense pour le joueur et *2 si"],
		"textureA":"res://Textures/pixil-frame-0_3.png"
	},
	1: {
		"name":"Deagle",
		"infected": false,
		"type":['Relique'],
		"boost":[ 1.1 , "def"], #+10% de DEF pour le joueur et plus 5% de plus si l'arme est du meme type
		"effets":["+ 10% d'attaque pour le joueur ( Cumulable 1 fois ) et *2 si"],		
		"textureA":"res://Textures/Animals/EAGLE_.png",
	},
	2: {
		"name":"Froggy",
		"infected": false,
		"type":['Essence'],
		"boost":[ 1.03 ,"atk"], #d'ATK pour le player et plus 5% de plus si l'arme est du meme type
		"effets":["+ 3% d'attaque à chaque tours pour le joueur et *2 si"],
		"textureA":"res://Textures/Animals/FROG.png",
	},
	3: {
		"name":"Leonard",
		"infected": false,
		"type":['Totem'],
		"boost":[  1.2 , "regen"],  # +20 PV à chaque tours pour le joueur et plus 5% de plus si l'arme est du meme type
		"effets":["+ 20 PV à chaque tours pour le joueur et *2 "],								
		"textureA":"res://Textures/Animals/DRAGON.png",
	},
	4: {
		"name":"Douglas",
		"infected": false,
		"type":['Echo'],
		"boost":[  0.9 , "DEF"],  # +9 de DEF pour le joueur et plus 5% de plus si l'arme est du meme type
		"effets":["+9% de defense en plus pour l'utilisateur et 5%"],						
		"textureA": "res://Textures/Animals/CHICKEN.png",		
	},
}

var animals_enemy = {
	0: {
		"name":"Deagle",
		"infected": true,
		"type":['Relique'],
		"boost":[ 1.1, "def"], #+10% de DEF pour le player si l'arme est du même type
		"effets":["+10% de defense en plus pour l'utilisateur et *2 si l'arme est du meme type"],
		"textureA":"res://Textures/Animals/EAGLE_.png",
		"texture_infected":"res://Textures/Animals/Eagle_infected.png"
	},
	1: {
		"name":"GentleDuck",
		"infected": true,
		"type":['Prisme'],
		"boost":[ 1.06 , "atk"], #+6% d'ATK et DEF pour le joueur si l'arme est du même type
		"effets":["+6% d'attaque en plus pour l'utilisateur et *2 si l'arme est du meme type"],		
		"textureA":"res://Textures/pixil-frame-0_3.png",
		"texture_infected":""
	},
	2: {
		"name":"Froggy",
		"infected": true,
		"type":['Essence'],
		"boost":[ 1.03 ,"atk"], # +3% d'ATK pour le joueur si l'arme est du même type
		"effets":["+3% d'attaque en plus pour l'utilisateur et *2 si l'arme est du meme type"],
		"textureA":"res://Textures/Animals/FROG.png",
		"texture_infected":""
	},
	3: {
		"name":"Leonard",
		"infected": true,
		"type":['Echo'],
		"boost":[ 1.2, "regen"],  # +20 PV à chaque tours pour le joueur si l'arme est du même type
		"effets":["L'utilisateur recupere +2O pv en plus à chaque tour et *2 si l'arme est du meme type"],
		"textureA":"res://Textures/Animals/DRAGON.png",
		"texture_infected":""
	},
	4: {
		"name":"Douglas",
		"infected": true,
		"type":['Relique'],
		"boost":[  1.09 , "def"], # +9 de DEF pour le joueur pendant tout le combat si l'arme est du même type
		"effets":["+9% de defense en plus pour l'utilisateur"],  
		"textureA": "res://Textures/Animals/CHICKEN.png",
		"texture_infected":""
	},
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
	if get_tree().get_nodes_in_group("Player_One").size() > 0 and game_paused == true:
		button.emit_signal("pressed")
	elif get_tree().get_nodes_in_group("Player_One").size() == 0:
		button.emit_signal("pressed")


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

func add_creature(id: int) -> void:
	var url = "https://contagioncreaturesapi.vercel.app/api/creatures/%s" % id

	var http := HTTPRequest.new()
	add_child(http)

	# Connecte le signal à une méthode dédiée
	http.request_completed.connect(_on_creature_request_completed.bind(http))

	var error = http.request(url)
	if error != OK:
		print("Erreur lors de la requête :", error)

func _on_creature_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, http: HTTPRequest) -> void:
	if response_code != 200:
		print("Erreur HTTP :", response_code)
		return

	var creature = JSON.parse_string(body.get_string_from_utf8())
	if creature == null:
		print("Erreur de parsing JSON")
		return

	var file_path = "res://Constantes/creatures.json"
	var creatures: Array = []

	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file:
			var content = file.get_as_text()
			file.close()
			if content.strip_edges() != "":
				var parse_result := JSON.new()
				var error = parse_result.parse(content)
				if error == OK and typeof(parse_result.data) == TYPE_ARRAY:
					creatures = parse_result.data
				else:
					print("Contenu invalide dans creatures.json, utilisation d'une liste vide.")


	creatures.append(creature)

	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(creatures, "\t"))
		file.close()
		print("Créature ajoutée avec succès.")
		print(creatures)
	else:
		print("Erreur : impossible d'ouvrir le fichier en écriture.")

	# Nettoie le noeud HTTP pour éviter des fuites mémoire
	http.queue_free()
