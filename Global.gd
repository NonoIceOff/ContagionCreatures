extends Node

var interact = false
var trigger = true
var is_infected = true
var can_desinfected = false
var canUse_antidote = true
var type_id = 0


func _ready():
	type_id = randi_range(0,5)


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
		"texture":"res://Textures/Potion_verte.png"
	},
	2: {
		"name":"Gemme Bleue",
		"value":0,
		"type":["def",1.15],
		"effets":"15% de DEF",
		"texture":"res://Textures/Gemme_bleu.png"
	},
	3: {
		"name":"Crepe",
		"value":0,
		"type":["atk",1.1],
		"effets":"10% d'ATK",
		"texture":"res://Textures/Items/Crepes.png"
	},
	4: {
		"name":"Pomme",
		"value":0,
		"type":["regen",5],
		"effets":"5 PV",
		"texture":"res://Textures/Apple.png"
	},
}

var attacks = {
	1: {
		"name":"Arc",
		"value":11,
		"type":['Écho','Relique','Prisme','Essence','Totem'],
		"boost":0,
		"texture":"res://Textures/Items/ARC.png"
	},
	2: {
		"name":"Epee",
		"value":17,
		"type":['Écho','Relique','Prisme','Essence','Totem'],
		"boost":0,
		"texture":"res://Textures/Items/EPEE.png"
	},
	3: {
		"name":"Hache",
		"value":20,
		"type":['Écho','Relique','Prisme','Essence','Totem'],
		"boost":0,
		"texture":"res://Textures/Items/HACHE.png"
	},
	4: {
		"name":"Poele",
		"value":23,
		"type":['Écho','Relique','Prisme','Essence','Totem'],
		"boost":0,
		"texture":"res://Textures/Items/POELE.png"
	},
}
