extends Control

var is_open = false
var colonnes = 4
var player_items = []
const ITEMS_FILE_PATH = "res://Constantes/items.json"
var items_loaded = false
var item_slots = []

func load_player_items():
	if items_loaded:
		return
		
	if not FileAccess.file_exists(ITEMS_FILE_PATH):
		push_error("Erreur : Fichier items.json introuvable !")
		return
	
	var file = FileAccess.open(ITEMS_FILE_PATH, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		var parse_result = JSON.parse_string(content)
		
		if parse_result is Array:
			player_items = parse_result
			items_loaded = true
		else:
			push_error("Erreur : JSON invalide")
	else:
		push_error("Impossible d'ouvrir le fichier !")

func display_player_items():
	load_player_items()
	var total_slots = 16
	var size_items = player_items.size()
	
	for i in total_slots:
		var color = ColorRect.new()
		color.color = Color(0.15, 0.15, 0.2, 0.95)
		color.custom_minimum_size = Vector2(384, 160)
		get_node("CanvasLayer/ScrollContainer/HBoxContainer/VBoxContainer" + str(i % colonnes)).add_child(color)
		
		var sprite = Sprite2D.new()
		sprite.scale = Vector2(2.5, 2.5)
		sprite.position = Vector2(48, 112)
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		color.add_child(sprite)
		
		var sprite_no = Sprite2D.new()
		sprite_no.position = Vector2(192, 112)
		sprite_no.scale = Vector2(2.5, 2.5)
		sprite_no.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sprite_no.texture = load("res://Textures/WHATTT.png")
		sprite_no.visible = false
		color.add_child(sprite_no)
		
		var title = Label.new()
		title.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		title.set("theme_override_font_sizes/font_size", 32)
		title.set("theme_override_colors/font_color", Color(1, 1, 1, 1))
		title.set("theme_override_colors/font_outline_color", Color(0, 0, 0, 1))
		title.set("theme_override_constants/outline_size", 2)
		title.custom_minimum_size = Vector2(384, 48)
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
		quantity.position = Vector2(8, 48)
		quantity.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		quantity.set("theme_override_font_sizes/font_size", 40)
		quantity.set("theme_override_colors/font_color", Color(1, 0.9, 0.3, 1))
		quantity.set("theme_override_colors/font_outline_color", Color(0, 0, 0, 1))
		quantity.set("theme_override_constants/outline_size", 3)
		quantity.custom_minimum_size = Vector2(368, 112)
		quantity.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		quantity.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		color.add_child(quantity)
		
		if i < size_items:
			var item = player_items[i]
			title.text = item["name"]
			quantity.text = str(int(item["quantity"]))
			sprite.texture = load(item["texture"])
			if item["quantity"] == 0:
				sprite_no.visible = true
				color.modulate = Color(1, 1, 1, 0.5)
		else:
			sprite_no.visible = true
			color.modulate = Color(1, 1, 1, 0.2)

func draw_inventory():
	undraw_inventory()
	display_player_items()

func undraw_inventory():
	for j in colonnes:
		var container = get_node("CanvasLayer/VBoxContainer" + str(j))
		for obj in container.get_children():
			obj.queue_free()

func _ready():
	load_player_items()
	close()
	
	for j in colonnes:
		var colonne = VBoxContainer.new()
		colonne.name = "VBoxContainer" + str(j)
		colonne.position.x = 256 + j * 364
		colonne.position.y = 256
		colonne.set("theme_override_constants/separation", 16)
		get_node("CanvasLayer").add_child(colonne)

func _process(_delta):
	# La touche "i" est maintenant gérée dans ui.gd de manière centralisée
	pass

func open():
	get_node("CanvasLayer").visible = true
	is_open = true

func close():
	get_node("CanvasLayer").visible = false
	is_open = false
