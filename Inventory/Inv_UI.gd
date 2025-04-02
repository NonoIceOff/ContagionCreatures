extends Control

var is_open = false
var colonnes = 4
var player_items = []  # Liste pour stocker les données des items du joueur
const ITEMS_FILE_PATH = "res://Constantes/items.json"

func load_player_items():
	if not FileAccess.file_exists(ITEMS_FILE_PATH):
		print("Erreur : Fichier items.json introuvable !")
		return
	
	var file = FileAccess.open(ITEMS_FILE_PATH, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var parse_result = JSON.parse_string(content)
		
		if parse_result is Array:
			player_items = parse_result
		else:
			print("Erreur : JSON invalide")
	else:
		print("Impossible d'ouvrir le fichier !")

func display_player_items():
	load_player_items()  # Charger les données des items
	var total_slots = 16  # Nombre total de slots dans l'inventaire
	var size_items = player_items.size()
	
	for i in total_slots:
		var color = ColorRect.new()
		color.color = Color(0.1, 0.1, 0.1)
		color.custom_minimum_size = Vector2(332, 128)
		get_node("CanvasLayer/VBoxContainer" + str(i % colonnes)).add_child(color)
		
		var sprite = Sprite2D.new()
		sprite.scale = Vector2(2, 2)
		sprite.position = Vector2(32, 96)
		color.add_child(sprite)
		
		var sprite_no = Sprite2D.new()
		sprite_no.scale = Vector2(0.2, 0.2)
		sprite_no.position = Vector2(164, 100)
		sprite_no.scale = Vector2(2, 2)
		sprite_no.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sprite_no.texture = load("res://Textures/WHATTT.png")
		sprite_no.visible = false
		color.add_child(sprite_no)
		
		var title = Label.new()
		title.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		title.set("theme_override_font_sizes/font_size", 64)
		title.custom_minimum_size = Vector2(332, 64)
		title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		color.add_child(title)
		
		# var desc = Label.new()
		# desc.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		# desc.set("theme_override_font_sizes/font_size", 32)
		# desc.custom_minimum_size = Vector2(332, 164)
		# desc.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		# desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		# color.add_child(desc)
		
		var quantity = Label.new()
		quantity.position.y = 32
		quantity.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		quantity.set("theme_override_font_sizes/font_size", 32)
		quantity.custom_minimum_size = Vector2(332, 96)
		quantity.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		quantity.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		color.add_child(quantity)
		
		# Remplir les données des items
		if i < size_items:
			var item = player_items[i]
			title.text = item["name"]
			#desc.text = item["description"]
			quantity.text = str(item["quantity"])
			sprite.texture = load(item["texture"])
			if item["quantity"] == 0:
				sprite_no.visible = true
				color.modulate = Color(1, 1, 1, 0.5)
		else:
			# Cases vides
			sprite_no.visible = true
			color.modulate = Color(1, 1, 1, 0.2)

func draw_inventory():
	undraw_inventory()  # Nettoyer l'inventaire existant
	display_player_items()  # Afficher les items du joueur

func undraw_inventory():
	for j in colonnes:
		for obj in get_node("CanvasLayer/VBoxContainer" + str(j)).get_children():
			obj.queue_free()

func _ready():
	close()
	
	for j in colonnes:
		var colonne = VBoxContainer.new()
		colonne.name = "VBoxContainer" + str(j)
		colonne.position.x = 256 + j * 364
		colonne.position.y = 256
		colonne.set("theme_override_constants/separation", 16)
		get_node("CanvasLayer").add_child(colonne)

func _process(_delta):
	if Input.is_action_just_pressed("i"):
		if is_open:
			close()
			undraw_inventory()
		else:
			open()
			draw_inventory()

func open():
	get_node("CanvasLayer").visible = true
	is_open = true

func close():
	get_node("CanvasLayer").visible = false
	is_open = false
