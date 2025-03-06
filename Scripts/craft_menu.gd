extends Control

@onready var http_request_get_item = $getItem
@onready var list_player_items = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/ResourcesContainer/ResourcesList
@onready var list_all_items = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/CraftsListContainer/CraftsList
@onready var craft_info_label = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/CraftInfoContainer/PanelContainer/MarginContainer/CraftNamePreviewContainer/CraftInfoLabel
@onready var craft_info_texture_rect = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/CraftInfoContainer/PanelContainer/MarginContainer/CraftNamePreviewContainer/TextureRect
@onready var craft_info_description_label = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/CraftInfoContainer/PanelContainer/MarginContainer/CraftDescriptionContainer/ScrollContainer/CraftDescription
@onready var craft_info_ressources_item_list = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/CraftInfoContainer/PanelContainer/MarginContainer/CraftDescriptionContainer/ResourcesNeededItemList
@onready var craftLineEdit = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/CraftsListContainer/CraftLineEdit
@onready var craft_button = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/CraftInfoContainer/PanelContainer/MarginContainer/CraftButtonContainer/CraftButton

# Récupère les items du player
var player_items = []  
# Récupère les tout les items du jeu
var all_items = []

const API_ITEMS_URL = "https://contagioncreaturesapi.vercel.app/api/items"
const ITEMS_FILE_PATH = "res://Constantes/items.json"

@onready var craft_manager = CraftTableManager.new()
var selected_item_name = ""

func _ready():
	http_request_get_item.request(API_ITEMS_URL)
	load_player_items()
	display_player_items()
	display_all_items()
	connect("item_selected", Callable(self, "_on_item_selected"))
	craft_button.connect("pressed", Callable(self, "_on_craft_button_pressed"))

func _on_get_item_request_completed(response_code, body):
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var parse_result = JSON.parse_string(response_text)
		if parse_result:
			all_items = parse_result

			for item in all_items:
				pass
			
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
				pass

		else:
			print(" Erreur : JSON invalide")
	else:
		print(" Impossible d'ouvrir le fichier !")
	return player_items

func attempt_craft(item_name: String):
	if craft_manager.craft_item(item_name):
		print(" " + item_name + " a été fabriqué !")
		save_player_inventory()
	else:
		print(" Impossible de fabriquer " + item_name)

func save_player_inventory():
	var file = FileAccess.open(ITEMS_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(player_items, "\t"))
		file.close()
		
func display_player_items():
	list_player_items.clear()
	
	for item in player_items:
		var texture: Texture
		if ResourceLoader.exists(item["texture"]):
			texture = load(item["texture"])
		else:
			print(" Texture introuvable pour :", item["name"])
			texture = null
		list_player_items.add_item(" x" + str(item["quantity"]), texture)

func display_all_items():
	list_all_items.clear()

	for craft_name in craft_manager.craft_list.keys():
		var craft = craft_manager.craft_list[craft_name]
		var category = craft["unlock"]
		var is_unlocked = craft_manager.acces.get(category, false)
		var texture: Texture

		if ResourceLoader.exists(craft["texture"]):
			texture = load(craft["texture"])
		else:
			print(" Texture introuvable pour :", craft_name)
			texture = null

		
		var item_id = list_all_items.add_item(craft_name, texture)

		list_all_items.set_item_disabled(item_id, not is_unlocked)

func _on_item_selected(index: int) -> void:
	selected_item_name = list_all_items.get_item_text(index)
	var item_icon = list_all_items.get_item_icon(index)
	var item_ressources = craft_manager.craft_list[selected_item_name]["ingredients"]

	craft_info_label.text = selected_item_name
	craft_info_texture_rect.texture = item_icon
	craft_info_description_label.text = craft_manager.craft_list[selected_item_name]["description"]

	craft_info_ressources_item_list.clear()
	for ressource in item_ressources:
		var http_request = HTTPRequest.new()
		add_child(http_request)
		http_request.connect("request_completed", Callable(self, "_on_get_item_name_request_completed").bind(ressource, item_ressources[ressource]))
		http_request.request(API_ITEMS_URL)

func _on_get_item_name_request_completed(_result, response_code, _headers, body, ressource, quantity):
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var parse_result = JSON.parse_string(response_text)
		if parse_result is Array:
			for item in parse_result:
				if item["name"] == ressource:
					var ressource_texture: Texture = null
					var texture_path = "res://Textures/Items/" + item["texture"]
					if ResourceLoader.exists(texture_path):
						ressource_texture = ResourceLoader.load(texture_path)
					else:
						print("Erreur : Texture introuvable pour ", ressource, " avec le chemin ", texture_path)
					craft_info_ressources_item_list.add_item(ressource + " x" + str(quantity), ressource_texture)
					return
			print("Erreur : Ressource non trouvée dans la réponse pour ", ressource)
		else:
			print("Erreur : Réponse API invalide pour la ressource ", ressource)
	else:
		print("Erreur HTTP : Code ", response_code, " pour la ressource ", ressource)

func _on_craft_button_pressed() -> void:
	if selected_item_name != "":
		if craft_manager.can_craft(selected_item_name):
			craft_manager.craft_item(selected_item_name)
			_update_inventory(selected_item_name)
			save_player_inventory()
			display_player_items()
			print("Item crafté avec succès : " + selected_item_name)
		else:
			print("Pas assez de ressources pour crafter : " + selected_item_name)
	else:
		print("Aucun item sélectionné pour le craft")

func _update_inventory(item_name: String):
	var item_found = false
	for item in player_items:
		if item["name"] == item_name:
			item["quantity"] += 1
			item_found = true
			break
	if not item_found:
		var new_id = player_items.size() + 1
		var new_item = {
			"id": new_id,
			"name": item_name,
			"mode": craft_manager.craft_list[item_name]["mode"],
			"description": craft_manager.craft_list[item_name]["description"],
			"texture": craft_manager.craft_list[item_name]["texture"],
			"coef": craft_manager.craft_list[item_name]["coef"],
			"type": craft_manager.craft_list[item_name]["type"],
			"quantity": 1
		}
		player_items.append(new_item)
