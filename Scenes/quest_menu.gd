extends Control

var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in Global.quests.size():
		var panel = Panel.new()
		panel.name = "Panel"+str(i)
		panel.custom_minimum_size  = Vector2(832,128)
		
		var title = Label.new()
		title.text = Global.quests[i]["title"]
		title.name = "Title"
		title.scale = Vector2(3,3)
		title.position = Vector2(16,8)
		title.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		panel.add_child(title)
		
		
		
		var description = Label.new()
		description.name = "Description"
		description.text = Global.quests[i]["descriptions"][Global.quests[i]["stade"]]
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
		
		var titlet = Label.new()
		titlet.text = "QUEST_FINISHED"
		titlet.name = "Titlet"
		titlet.scale = Vector2(3,3)
		titlet.position = Vector2(232,0)
		titlet.rotation = 0.25
		titlet.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		titlet.visible = false
		titlet.set("theme_override_colors/font_outline_color", Color(1,0.5,0))
		titlet.set("theme_override_constants/outline_size", 10)
		panel.add_child(titlet)
		
		
		
		get_node("ScrollContainer/VBoxContainer").add_child(panel)


func open():
	visible = true
	is_open = true
	

func close():
	visible = false
	is_open = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.current_quest_id > -1:
		get_node("ScrollContainer/VBoxContainer/Panel"+str(Global.current_quest_id)+"/Description").text = Global.quests[Global.current_quest_id]["descriptions"][Global.quests[Global.current_quest_id]["stade"]]
	if Input.is_action_just_pressed("q"):
		if is_open:
			close()
		else:
			open()
			Tutorial.get_node(".").tutorials[6]["progress"] += 100
	
	for i in Global.quests.size():
		
		if i != Global.current_quest_id:
			get_node("ScrollContainer/VBoxContainer/Panel"+str(i)).self_modulate = Color(0,0,0)
		else:
			get_node("ScrollContainer/VBoxContainer/Panel"+str(i)).self_modulate = Color(1,1,0,1)
			
		if Global.quests[i]["finished"] == true:
			get_node("ScrollContainer/VBoxContainer/Panel"+str(i)).self_modulate = Color(0,0,0,0.5)
			get_node("ScrollContainer/VBoxContainer/Panel"+str(i)+"/Title").self_modulate = Color(0,0,0,0.5)
			get_node("ScrollContainer/VBoxContainer/Panel"+str(i)+"/Description").self_modulate = Color(0,0,0,0.5)
			get_node("ScrollContainer/VBoxContainer/Panel"+str(i)+"/Titlet").visible = true
			
		if get_node_or_null("ScrollContainer/VBoxContainer/Panel"+str(i)+"/Button") != null and Global.quests[i]["finished"] == false:
			if get_node_or_null("ScrollContainer/VBoxContainer/Panel"+str(i)+"/Button").button_pressed == true:
				Global.set_quest(i)
				get_node("AudioStreamPlayer").stream = load("res://Sounds/click.mp3")
				get_node("AudioStreamPlayer").playing = true
				get_node("QuestInfos/TitreQuete").text = Global.quests[i]["title"]
				get_node("QuestInfos/DescriptionQuete").text = tr(Global.quests[i]["long_description"])+"\n\n[color=orange][i]"+tr(Global.quests[i]["mini_descriptions"][Global.quests[i]["stade"]])+"[/i][/color]"
				#+"\n\n[color=orange][i]"+Global.quests[i]["mini_descriptions"][Global.quests[i]["stade"]]+"[/i][/color]"
				get_node("ScrollContainer/VBoxContainer/Panel"+str(i)).self_modulate = Color(1,1,0,1)
