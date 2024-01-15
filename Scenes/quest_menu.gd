extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in Global.quests.size():
		var panel = Panel.new()
		panel.name = "Panel"+str(i)
		panel.custom_minimum_size  = Vector2(832,128)
		
		var title = Label.new()
		title.text = Global.quests[i]["title"]
		title.scale = Vector2(3,3)
		title.position = Vector2(16,8)
		title.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		panel.add_child(title)
		
		var description = Label.new()
		description.text = Global.quests[i]["description"]
		description.custom_minimum_size  = Vector2(800,100)
		description.scale = Vector2(1,1)
		description.position = Vector2(32,54)
		description.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		description.modulate = Color(1,1,0)
		description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		description.set("theme_override_fonts/font", load("res://Font/Inter-Medium.ttf"))
		description.set("theme_override_font_sizes/font_size", 24)
		description.set("theme_override_constants/line_spacing", -10)
		panel.add_child(description)
		
		var button = Button.new()
		button.name = "Button"
		button.flat = true
		button.focus_mode = Control.FOCUS_NONE
		button.custom_minimum_size  = Vector2(832,128)
		panel.add_child(button)
		
		
		
		get_node("ScrollContainer/VBoxContainer").add_child(panel)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in Global.quests.size():
		if get_node_or_null("ScrollContainer/VBoxContainer/Panel"+str(i)+"/Button") != null:
			if get_node_or_null("ScrollContainer/VBoxContainer/Panel"+str(i)+"/Button").button_pressed == true:
				get_node("QuestInfos/TitreQuete").text = Global.quests[i]["title"]
				get_node("QuestInfos/DescriptionQuete").text = Global.quests[i]["long_description"]
				if get_node_or_null("/root/main_map/CanvasLayer/Minimap") != null:
					get_node("/root/main_map/CanvasLayer/Minimap").pin = Global.quests[i]["pin_position"]
