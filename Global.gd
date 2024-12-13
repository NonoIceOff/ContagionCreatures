extends Node

var user = {}

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

var current_quest_id = -1

var current_hour: int = 19
var current_minute: int = 0
var current_day: int = 1
var last_color = Color(1, 1, 1, 1)
var target_color: Color


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

signal fringe_changed

func quest_finished(i):
	Tutorial.get_node(".").tutorials[7]["progress"] += 100
	if get_node_or_null("/root/"+current_map+"/SoundEffectFx") != null:
		get_node("/root/"+current_map+"/SoundEffectFx").playing = false
	if get_node_or_null("/root/"+current_map+"/ui/TerminatedQuest") != null:
		get_node("/root/"+current_map+"/AudioStreamPlayer2D").stream = load("res://Sounds/victory.mp3")
		get_node("/root/"+current_map+"/AudioStreamPlayer2D").playing = true
		get_node("/root/"+current_map+"/ui/TerminatedQuest").visible = true
		get_node("/root/"+current_map+"/ui/TerminatedQuest/Name").text = Global.quests[i]["title"]
		await get_tree().create_timer(5).timeout 
		if get_node_or_null("/root/"+current_map+"/ui/TerminatedQuest") != null:
			get_node("/root/"+current_map+"/ui/TerminatedQuest").visible = false
	if get_node_or_null("/root/main_map/SoundEffectFx") != null:
		get_node("/root/main_map/SoundEffectFx").playing = true
	quests[i]["finished"] = true

func set_quest(i):
	if i == -1:
		if get_node_or_null("/root/"+current_map+"/ui/CPUParticles2D") != null:
			get_node("/root/"+current_map+"/ui/CPUParticles2D").visible = false
	else:
		Global.current_quest_id = i
		if get_node_or_null("/root/"+current_map+"/ui/Minimap") != null:
			if get_node_or_null("/root/"+current_map+"/ui/CPUParticles2D") != null:
				get_node("/root/"+current_map+"/ui/CPUParticles2D").visible = true
			
			get_node("/root/"+current_map+"/ui/Minimap").change_pin(Global.quests[i]["pin_positions"][Global.quests[i]["stade"]])

func _ready():
	pass

func _process(delta):
	if tutorial == false:
		tutorial_stade = -1

var quests = {
	0: {
		"title":"QUEST_0_TITLE",
		"long_description":"QUEST_0_LONG_DESCRIPTION",
		"descriptions":
			["QUEST_0_DESCRIPTION0",
			"QUEST_0_DESCRIPTION1",
			"QUEST_0_DESCRIPTION2",
			"QUEST_0_DESCRIPTION3",
			"QUEST_0_DESCRIPTION4",
			"QUEST_0_DESCRIPTION5"],
		"mini_descriptions":
			["QUEST_0_MINI_DESCRIPTION0","QUEST_0_MINI_DESCRIPTION1","QUEST_0_MINI_DESCRIPTION2","QUEST_0_MINI_DESCRIPTION3","QUEST_0_MINI_DESCRIPTION4","QUEST_0_MINI_DESCRIPTION5"],
		"pin_positions":[Vector2(1448,291),Vector2(3128,-664),Vector2(3128,-664),Vector2(1448,291),Vector2(3128,-664),Vector2(3128,-664)],
		"stade":0,
		"finished":false,
		"members_only":false,
	},
	1: {
		"title":"QUEST_1_TITLE",
		"long_description":"QUEST_1_LONG_DESCRIPTION",
		"descriptions":
			["QUEST_1_DESCRIPTION0",
			"QUEST_1_DESCRIPTION1",
			"QUEST_1_DESCRIPTION2",
			"QUEST_1_DESCRIPTION3"],
		"mini_descriptions":
			["QUEST_1_MINI_DESCRIPTION0","QUEST_1_MINI_DESCRIPTION1","QUEST_1_MINI_DESCRIPTION2","QUEST_1_MINI_DESCRIPTION3"],
		"pin_positions":[Vector2(980,-680),Vector2(980,-680),Vector2(764,932),Vector2(-500,-740)],
		"stade":0,
		"finished":false,
		"members_only":true,
	},
	2: {
		"title":"QUEST_2_TITLE",
		"long_description":"QUEST_2_LONG_DESCRIPTION",
		"descriptions":
			["QUEST_2_DESCRIPTION0"],
		"mini_descriptions":
			["QUEST_2_MINI_DESCRIPTION0"],
		"pin_positions":[Vector2(0,0)],
		"stade":0,
		"finished":false,
		"members_only":false,
	},
	3: {
		"title":"QUEST_3_TITLE",
		"long_description":"QUEST_3_LONG_DESCRIPTION",
		"descriptions":
			["QUEST_3_DESCRIPTION0","QUEST_3_DESCRIPTION1","QUEST_3_DESCRIPTION2","QUEST3_DESCRIPTION3"],
		"mini_descriptions":
			["QUEST_3_MINI_DESCRIPTION0","QUEST_3_MINI_DESCRIPTION1","QUEST_3_MINI_DESCRIPTION2","QUEST_3_MINI_DESCRIPTION3"],
		"pin_positions":[Vector2(0,0),Vector2(0,0),Vector2(0,0),Vector2(0,0)],
		"stade":0,
		"finished":false,
		"members_only":true,
	}
}

func finished_stade_quest(quest_id=current_quest_id):
	if quest_id > -1:
		if quests[quest_id]["descriptions"].size() > quests[quest_id]["stade"]:
			quests[quest_id]["stade"] += 1
		else:
			quests[quest_id]["finished"] = true

func save():
	var save_file = ConfigFile.new()
	save_file.set_value("Tuto", "Stade", tutorial_stade)
	save_file.set_value("Tuto", "Type", tutorial)
	save_file.set_value("Tuto", "Validate", tutorial_validate)
	save_file.set_value("Tags", "Blue", pinb)
	save_file.set_value("Tags", "Red", pinr)
	save_file.set_value("Tags", "Yellow", piny)
	save_file.set_value("Tags", "Green", ping)
	
	save_file.set_value("Quests", "infos", quests)
	save_file.set_value("Quests", "current", current_quest_id)
	if get_node_or_null("/root/main_map/CanvasLayer/Minimap") != null:
		save_file.set_value("Quests", "radar_position", get_node("/root/main_map/CanvasLayer/Minimap").pin)
		save_file.set_value("Quests", "radar_enabled", true)
	else:
		save_file.set_value("Quests", "radar_position", Vector2(0, 0))
		save_file.set_value("Quests", "radar_enabled", false)

	# Sauvegarde des données du joueur
	save_file.set_value("Player", "pseudo", PlayerStats.pseudo)
	save_file.set_value("Player", "health", PlayerStats.health)
	save_file.set_value("Player", "skin", PlayerStats.skin)
	save_file.set_value("Player", "level", PlayerStats.level)
	save_file.set_value("Player", "monnaie", PlayerStats.monnaie)

	# Vérifier si le joueur est dans la scène actuelle avant de sauvegarder la position
	var player_node = get_node_or_null("/root/"+current_map+"/TileMap/Player_One")
	if player_node:
		save_file.set_value("Player", "position", player_node.position)
	else:
		print("Le joueur n'est pas disponible pour la sauvegarde de position.")

	# Sauvegarde de l'heure
	save_file.set_value("Time", "hour", current_hour)
	save_file.set_value("Time", "minute", current_minute)
	save_file.set_value("Time", "day", current_day)
	save_file.set_value("Time", "color", target_color)
	print(target_color)
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

	quests = load_file.get_value("Quests", "infos", quests)
	current_quest_id = load_file.get_value("Quests", "current", current_quest_id)
	if get_node_or_null("/root/main_map/CanvasLayer/Minimap") != null:
		get_node("/root/main_map/CanvasLayer/Minimap").pin = load_file.get_value("Quests", "radar_position", Vector2(0, 0))
	
	PlayerStats.pseudo = load_file.get_value("Player", "pseudo", PlayerStats.pseudo)
	PlayerStats.health = load_file.get_value("Player", "health", PlayerStats.health)
	PlayerStats.skin = load_file.get_value("Player", "ski3n", PlayerStats.skin)
	PlayerStats.level = load_file.get_value("Player", "level", PlayerStats.level)
	PlayerStats.monnaie = load_file.get_value("Player", "monnaie", PlayerStats.monnaie)

	# Application de la position sauvegardée
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
		player_node.position = load_file.get_value("Player", "position", Vector2(0, 0))
		print("Position joueur appliquée :", player_node.position)
	else:
		print("Erreur : Le joueur n'a pas été trouvé dans la scène.")
