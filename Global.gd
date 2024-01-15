extends Node

var interact = false
var trigger = true

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

var quests = {
	0: {
		"title":"Parchemin perdu",
		"long_description":"Vous pénétrez dans la modeste demeure du vieux sage, un érudit respecté de tous dans le royaume. Sa longue barbe blanche et ses yeux sages vous fixent avec bienveillance alors qu'il vous confie une quête d'une importance capitale.
			\nAinsi, votre aventure débute. Vous partez à la recherche de ce parchemin, bravant des dangers inconnus, explorant des contrées reculées et affrontant des créatures mythiques. La destinée du royaume dépend de votre réussite. Que la chance accompagne vos pas, brave aventurier !",
		"description":"Allez voir le vieux, il vous demandera de chercher un parchemin sacre.",
		"pin_position":Vector2(1448,291)
	}
}
