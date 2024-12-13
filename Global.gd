extends Node

var user = {}

var interact = false
var trigger = true
var is_infected = true
var can_desinfected = false
var canUse_antidote = true
var type_id = 0
var type_animal = 1
var brazero_numbers = 0
var paused = false
var can_move = true

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

var pianos = [0,0,0,0]
var current_map = "main_map"

var start_cinematic = {
	0: "START_CINEMATIC_TEXT_0",
	1: "START_CINEMATIC_TEXT_1",
	2: "START_CINEMATIC_TEXT_2",
	3: "START_CINEMATIC_TEXT_3",
	4: "START_CINEMATIC_TEXT_4",
	5: "START_CINEMATIC_TEXT_5",
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
		
		
var all_type = {
	
	0: {
		"name": "Echo"
	},
	1: {
		"name": "Relique"
	},
	2: {
		"name": "Prisme"
	},
	3: {
		"name": "Essence"
	},
	4: {
		"name": "Totem"
	},
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

var all_enemys = {
	
	0 : {
		"name":"Manteau Rouge"
		
	}
}

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
	
	save_file.set_value("Values", "items", items)
	save_file.set_value("Values", "attacks", attacks)
	save_file.set_value("Quests", "infos", quests)
	save_file.set_value("Quests", "current", current_quest_id)
	if get_node_or_null("/root/main_map/CanvasLayer/Minimap") != null:
		save_file.set_value("Quests", "radar_position", get_node("/root/main_map/CanvasLayer/Minimap").pin)
		save_file.set_value("Quests", "radar_enabled", true)
	else:
		save_file.set_value("Quests", "radar_position", Vector2(0,0))
		save_file.set_value("Quests", "radar_enabled", false)
	save_file.set_value("Player", "pseudo", PlayerStats.pseudo)
	save_file.set_value("Player", "health", PlayerStats.health)
	save_file.set_value("Player", "skin", PlayerStats.skin)
	save_file.set_value("Player", "level", PlayerStats.level)
	save_file.set_value("Player", "monnaie", PlayerStats.monnaie)
	if get_node_or_null("/root/main_map/Player_One") != null:
		save_file.set_value("Player", "position", get_node("/root/main_map/Player_One").position)
	else:
		var load_file = ConfigFile.new()
		load_file.load_encrypted_pass("user://save.txt", "gentle_duck")
		save_file.set_value("Player", "position", load_file.get_value("Player", "position"))
	save_file.set_value("Animals", "id_affected", PlayerStats.animal_id)
	save_file.set_value("Animals", "health", PlayerStats.animal_health)
	save_file.set_value("Animals", "level", PlayerStats.animal_level)

	save_file.save_encrypted_pass("user://save.txt", "gentle_duck")
	
func load():
	var load_file = ConfigFile.new()
	load_file.load_encrypted_pass("user://save.txt", "gentle_duck")


	tutorial_stade = load_file.get_value("Tuto", "Stade", tutorial_stade)
	tutorial = load_file.get_value("Tuto", "Type", tutorial)
	tutorial_validate = load_file.get_value("Tuto", "Validate", tutorial_validate)
	
	pinb = load_file.get_value("Tags", "Blue", pinb)
	pinr = load_file.get_value("Tags", "Red", pinr)
	piny = load_file.get_value("Tags", "Yellow", piny)
	ping = load_file.get_value("Tags", "Green", ping)
	
	items = load_file.get_value("Values", "items", items)
	attacks = load_file.get_value("Values", "attacks", attacks)
	quests = load_file.get_value("Quests", "infos", quests)
	current_quest_id = load_file.get_value("Quests", "current", current_quest_id)
	if get_node_or_null("/root/main_map/CanvasLayer/Minimap") != null:
		get_node("/root/main_map/CanvasLayer/Minimap").pin = load_file.get_value("Quests", "radar_position", get_node("/root/main_map/CanvasLayer/Minimap").pin)
		load_file.get_value("Quests", "radar_enabled", true)
	PlayerStats.pseudo = load_file.get_value("Player", "pseudo", PlayerStats.pseudo)
	PlayerStats.health = load_file.get_value("Player", "health", PlayerStats.health)
	PlayerStats.skin = load_file.get_value("Player", "ski3n", PlayerStats.skin)
	PlayerStats.level = load_file.get_value("Player", "level", PlayerStats.level)
	PlayerStats.monnaie = load_file.get_value("Player", "monnaie", PlayerStats.monnaie)
	get_node("/root/main_map/Player_One").position = load_file.get_value("Player", "position", Vector2(0,0))
	PlayerStats.animal_id = load_file.get_value("Animals", "id_affected", PlayerStats.animal_id)
	PlayerStats.animal_health = load_file.get_value("Animals", "health", PlayerStats.animal_health)
	PlayerStats.animal_level = load_file.get_value("Animals", "level", PlayerStats.animal_level)

func load_localisation():
	var load_file = ConfigFile.new()
	load_file.load_encrypted_pass("user://languages.txt", "gentle_duck")
	TranslationServer.set_locale(load_file.get_value("Languages","Current",TranslationServer.get_locale()))
	

func save_localisation():
	var save_file = ConfigFile.new()
	save_file.set_value("Languages","Current",TranslationServer.get_locale())
	save_file.save_encrypted_pass("user://languages.txt", "gentle_duck")
	
func load_user():
	var load_file = ConfigFile.new()
	load_file.load_encrypted_pass("user://user.txt", "user_key")
	Global.user = load_file.get_value("User","Data",Global.user)
	
func save_user():
	var save_file = ConfigFile.new()
	save_file.set_value("User","Data",Global.user)
	save_file.save_encrypted_pass("user://user.txt", "user_key")
	
func load_position():
	var load_file = ConfigFile.new()
	load_file.load_encrypted_pass("user://save.txt", "gentle_duck")
	get_node("/root/main_map/Player_One").position = load_file.get_value("Player", "position", get_node("/root/main_map/Player_One").position)
