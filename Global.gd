extends Node

var interact = false
var trigger = true
var is_infected = true
var can_desinfected = false
var canUse_antidote = true

var animals_player = {
	
	1: {
		"name":"GentleDuck",
		"infected": false,
		"type":"[Écho,Relique,Prisme,Essence,Totem]",
		"effets":"+6% d'ATK et DEF pour le player si l'arme est du même type",
		"texture":"res://Textures/DonaldDuck.png"
	},
	2: {
		"name":"Deagle",
		"infected": false,
		"type":"[Écho,Relique,Prisme,Essence,Totem]",
		"effets":"+10% de DEF pour le player si l'arme est du même type",
		"texture":"res://Textures/Animals/EAGLE_.png"
	},
	3: {
		"name":"Froggy",
		"infected": false,
		"type":"[Écho,Relique,Prisme,Essence,Totem]",
		"effets":"+3% d'ATK pour le player si l'arme est du même type",
		"texture":"res://Textures/Animals/FROG.png"
	},
	4: {
		"name":"Leonard",
		"infected": false,
		"type":"[Écho,Relique,Prisme,Essence,Totem]",
		"effets":"+20 pv à chaque tours pour le player si l'arme est du même type",
		"texture":"res://Textures/Animals/DRAGON.png"
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
		"boost":0,
		"texture":"res://Textures/Items/ARC.png"
	},
	2: {
		"name":"Epee",
		"value":17,
		"boost":0,
		"texture":"res://Textures/Items/EPEE.png"
	},
	3: {
		"name":"Hache",
		"value":20,
		"boost":0,
		"texture":"res://Textures/Items/HACHE.png"
	},
	4: {
		"name":"Poele",
		"value":23,
		"boost":0,
		"texture":"res://Textures/Items/POELE.png"
	},
}
