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
@onready var exit_button = $CraftMenuScreen/NinePatchRect/ExitButton



@onready var weapon_filter_button_crafts = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/CraftsListContainer/FilterCraftHBoxContainer/WeaponButton
@onready var ressource_filter_button_crafts = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/CraftsListContainer/FilterCraftHBoxContainer/RessourceButton
@onready var item_farm_filter_button_crafts = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/CraftsListContainer/FilterCraftHBoxContainer/ItemFarmButton
@onready var concusible_filter_button_crafts = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/CraftsListContainer/FilterCraftHBoxContainer/Concusible_Button
@onready var special_item_filter_button_crafts = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/CraftsListContainer/FilterCraftHBoxContainer/SpecialItemButton
@onready var all_filter_button_crafts = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/CraftsListContainer/FilterCraftHBoxContainer/AllButton


@onready var weapon_filter_button_inventory = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/ResourcesContainer/FilterCraftHBoxContainer/WeaponButton
@onready var ressource_filter_button_inventory = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/ResourcesContainer/FilterCraftHBoxContainer/RessourceButton
@onready var item_farm_filter_button_inventory = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/ResourcesContainer/FilterCraftHBoxContainer/ItemFarmButton
@onready var concusible_filter_button_inventory = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/ResourcesContainer/FilterCraftHBoxContainer/Concusible_Button
@onready var special_item_filter_button_inventory = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/ResourcesContainer/FilterCraftHBoxContainer/SpecialItemButton
@onready var all_filter_button_inventory = $CraftMenuScreen/NinePatchRect/MarginContainer/MainContainer/ResourcesContainer/FilterCraftHBoxContainer/AllButton



var player_items = []  
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
	exit_button.connect("pressed", Callable(self, "_on_exit_button_pressed"))
	
	weapon_filter_button_crafts.connect("pressed", Callable(self, "_on_craft_filter_pressed").bind("Arme"))
	ressource_filter_button_crafts.connect("pressed", Callable(self, "_on_craft_filter_pressed").bind("Ressource"))
	item_farm_filter_button_crafts.connect("pressed", Callable(self, "_on_craft_filter_pressed").bind("ItemFarm"))
	concusible_filter_button_crafts.connect("pressed", Callable(self, "_on_craft_filter_pressed").bind("Consommable"))
	special_item_filter_button_crafts.connect("pressed", Callable(self, "_on_craft_filter_pressed").bind("Special"))
	all_filter_button_crafts.connect("pressed", Callable(self, "_on_craft_filter_pressed").bind("All"))

	weapon_filter_button_inventory.connect("pressed", Callable(self, "_on_inventory_filter_pressed").bind("Arme"))
	ressource_filter_button_inventory.connect("pressed", Callable(self, "_on_inventory_filter_pressed").bind("Ressource"))
	item_farm_filter_button_inventory.connect("pressed", Callable(self, "_on_inventory_filter_pressed").bind("ItemFarm"))
	concusible_filter_button_inventory.connect("pressed", Callable(self, "_on_inventory_filter_pressed").bind("Consommable"))
	special_item_filter_button_inventory.connect("pressed", Callable(self, "_on_inventory_filter_pressed").bind("Special"))
	all_filter_button_inventory.connect("pressed", Callable(self, "_on_inventory_filter_pressed").bind("All"))

	# Connexion des boutons de filtre pour les crafts #
	weapon_filter_button_crafts.connect("pressed", Callable(self, "_on_craft_filter_pressed").bind("Arme"))
	ressource_filter_button_crafts.connect("pressed", Callable(self, "_on_craft_filter_pressed").bind("Ressource"))
	item_farm_filter_button_crafts.connect("pressed", Callable(self, "_on_craft_filter_pressed").bind("ItemFarm"))
	concusible_filter_button_crafts.connect("pressed", Callable(self, "_on_craft_filter_pressed").bind("Consommable"))
	special_item_filter_button_crafts.connect("pressed", Callable(self, "_on_craft_filter_pressed").bind("Special"))
	all_filter_button_crafts.connect("pressed", Callable(self, "_on_craft_filter_pressed").bind("All"))

	# Connexion des boutons de filtre pour l'inventaire #
	weapon_filter_button_inventory.connect("pressed", Callable(self, "_on_inventory_filter_pressed").bind("Arme"))
	ressource_filter_button_inventory.connect("pressed", Callable(self, "_on_inventory_filter_pressed").bind("Ressource"))
	item_farm_filter_button_inventory.connect("pressed", Callable(self, "_on_inventory_filter_pressed").bind("ItemFarm"))
	concusible_filter_button_inventory.connect("pressed", Callable(self, "_on_inventory_filter_pressed").bind("Consommable"))
	special_item_filter_button_inventory.connect("pressed", Callable(self, "_on_inventory_filter_pressed").bind("Special"))
	all_filter_button_inventory.connect("pressed", Callable(self, "_on_inventory_filter_pressed").bind("All"))

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

func _on_exit_button_pressed() -> void:
	visible = false
	Engine.time_scale = 1
	Global.can_move = true
	
func _on_craft_filter_pressed(type: String) -> void:
	filter_crafts_by_type(type)

func _on_inventory_filter_pressed(type: String) -> void:
	filter_inventory_by_type(type)
	
func filter_crafts_by_type(type: String) -> void:
	list_all_items.clear()

	for craft_name in craft_manager.craft_list.keys():
		var craft = craft_manager.craft_list[craft_name]
		if type == "All" or craft["mode"] == type:
			var texture: Texture = null
			if ResourceLoader.exists(craft["texture"]):
				texture = load(craft["texture"])
			else:
				print("Texture introuvable pour :", craft_name)
			var item_id = list_all_items.add_item(craft_name, texture)
			list_all_items.set_item_disabled(item_id, not craft_manager.acces.get(craft["unlock"], false))

func filter_inventory_by_type(type: String) -> void:
	list_player_items.clear()

	for item in player_items:
		if type == "All" or item["mode"] == type:
			var texture: Texture = null
			if ResourceLoader.exists(item["texture"]):
				texture = load(item["texture"])
			else:
				print("Texture introuvable pour :", item["name"])
			list_player_items.add_item("x" + str(item["quantity"]), texture)

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
		list_player_items.add_item(" x" + str(int(item["quantity"])), texture)

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
	var can_craft = true

	for ressource in item_ressources:
		var quantity_needed = item_ressources[ressource]
		var quantity_available = 0
		var texture: Texture = null

		for item in player_items:
			if item["name"].to_lower() == ressource.to_lower():
				quantity_available = item["quantity"]
				if ResourceLoader.exists(item["texture"]):
					texture = ResourceLoader.load(item["texture"])
				break

		if texture == null:
			for item in all_items:
				if item["name"].to_lower() == ressource.to_lower():
					if ResourceLoader.exists(item["texture"]):
						texture = ResourceLoader.load(item["texture"])
					break

		if texture == null:
			var texture_path = "res://Textures/Items/" + ressource + ".png"
			if ResourceLoader.exists(texture_path):
				texture = ResourceLoader.load(texture_path)
			else:
				print("Erreur : Texture introuvable pour ", ressource, " avec le chemin ", texture_path)


		var ressource_text = ressource + " x" + str(quantity_needed)
		if quantity_available < quantity_needed:
			ressource_text += " (Manquant)"
			can_craft = false
			var item_id = craft_info_ressources_item_list.add_item(ressource_text, texture)
			craft_info_ressources_item_list.set_item_custom_bg_color(item_id, Color(1, 0, 0))
		else:
			var item_id = craft_info_ressources_item_list.add_item(ressource_text, texture)

	craft_button.disabled = not can_craft

func _on_get_item_name_request_completed(_result, response_code, _headers, body, item_id, ressource, quantity_needed):
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
					craft_info_ressources_item_list.set_item_icon(item_id, ressource_texture)
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
	var ingredients = craft_manager.craft_list[item_name]["ingredients"]
	for ingredient in ingredients:
		var quantity_needed = ingredients[ingredient]
		for item in player_items:
			if item["name"] == ingredient:
				item["quantity"] -= quantity_needed
				if item["quantity"] <= 0:
					player_items.erase(item)
				break
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
