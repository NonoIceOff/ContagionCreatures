extends Node

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

var grid_size = 31
var step_delay = 0
var allow_loops = false
var letters_to_show = []
var show_labels = false

var tutorial = true
var tutorial_stade = 0
var tutorial_validate = false

var current_quest_id = -1

signal fringe_changed

func quest_finished(i):
	if get_node_or_null("/root/main_map/CanvasLayer/TerminatedQuest") != null:
		get_node("/root/main_map/AudioStreamPlayer2D").stream = load("res://Sounds/victory.mp3")
		get_node("/root/main_map/AudioStreamPlayer2D").playing = true
		get_node("/root/main_map/CanvasLayer/TerminatedQuest").visible = true
		get_node("/root/main_map/CanvasLayer/TerminatedQuest/Name").text = Global.quests[i]["title"]
		await get_tree().create_timer(5).timeout 
		get_node("/root/main_map/CanvasLayer/TerminatedQuest").visible = false

func set_quest(i):
	if i == -1:
		if get_node_or_null("/root/main_map/CanvasLayer/CPUParticles2D") != null:
			get_node("/root/main_map/CanvasLayer/CPUParticles2D").visible = false
	else:
		Global.current_quest_id = i
		if get_node_or_null("/root/main_map/CanvasLayer/Minimap") != null:
			if get_node_or_null("/root/main_map/CanvasLayer/CPUParticles2D") != null:
				get_node("/root/main_map/CanvasLayer/CPUParticles2D").visible = true
			
			get_node("/root/main_map/CanvasLayer/Minimap").change_pin(Global.quests[i]["pin_positions"][Global.quests[i]["stade"]])

func _ready():
	for key in animals_player:
		var animal_types = animals_player[0]["type"]
		var random_type_index = randi_range(0, animal_types.size() - 3)
		var random_type = animal_types[random_type_index]
		var type_animal = random_type
		print("Type choisi aléatoirement:", type_animal)

func _process(delta):
	if tutorial == false:
		tutorial_stade = -1

var animals_player = {
	
	0: {
		"name":"GentleDuck",
		"infected": false,
		"type":['Écho','Relique','Prisme','Essence','Totem'],
		"effets":[ 1.06 , " % ATK "], #+6% d'ATK et DEF pour le player si l'arme est du même type
		"textureP":"res://Textures/DonaldDuck.png"
	},
	1: {
		"name":"Deagle",
		"infected": false,
		"type":['Écho','Relique','Prisme','Essence','Totem'],
		"effets":[ 1.1 , " % DEF"], #+10% de DEF pour le player si l'arme est du même type
		"textureP":"res://Textures/Animals/EAGLE_.png",
	},
	2: {
		"name":"Froggy",
		"infected": false,
		"type":['Écho','Relique','Prisme','Essence','Totem'],
		"effets":[ 1.03 ,"% ATK"], #d'ATK pour le player si l'arme est du même type
		"textureP":"res://Textures/Animals/FROG.png",
	},
	3: {
		"name":"Leonard",
		"infected": false,
		"type":['Écho','Relique','Prisme','Essence','Totem'],
		"effets":[  1.2 , "pv"],  # +20 PV à chaque tours pour le player si l'arme est du même type
		"textureP":"res://Textures/Animals/DRAGON.png",
	},
}
var animals_enemy = {
	
	1: {
		"name":"GentleDuck",
		"infected": true,
		"type":['Écho','Relique','Prisme','Essence','Totem'],
		"effets":[ 1.06 , " % atk "], #+6% d'ATK et DEF pour le player si l'arme est du même type
		"textureE":"res://Textures/DonaldDuck.png",
	},
	2: {
		"name":"Deagle",
		"infected": true,
		"type":['Écho','Relique','Prisme','Essence','Totem'],
		"effets":[ 1.1, " % def"], #+10% de DEF pour le player si l'arme est du même type
		"textureE":"res://Textures/Animals/Eagle_infected.png",
	},
	3: {
		"name":"Froggy",
		"infected": true,
		"type":['Écho','Relique','Prisme','Essence','Totem'],
		"effets":[ 1.03 ,"% atk"], # +3% d'ATK pour le player si l'arme est du même type
		"textureE":"res://Textures/Animals/FROG.png",
	},
	4: {
		"name":"Leonard",
		"infected": true,
		"type":['Écho','Relique','Prisme','Essence','Totem'],
		"effets":[ 1.2, "regen"],  # +20 PV à chaque tours pour le player si l'arme est du même type
		"textureE":"res://Textures/Animals/DRAGON.png",
	},
}
var items = {
	1: {
		"name":"Antidote",
		"value":0,
		"type":["antidote"],
		"effets":"Possibilite de recuperer l'animal ennemi. A utiliser si l'ennemi est bas en PV",
		"texture":"res://Textures/Potion_verte.png",
		"quantity":0
	},
	2: {
		"name":"Gemme Bleue",
		"value":0,
		"type":["def",1.15],
		"effets":"15% de DEF",
		"texture":"res://Textures/Gemme_bleu.png",
		"quantity":0
	},
	3: {
		"name":"Crepe",
		"value":0,
		"type":["atk",1.1],
		"effets":"10% d'ATK",
		"texture":"res://Textures/Items/Crepes.png",
		"quantity":0
	},
	4: {
		"name":"Pomme",
		"value":0,
		"type":["regen",5],
		"effets":"5 PV",
		"texture":"res://Textures/Apple.png",
		"quantity":0
	},
	5: {
		"name":"N-KEY",
		"value":0,
		"type":["key",1],
		"effets":"Active une porte",
		"texture":"res://Textures/Items/nkey.png",
		"quantity":0
	},
	6: {
		"name":"Crampte",
		"value":0,
		"type":["atk",2],
		"effets":"200% d'ATK",
		"texture":"res://Textures/Items/crapte.png",
		"quantity":0
	},
}

var attacks = {
	1: {
		"name":"Arc",
		"value":11,
		"type":['Écho','Relique','Prisme','Essence','Totem'],
		"boost":0,
		"texture":"res://Textures/Items/ARC.png",
		"quantity":0
	},
	2: {
		"name":"Epee",
		"value":17,
		"type":['Écho','Relique','Prisme','Essence','Totem'],
		"boost":0,
		"texture":"res://Textures/Items/EPEE.png",
		"quantity":5
	},
	3: {
		"name":"Hache",
		"value":20,
		"type":['Écho','Relique','Prisme','Essence','Totem'],
		"boost":0,
		"texture":"res://Textures/Items/HACHE.png",
		"quantity":0
	},
	4: {
		"name":"Poele",
		"value":23,
		"type":['Écho','Relique','Prisme','Essence','Totem'],
		"boost":0,
		"texture":"res://Textures/Items/POELE.png",
		"quantity":0
	},
}

var quests = {
	0: {
		"title":"Parchemin perdu",
		"long_description":"Vous pénétrez dans la modeste demeure du vieux sage, un érudit respecté de tous dans le royaume. Sa longue barbe blanche et ses yeux sages vous fixent avec bienveillance alors qu'il vous confie une quête d'une importance capitale.
			\nAinsi, votre aventure débute. Vous partez à la recherche de ce parchemin, bravant des dangers inconnus, explorant des contrées reculées et affrontant des créatures mythiques. La destinée du royaume dépend de votre réussite. Que la chance accompagne vos pas, brave aventurier !",
		"descriptions":
			["Allez voir Hector, il vous demandera de chercher un parchemin sacre.",
			"Allez voir Loytan, il a quelque chose pour faire avancer cette dite tragédie...",
			"Allez voir Loytan, pour dire que vous avez réussi votre énigme",
			"Allez voir Hector, pour lui remettre ses cramptes"],
		"mini_descriptions":
			["Allez voir Hector","Allez voir Loytan","Allez parler a Layton","Rendez les cramptes a Hector"],
		"pin_positions":[Vector2(1448,291),Vector2(3128,-664),Vector2(3128,-664),Vector2(1448,291)],
		"stade":0,
		"finished":false,
	},
	1: {
		"title":"Bagird le rigolo",
		"long_description":"Vous devez aller voir Monsieur Bagird, il vous demandera d'écouter à sa parole, vous devrez répondre à cela.",
		"descriptions":
			["Allez voir Monsieur Bagird qui se trouve sur la place du village, il a une belle bito.",
			"Allez voir Monsieur Bagird et rigolez à sa blague.",
			"Allez voir Monsieur Bagird qui se trouve à côté du pont Richard, pour continuer sa conversation...",
			"Mosieur Bagird le rigolo vous a donné le N-KEY, mais vous devez trouver à quoi elle sert et où se trouve !"],
		"mini_descriptions":
			["Allez voir Bagird","Rigolez a la blague de Bagird","Allez rejoindre Bagird vers le pont Richard","Cherchez l'endroit d'utilisation du N-KEY"],
		"pin_positions":[Vector2(980,-680),Vector2(980,-680),Vector2(764,932),Vector2(-500,-740)],
		"stade":0,
		"finished":false,
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
	
	items = load_file.get_value("Values", "items", items)
	attacks = load_file.get_value("Values", "attacks", attacks)
	quests = load_file.get_value("Quests", "infos", quests)
	current_quest_id = load_file.get_value("Quests", "current", current_quest_id)
	if get_node_or_null("/root/main_map/CanvasLayer/Minimap") != null:
		get_node("/root/main_map/CanvasLayer/Minimap").pin = load_file.get_value("Quests", "radar_position", get_node("/root/main_map/CanvasLayer/Minimap").pin)
		load_file.get_value("Quests", "radar_enabled", true)
	PlayerStats.pseudo = load_file.get_value("Player", "pseudo", PlayerStats.pseudo)
	PlayerStats.health = load_file.get_value("Player", "health", PlayerStats.health)
	PlayerStats.skin = load_file.get_value("Player", "skin", PlayerStats.skin)
	PlayerStats.level = load_file.get_value("Player", "level", PlayerStats.level)
	PlayerStats.monnaie = load_file.get_value("Player", "monnaie", PlayerStats.monnaie)
	get_node("/root/main_map/Player_One").position = load_file.get_value("Player", "position", Vector2(0,0))
	PlayerStats.animal_id = load_file.get_value("Animals", "id_affected", PlayerStats.animal_id)
	PlayerStats.animal_health = load_file.get_value("Animals", "health", PlayerStats.animal_health)
	PlayerStats.animal_level = load_file.get_value("Animals", "level", PlayerStats.animal_level)


func load_position():
	var load_file = ConfigFile.new()
	load_file.load_encrypted_pass("user://save.txt", "gentle_duck")
	get_node("/root/main_map/Player_One").position = load_file.get_value("Player", "position", get_node("/root/main_map/Player_One").position)
