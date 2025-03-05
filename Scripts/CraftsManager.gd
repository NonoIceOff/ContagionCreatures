extends Node
class_name CraftTableManager

var player_inventory = []

var acces = {
	"Potion": false,
	"Herboristerie": true,
	"Alchimie": true
}

var craft_list = {
	"Potion soin": {
		"ingredients": {
			"Herbe": 2,
			"Eau": 1
		},
		"unlock": "Potion",
		"texture": "res://Textures/Items/Potion_verte.png"
	},
	"Potion défense": {
		"ingredients": {
			"Herbe": 1,
			"Eau": 2
		},
		"unlock": "Potion",
		"texture" : "res://Textures/Items/potion_defense.png"
	},
	"Collier pierro": {
		"ingredients": {
			"Liane": 3,
			"Pierre": 1
		},
		"unlock": "Alchimie",
		"texture" : "res://Textures/Items/necklace.png"
	},
	"Herbe medicinale": {
		"ingredients": {
			"Herbe": 1,
			"Eau": 1,
			"Poussiere": 1,
			"Racine ": 1
		},
		"unlock": "Herboristerie",
		"texture" : "res://Textures/Items/herbe_medicinale.png"
	}
}

func _ready():
	load_player_inventory()

func can_craft(item_name: String) -> bool:
	if not craft_list.has(item_name):
		print(" Le craft '" + item_name + "' n'existe pas !")
		return false

	var ingredients = craft_list[item_name]["ingredients"]

	for ingredient in ingredients:
		var quantity_needed = ingredients[ingredient]
		var found = false
		for item in player_inventory:
			if item["name"] == ingredient and item["quantity"] >= quantity_needed:
				found = true
				break
		if not found:
			print(" Manque de " + ingredient + " pour crafter " + item_name)
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

func save_player_inventory():
	const ITEMS_FILE_PATH = "res://Constantes/items.json"
	var file = FileAccess.open(ITEMS_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(player_inventory, "\t"))
		file.close()
		print(" Inventaire mis à jour dans items.json")
