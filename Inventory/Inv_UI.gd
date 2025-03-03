extends Control

var is_open = false
var colonnes = 4

func draw_inventory():
	var size_items = Global.items.size()
	var attacks_items = Global.attacks.size()
		
	for i in 16:
		var color = ColorRect.new()
		color.color = Color(0.1,0.1,0.1)
		color.custom_minimum_size = Vector2(332,128)
		get_node("CanvasLayer/VBoxContainer"+str(i%colonnes)).add_child(color)
		
		var sprite = Sprite2D.new()
		sprite.scale = Vector2(2,2)
		sprite.position = Vector2(32,32)
		color.add_child(sprite)
		
		var sprite_no = Sprite2D.new()
		sprite_no.scale = Vector2(0.2,0.2)
		sprite_no.position = Vector2(164,100)
		sprite_no.scale = Vector2(2,2)
		sprite_no.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sprite_no.texture = load("res://Textures/WHATTT.png")
		sprite_no.visible = false
		color.add_child(sprite_no)
		
		var title = Label.new()
		title.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		title.set("theme_override_font_sizes/font_size", 64)
		title.custom_minimum_size = Vector2(332,64)
		title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		color.add_child(title)
		
		var desc = Label.new()
		desc.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		desc.set("theme_override_font_sizes/font_size", 32)
		desc.custom_minimum_size = Vector2(332,164)
		desc.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		color.add_child(desc)
		
		var quantity = Label.new()
		quantity.position.y = 32
		quantity.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		quantity.set("theme_override_font_sizes/font_size", 32)
		quantity.custom_minimum_size = Vector2(332,96)
		quantity.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		quantity.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		color.add_child(quantity)
		
		
		if Global.items.has(i+1):
			title.text = Global.items[i+1]["name"]
			desc.text = str(Global.items[i+1]["type"])
			quantity.text = str(Global.items[i+1]["quantity"])
			sprite.texture = load(Global.items[i+1]["texture"])
			if Global.items[i+1]["quantity"] == 0:
				sprite_no.visible = true
				color.modulate = Color(1,1,1,0.5)
		else:
			if Global.attacks.has(i+1-size_items):
				title.text = Global.attacks[i+1-size_items]["name"]
				quantity.text = str(Global.attacks[i+1-size_items]["quantity"])
				sprite.texture = load(Global.attacks[i+1-size_items]["texture"])
				if Global.attacks[i+1-size_items]["quantity"] == 0:
					sprite_no.visible = true
					color.modulate = Color(1,1,1,0.5)
			else:
				sprite_no.visible = true
				color.modulate = Color(1,1,1,0.2)
	
func undraw_inventory():
	for j in colonnes:
		for obj in get_node("CanvasLayer/VBoxContainer"+str(j)).get_children():
			obj.queue_free()

func _ready():
	close()
	
	for j in colonnes:
		var colonne = VBoxContainer.new()
		colonne.name = "VBoxContainer"+str(j)
		colonne.position.x = 256+j*364
		colonne.position.y = 256
		colonne.set("theme_override_constants/separation", 16)
		get_node("CanvasLayer").add_child(colonne)

func _process(delta):
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
	
