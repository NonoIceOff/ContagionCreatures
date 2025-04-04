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
		"mode": "Consommable",
		"description": "Une potion magique qui restaure instantanément 50 points de vie.",
		"unlock": "Potion",
		"quest_unlock": "",
		"texture": "res://Textures/Items/Potion soin.png",
		"price": 10,
		"type": "type",
		"coef": 1
	},
	"Arc en bois": {
		"ingredients": {
			"Liane": 7,
			"Collier pierro": 1
		},
		"mode": "Arme",
		"description": "Un arc robuste fabriqué avec des lianes résistantes. Idéal pour les attaques à distance.",
		"unlock": "Alchimie",
		"quest_unlock": "",
		"texture": "res://Textures/Items/Arc en bois.png",
		"price": 10,
		"type": "type",
		"coef": 1
	},
	"Potion défense": {
		"ingredients": {
			"Herbe": 1,
			"Eau": 2
		},
		"mode": "Consommable",
		"quest_unlock": "",
		"description": "Une potion rare qui augmente votre défense temporairement de 20%.",
		"unlock": "Potion",
		"texture": "res://Textures/Items/Potion défense.png",
		"price": 10,
		"type": "type",
		"coef": 1
	},
	"Collier pierro": {
		"ingredients": {
			"Liane": 3,
			"Pierre": 1
		},
		"mode": "Ressource",
		"description": "Un collier orné d'une pierre précieuse qui améliore votre concentration.",
		"unlock": "Alchimie",
		"quest_unlock": "",
		"texture": "res://Textures/Items/Collier Pierro.png",
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
		"mode": "Consommable",
		"description": "Une herbe rare utilisée dans la préparation de potions puissantes.",
		"unlock": "Herboristerie",
		"quest_unlock": "",
		"texture": "res://Textures/Items/Herbe medicinale.png",
		"price": 10,
		"type": "type",
		"coef": 1
	},
	"Fireball": {
		"ingredients": {
			"Bois": 4,
			"Baton de bois": 15,
			"Eau": 8,
			"Herbe": 5
		},
		"mode": "Special",
		"description": "Une boule de feu qui inflige 50 points de dégâts à la cible.",
		"unlock": "Alchimie",
		"quest_unlock": "",
		"texture": "res://Textures/Items/Fireball.png",
		"price": 2500,
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
		for item in player_inventory:
			print("Vérification de l'ingrédient: ", ingredient, " - Quantité nécessaire: ", quantity_needed, " - Quantité disponible: ", item["quantity"])
			if item["name"] == ingredient:

				if item["quantity"] >= quantity_needed:
					break
				else:
					print(" Manque de " + ingredient + " pour crafter " + item_name)
					return false
			else :
				print("Non correspondance de l'ingrédient: ", ingredient, " - Quantité nécessaire: ", quantity_needed, " - Quantité disponible: ", item["quantity"])
				return false
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