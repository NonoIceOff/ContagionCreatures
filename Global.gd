extends Node

var interact = false
var trigger = true

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
}

var attacks = {
	1: {
		"name":"Arc",
		"value":11,
		"boost":0,
		"texture":"res://Textures/Items/ARC.png",
		"quantity":0
	},
	2: {
		"name":"Epee",
		"value":17,
		"boost":0,
		"texture":"res://Textures/Items/EPEE.png",
		"quantity":5
	},
	3: {
		"name":"Hache",
		"value":20,
		"boost":0,
		"texture":"res://Textures/Items/HACHE.png",
		"quantity":0
	},
	4: {
		"name":"Poele",
		"value":23,
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
		"description":"Allez voir le vieux, il vous demandera de chercher un parchemin sacre.",
		"pin_position":Vector2(1448,291)
	}
}

func save():
	var save_file = ConfigFile.new()
	
	save_file.set_value("Values", "items", items)
	save_file.set_value("Values", "attacks", attacks)
	save_file.set_value("Quests", "infos", quests)
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
	items = load_file.get_value("Quests", "infos", items)
	attacks = load_file.get_value("Values", "attacks", attacks)
	quests = load_file.get_value("Quests", "infos", quests)
	if get_node_or_null("/root/main_map/CanvasLayer/Minimap") != null:
		get_node("/root/main_map/CanvasLayer/Minimap").pin = load_file.get_value("Quests", "radar_position", get_node("/root/main_map/CanvasLayer/Minimap").pin)
		load_file.get_value("Quests", "radar_enabled", true)
	PlayerStats.pseudo = load_file.get_value("Player", "pseudo", PlayerStats.pseudo)
	PlayerStats.health = load_file.get_value("Player", "health", PlayerStats.health)
	PlayerStats.skin = load_file.get_value("Player", "skin", PlayerStats.skin)
	PlayerStats.level = load_file.get_value("Player", "level", PlayerStats.level)
	PlayerStats.monnaie = load_file.get_value("Player", "monnaie", PlayerStats.monnaie)
	get_node("/root/main_map/Player_One").position = load_file.get_value("Player", "position", get_node("/root/main_map/Player_One").position)
	PlayerStats.animal_id = load_file.get_value("Animals", "id_affected", PlayerStats.animal_id)
	PlayerStats.animal_health = load_file.get_value("Animals", "health", PlayerStats.animal_health)
	PlayerStats.animal_level = load_file.get_value("Animals", "level", PlayerStats.animal_level)


func load_position():
	var load_file = ConfigFile.new()
	load_file.load_encrypted_pass("user://save.txt", "gentle_duck")
	get_node("/root/main_map/Player_One").position = load_file.get_value("Player", "position", get_node("/root/main_map/Player_One").position)
