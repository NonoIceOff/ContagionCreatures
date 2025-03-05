extends Control

@onready var http_request_get_item = $getItem
@onready var list_player_items = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/ResourcesContainer/ResourcesList
@onready var list_all_items = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/CraftsListContainer/CraftsList

# Récupère les items du player 
var player_items = []  
#Récupère les tout les items du jeu
var all_items = []

const API_ITEMS_URL = "https://contagioncreaturesapi.vercel.app/api/items"
const ITEMS_FILE_PATH = "res://Constantes/items.json"

@onready var craft_manager = CraftTableManager.new()

func _ready():
	http_request_get_item.request(API_ITEMS_URL)
	load_player_items()
	display_player_items()
	display_craft_options()

func _on_get_item_request_completed(response_code, body):
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var parse_result = JSON.parse_string(response_text)
		if parse_result:
			all_items = parse_result
			print("Items récupérés : ", all_items)
			for item in all_items:
				print("Item dispo")
				print(item["name"])
		else:
			print("Erreur : Réponse API invalide")
	else:
		print("Erreur HTTP : Code ", response_code)

func _process(_delta: float) -> void:
	pass

func load_player_items():
	if not FileAccess.file_exists(ITEMS_FILE_PATH):
		print(" Erreur : Fichier items.json introuvable !")
		return
	
	var file = FileAccess.open(ITEMS_FILE_PATH, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var parse_result = JSON.parse_string(content)
		
		if parse_result is Array:
			player_items = parse_result
			display_player_items()
			for item in player_items:
				print(" Nom: ", item["name"])
				print(" Description: ", item["description"])
				print(" Mode: ", item["mode"])
				print(" Texture: ", item["texture"])
		else:
			print(" Erreur : JSON invalide")
	else:
		print(" Impossible d'ouvrir le fichier !")
	return player_items

func display_craft_options():
	print(" Affichage des crafts disponibles :")
	for craft_name in craft_manager.craft_list.keys():
		print("- " + craft_name)

func attempt_craft(item_name: String):
	if craft_manager.craft_item(item_name):
		print(" " + item_name + " a été fabriqué !")
		save_player_inventory()
	else:
		print(" Impossible de fabriquer " + item_name)

func save_player_inventory():
	var file = FileAccess.open(ITEMS_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(player_items))
		file.close()
		
func display_player_items():
	list_player_items.clear()
	
	print("📜 Affichage des items du joueur :")
	
	for item in player_items:
		var texture: Texture
		if ResourceLoader.exists(item["texture"]):
			texture = load(item["texture"])
		else:
			print(" Texture introuvable pour :", item["name"])
			texture = null
		list_player_items.add_item(" x" + str(item["quantity"]), texture)
