extends Control

# --- Variables de configuration ---
var is_open = false
var colonnes = 6
const ITEMS_FILE_PATH = "res://Constantes/items.json"
const API_URL = "https://contagioncreaturesapi.vercel.app/api/items"

# --- Variables de données ---
var all_game_items = {}
var player_inventory_map = {}
var http_request: HTTPRequest

func _ready():
	# 1. Création dynamique du noeud HTTPRequest pour l'API
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_api_request_completed)
	
	# 2. Lancement du chargement
	load_all_game_items()
	
	# Masquer l'inventaire au départ
	close()

# --- CHARGEMENT API ---
func load_all_game_items():
	var error = http_request.request(API_URL)
	if error != OK:
		push_error("Erreur requête HTTP")

func _on_api_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var json = JSON.new()
		var parse_result = json.parse(body.get_string_from_utf8())
		if parse_result == OK:
			var data = json.get_data()
			if data is Array:
				all_game_items.clear()
				for item in data:
					all_game_items[int(item["id"])] = item
				# Une fois l'API chargée, on charge le joueur
				load_player_items_from_file()

# --- CHARGEMENT JOUEUR ---
func load_player_items_from_file():
	player_inventory_map.clear()
	
	if FileAccess.file_exists(ITEMS_FILE_PATH):
		var file = FileAccess.open(ITEMS_FILE_PATH, FileAccess.READ)
		var content = file.get_as_text()
		var json = JSON.new()
		if json.parse(content) == OK:
			var data = json.get_data()
			if data is Array:
				for item in data:
					# On essaye de récupérer l'ID
					var item_id = -1
					if item.has("id"):
						item_id = int(item["id"])
					elif item.has("name"):
						# Fallback sur le nom si pas d'ID
						for api_id in all_game_items:
							if all_game_items[api_id]["name"] == item["name"]:
								item_id = api_id
								break
					
					if item_id != -1:
						player_inventory_map[item_id] = int(item["quantity"])
	
	display_inventory()

# --- AFFICHAGE ---
func display_inventory():
	undraw_inventory() # On vide d'abord
	
	var sorted_ids = all_game_items.keys()
	sorted_ids.sort()
	
	var index_slot = 0
	
	for item_id in sorted_ids:
		var item_data = all_game_items[item_id]
		var quantity = 0
		var player_has_item = false
		
		if player_inventory_map.has(item_id):
			quantity = player_inventory_map[item_id]
			if quantity > 0:
				player_has_item = true

		create_slot_ui(index_slot, item_data, quantity, player_has_item)
		index_slot += 1

func create_slot_ui(index: int, item_data: Dictionary, quantity: int, is_owned: bool):
	# 1. Le conteneur de fond (ColorRect)
	var color = ColorRect.new()
	# Taille ajustée pour rentrer dans tes colonnes
	color.custom_minimum_size = Vector2(0, 160) # Largeur automatique, hauteur fixe
	color.size_flags_horizontal = SIZE_EXPAND_FILL # S'étire en largeur
	
	if is_owned:
		color.color = Color(0.15, 0.15, 0.2, 0.95)
	else:
		color.color = Color(0.1, 0.1, 0.1, 0.5)
		
	# --- IMPORTANT : C'est ici que le chemin change ---
	# On va chercher tes VBoxContainer existants dans le ScrollContainer
	var container_path = "CanvasLayer/ScrollContainer/HBoxContainer/VBoxContainer" + str(index % colonnes)
	if has_node(container_path):
		get_node(container_path).add_child(color)
	else:
		push_error("Container introuvable : " + container_path)
		return
	
	# 2. Le Sprite
	var sprite = Sprite2D.new()
	sprite.scale = Vector2(2.5, 2.5)
	sprite.position = Vector2(48, 80) # Centré verticalement (160/2)
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	var tex_path = "res://Textures/Items/" + item_data["texture"]
	if ResourceLoader.exists(tex_path):
		sprite.texture = load(tex_path)
	
	if not is_owned:
		sprite.modulate = Color(0.2, 0.2, 0.2, 1)
	else:
		sprite.modulate = Color(1, 1, 1, 1)
		
	color.add_child(sprite)
	
	# 3. Sprite "Non possédé" (Optionnel)
	if not is_owned and ResourceLoader.exists("res://Textures/WHATTT.png"):
		var sprite_no = Sprite2D.new()
		sprite_no.position = Vector2(200, 80)
		sprite_no.scale = Vector2(2.5, 2.5)
		sprite_no.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sprite_no.texture = load("res://Textures/WHATTT.png")
		color.add_child(sprite_no)
	
	# 4. Le Titre
	var title = Label.new()
	title.text = item_data["name"]
	title.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	title.set("theme_override_font_sizes/font_size", 46) # Un peu plus petit pour tenir
	
	if is_owned:
		title.set("theme_override_colors/font_color", Color(1, 1, 1, 1))
	else:
		title.set("theme_override_colors/font_color", Color(0.5, 0.5, 0.5, 1))
		
	title.set("theme_override_colors/font_outline_color", Color(0, 0, 0, 1))
	title.set("theme_override_constants/outline_size", 2)
	# Positionnement du titre
	title.layout_mode = 1 # Anchors preset
	title.anchors_preset = 15 # Full rect
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	color.add_child(title)
	
	# 5. La Quantité
	if is_owned:
		var quantity_lbl = Label.new()
		quantity_lbl.text = str(quantity)
		quantity_lbl.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		quantity_lbl.set("theme_override_font_sizes/font_size", 32)
		quantity_lbl.set("theme_override_colors/font_color", Color(1, 0.9, 0.3, 1))
		quantity_lbl.set("theme_override_colors/font_outline_color", Color(0, 0, 0, 1))
		quantity_lbl.set("theme_override_constants/outline_size", 3)
		
		# Positionnement en bas à droite
		quantity_lbl.layout_mode = 1
		quantity_lbl.anchors_preset = 3 # Bottom Right
		quantity_lbl.position = Vector2(-16, -8) # Petit offset du bord
		quantity_lbl.grow_horizontal = Control.GROW_DIRECTION_BEGIN
		quantity_lbl.grow_vertical = Control.GROW_DIRECTION_BEGIN
		
		color.add_child(quantity_lbl)

func undraw_inventory():
	# On parcourt les containers existants dans ta scène
	for j in colonnes:
		var path = "CanvasLayer/ScrollContainer/HBoxContainer/VBoxContainer" + str(j)
		if has_node(path):
			var container = get_node(path)
			for child in container.get_children():
				child.queue_free()

func open():
	if all_game_items.size() > 0:
		display_inventory()
	else:
		load_all_game_items()
	
	# On rend visible le CanvasLayer complet
	get_node("CanvasLayer").visible = true
	is_open = true

func close():
	get_node("CanvasLayer").visible = false
	is_open = false

func _process(_delta):
	# Si tu gères le input "i" ailleurs, laisse vide
	pass
