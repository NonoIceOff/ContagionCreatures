extends Node
class_name CraftTableManager

var player_inventory = []

var acces = {
	"Potion": true,
	"Herboristerie": false,
	"Alchimie": true
}

var craft_list = {
	"Potion soin": {
		"ingredients": {
			"Herbe": 2,
			"Eau": 1
		},
		"mode": "ressource",
		"description": "Une potion magique qui restaure instantanément 50 points de vie.",
		"unlock": "Potion",
		"texture": "res://Textures/Items/Potion_verte.png",
		"price": 10,
		"type": "type",
		"coef": 1
	},
	"Bow": {
		"ingredients": {
			"Liane": 7,
			"Collier pierro": 1
		},
		"mode": "ressource",
		"description": "Un arc robuste fabriqué avec des lianes résistantes. Idéal pour les attaques à distance.",
		"unlock": "Alchimie",
		"texture": "res://Textures/Items/ARC.png",
		"price": 10,
		"type": "type",
		"coef": 1
	},
	"Potion défense": {
		"ingredients": {
			"Herbe": 1,
			"Eau": 2
		},
		"mode": "ressource",
		"description": "Une potion rare qui augmente votre défense temporairement de 20%.",
		"unlock": "Potion",
		"texture": "res://Textures/Items/Gemme_bleu.png",
		"price": 10,
		"type": "type",
		"coef": 1
	},
	"Collier pierro": {
		"ingredients": {
			"Liane": 3,
			"Pierre": 1
		},
		"mode": "ressource",
		"description": "Un collier orné d'une pierre précieuse qui améliore votre concentration.",
		"unlock": "Alchimie",
		"texture": "res://Textures/Items/collierPierro.png",
		"price": 10,
		"type": "type",
		"coef": 1
	},
	"Herbe medicinale": {
		"ingredients": {
			"Herbe": 1,
			"Eau": 1,
			"Poussiere": 1,
			"Racine": 1
		},
		"mode": "ressource",
		"description": "Une herbe rare utilisée dans la préparation de potions puissantes.",
		"unlock": "Herboristerie",
		"texture": "res://Textures/Items/Apple.png",
		"price": 10,
		"type": "type",
		"coef": 1
	},
	"Kollier pierro": {
		"ingredients": {
			"Liane": 3,
			"Pierre": 1
		},
		"mode": "ressource",
		"description": "Un collier légèrement différent du modèle original, conférant une aura magique.",
		"unlock": "Alchimie",
		"texture": "res://Textures/Items/collierPierro.png",
		"price": 10,
		"type": "type",
		"coef": 1
	},
	"Qollier pierro": {
		"ingredients": {
			"Liane": 3,
			"Pierre": 1
		},
		"mode": "ressource",
		"description": "Un collier orné d’une pierre mystique augmentant l'intelligence du porteur.",
		"unlock": "Alchimie",
		"texture": "res://Textures/Items/collierPierro.png",
		"price": 10,
		"type": "type",
		"coef": 1
	},
	"Pollier pierro": {
		"ingredients": {
			"Liane": 3,
			"Pierre": 1
		},
		"mode": "ressource",
		"description": "Un bijou élégant qui amplifie les effets des potions consommées.",
		"unlock": "Alchimie",
		"texture": "res://Textures/Items/collierPierro.png",
		"price": 10,
		"type": "type",
		"coef": 1
	},
	"Mollier pierro": {
		"ingredients": {
			"Liane": 3,
			"Pierre": 1
		},
		"mode": "ressource",
		"description": "Un collier rare qui améliore la vitesse et l'agilité du porteur.",
		"unlock": "Alchimie",
		"texture": "res://Textures/Items/collierPierro.png",
		"price": 10,
		"type": "type",
		"coef": 1
	},
	"Zollier pierro": {
		"ingredients": {
			"Liane": 3,
			"Pierre": 1
		},
		"mode": "ressource",
		"description": "Un collier ancien capable d’absorber une partie des dégâts subis.",
		"unlock": "Alchimie",
		"texture": "res://Textures/Items/collierPierro.png",
		"price": 10,
		"type": "type",
		"coef": 1
	},
	"Tollier pierro": {
		"ingredients": {
			"Liane": 3,
			"Pierre": 1
		},
		"mode": "ressource",
		"description": "Un collier doté d'un enchantement de protection magique.",
		"unlock": "Alchimie",
		"texture": "res://Textures/Items/collierPierro.png",
		"price": 10,
		"type": "type",
		"coef": 1
	},
	"Jollier pierro": {
		"ingredients": {
			"Liane": 3,
			"Pierre": 1
		},
		"mode": "ressource",
		"description": "Un collier mystique dont l'origine est inconnue, imprégné d’une magie mystérieuse.",
		"unlock": "Alchimie",
		"texture": "res://Textures/Items/collierPierro.png",
		"price": 10,
		"type": "type",
		"coef": 1
	}
}


func _ready():
	load_player_inventory()

func can_craft(item_name: String) -> bool:
	if not craft_list.has(item_name):
		print(" Le craft '" + item_name + "' n'existe pas !")
		return false

	var craft = craft_list[item_name]
	var category = craft["unlock"]
	var ingredients = craft["ingredients"]

	if not acces[category]:
		print(" Vous n'avez pas débloqué la catégorie " + category)
		return false

	for ingredient in ingredients:
		var quantity_needed = ingredients[ingredient]
		# var found = false
		for item in player_inventory:
			print("Vérification de l'ingrédient: ", ingredient, " - Quantité nécessaire: ", quantity_needed, " - Quantité disponible: ", item["quantity"])
			if item["name"] == ingredient:
				# found = true
				if item["quantity"] >= quantity_needed:
					break
				else:
					print(" Manque de " + ingredient + " pour crafter " + item_name)
					return false
			else :
				print("Non correspondance de l'ingrédient: ", ingredient, " - Quantité nécessaire: ", quantity_needed, " - Quantité disponible: ", item["quantity"])
				return false
		# if not found:
		# 	print(" Manque de " + ingredient + " pour crafter " + item_name)
		# 	return false

	print(" Tous les ingrédients sont disponibles pour crafter " + item_name)
	return true

func craft_item(item_name: String) -> bool:
	if not can_craft(item_name):
		return false
		
	var ingredients = craft_list[item_name]["ingredients"]
	for ingredient in ingredients:
		var quantity_needed = ingredients[ingredient]
		for item in player_inventory:
			if item["name"] == ingredient:
				item["quantity"] -= quantity_needed
				break
	
	print(" Craft réussi : " + item_name)
	return true

func load_player_inventory():
	const ITEMS_FILE_PATH = "res://Constantes/items.json"
	
	if not FileAccess.file_exists(ITEMS_FILE_PATH):
		print(" Fichier d'inventaire introuvable")
		return
	
	var file = FileAccess.open(ITEMS_FILE_PATH, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var parse_result = JSON.parse_string(content)
		
		if parse_result is Array:
			player_inventory = parse_result
			print(" Inventaire chargé avec succès")
		else:
			print(" Erreur de parsing JSON")
	else:
		print(" Impossible d'ouvrir le fichier")

func save_player_inventory():
	const ITEMS_FILE_PATH = "res://Constantes/items.json"
	var file = FileAccess.open(ITEMS_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(player_inventory, "\t"))
		file.close()
		print(" Inventaire mis à jour dans items.json")
