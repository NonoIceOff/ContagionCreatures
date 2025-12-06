extends CanvasLayer

@onready var dialogue_label : RichTextLabel = $Paper/Textes
@onready var choices_container : VBoxContainer = $ChoicesContainer

var dialogues : Array = []
var current_dialogue : int = 0
var is_choice_dialogue : bool = false
var current_choice : Dictionary = {}
var pnj_name = ""
var contafont_mode = false

var typing_speed : float = 0.03
var is_typing : bool = false

var camera = []

func _ready() -> void:
	camera = get_tree().get_nodes_in_group("camera")

func smooth_zoom(camera, zoom):
	var zoom_speed = 0.1
	var zoom_target = zoom
	var zoom_current = camera.zoom
	while zoom_current.distance_to(Vector2(zoom_target, zoom_target)) > 0.01:
		zoom_current = lerp(zoom_current, Vector2(zoom_target, zoom_target), zoom_speed)
		camera.zoom = zoom_current
		await get_tree().create_timer(0.01).timeout

func start_dialogue(dialogue_data: Array):
	Global.ui_visible = false
	var ui = get_node_or_null("/root/" + Global.current_map + "/ui")
	if ui:
		if ui.get_node_or_null("Minimap"):
			ui.get_node("Minimap").visible = false
		if ui.get_node_or_null("XPPanel"):
			ui.get_node("XPPanel").visible = false
		if ui.get_node_or_null("PanelDate"):
			ui.get_node("PanelDate").visible = false
		if ui.get_node_or_null("Stats"):
			ui.get_node("Stats").visible = false
		if ui.get_node_or_null("Informations"):
			ui.get_node("Informations").visible = false
		if ui.get_node_or_null("SpeedrunTimer"):
			ui.get_node("SpeedrunTimer").visible = false
		if ui.get_node_or_null("CPUParticles2D"):
			ui.get_node("CPUParticles2D").visible = false
	
	smooth_zoom(camera[0], 3)
	get_node("Label").text = str(pnj_name) if pnj_name != null else ""
	dialogues = dialogue_data
	current_dialogue = 0
	is_choice_dialogue = false
	show_next_dialogue()

func show_next_dialogue():
	var random_dialogue_next_sound = randi()%2+1
	MusicsPlayer.play_sound("res://Sounds/dialogue/dialogue_next"+str(random_dialogue_next_sound)+".mp3","Bus1",1.0,-10.0)
	if is_typing:
		return

	if current_dialogue < dialogues.size():
		var dialogue = dialogues[current_dialogue]
		current_dialogue += 1

		if typeof(dialogue) == TYPE_DICTIONARY and dialogue.has("choices"):
			is_choice_dialogue = true
			show_choices(dialogue["choices"])
		else:
			is_choice_dialogue = false
			var text_to_display = dialogue["text"] if typeof(dialogue) == TYPE_DICTIONARY else str(dialogue)
			type_text(text_to_display)

			if typeof(dialogue) == TYPE_DICTIONARY:
				if dialogue.has("action") and dialogue["action"] is String and has_method(dialogue["action"]):
					if dialogue.has("params"):
						callv(dialogue["action"], dialogue["params"])
					else:
						call(dialogue["action"])

	else:
		end_dialogue()

func type_text(full_text: String):
	is_typing = true
	dialogue_label.text = ""
	
	for i in range(full_text.length()):
		var add_text = full_text[i]
		if contafont_mode == true:
			add_text = str(text_to_contafont(add_text))
		dialogue_label.text += add_text
		await get_tree().create_timer(typing_speed).timeout
	
	is_typing = false

func text_to_contafont(char):
	char = str(char).to_lower()
	return "[img=52x52]res://Textures/Font/contafont_"+str(char)+".png[/img]"

func show_choices(choices: Array):
	dialogue_label.text = "Choisissez une option :"

	choices_container.visible = true
	clear_choices()

	for choice in choices:
		var button = Button.new()
		button.text = choice["text"]
		button.custom_minimum_size = Vector2(128, 32)
		button.add_theme_font_size_override("font_size", 48)
		var stylebox_theme: StyleBoxFlat = button.get_theme_stylebox("normal").duplicate()
		stylebox_theme.bg_color = Color("ffffd8")
		button.add_theme_stylebox_override("normal", stylebox_theme)

		button.pressed.connect(_on_choice_pressed.bind(choice))
		choices_container.add_child(button)

func clear_choices():
	for child in choices_container.get_children():
		child.queue_free()

func _on_choice_pressed(choice: Dictionary):
	choices_container.visible = false
	current_choice = choice
	type_text(choice["response"])

	if choice.has("action") and choice["action"] is String and has_method(choice["action"]):
		if choice.has("params"):
			callv(choice["action"], choice["params"])
		else:
			call(choice["action"])

func end_dialogue():
	MusicsPlayer.play_sound("res://Sounds/dialogue/dialogue_end.mp3","Bus1",1.0,-10.0)
	Global.ui_visible = true
	var ui = get_node_or_null("/root/" + Global.current_map + "/ui")
	if ui:
		if ui.get_node_or_null("Minimap"):
			ui.get_node("Minimap").visible = Global.is_minimap
		if ui.get_node_or_null("XPPanel"):
			ui.get_node("XPPanel").visible = true
		if ui.get_node_or_null("PanelDate"):
			ui.get_node("PanelDate").visible = true
		if ui.get_node_or_null("Stats"):
			ui.get_node("Stats").visible = true
		if ui.get_node_or_null("Informations"):
			ui.get_node("Informations").visible = (Global.tutorial_stade < 10)
		if ui.get_node_or_null("SpeedrunTimer"):
			ui.get_node("SpeedrunTimer").visible = Global.is_speedrun_timer
		if ui.get_node_or_null("CPUParticles2D") and Quests.current_quest_id > -1:
			ui.get_node("CPUParticles2D").visible = true
	
	smooth_zoom(camera[0], 1.8)
	choices_container.visible = false
	dialogue_label.text = "Fin du dialogue."

	visible = false
	await get_tree().create_timer(1).timeout
	
	if Quests.current_quest_id >= 0 and Quests.quests.has(Quests.current_quest_id):
		await Quests.advance_stade(Quests.current_quest_id)
	queue_free()

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		click_dialogue()
	var joypads = Input.get_connected_joypads()
	if joypads.size() >= 1:
		if Input.is_action_just_pressed(Controllers.a_input):
			click_dialogue()
		

func click_dialogue():
	if is_typing:
		var dialogue = dialogues[current_dialogue - 1]
		if typeof(dialogue) == TYPE_DICTIONARY:
			dialogue_label.text = dialogue["text"]
		else:
			dialogue_label.text = str(dialogue)
		is_typing = false
	elif current_choice != {}:
		current_choice = {}  
		show_next_dialogue()
	elif not is_choice_dialogue:
		show_next_dialogue()

var dialogue_data = []

func _on_yes_choice():
	pass

func _on_dialogue_end():
	pass

func _on_give_item(item):
	pass

func _on_unlock_craft(craft):
	pass

func _on_heal():
	PlayerStats.health = 100

func _on_give_monney(money):
	PlayerStats.money += money

func _on_watch_camera(position:Vector2, speed, duration):
	is_typing = true 
	Global.smooth_zoom(camera[0], 3, position, 0.1)
	await get_tree().create_timer(duration).timeout
	Global.smooth_zoom(camera[0], 1.8, Vector2(0,0), 0.1)
	is_typing = false 
	show_next_dialogue()

func _on_set_variable(variable_path: String, value):
	var parts = variable_path.split(".")
	if parts.size() != 2:
		push_error("Format incorrect. Utiliser 'Singleton.variable'")
		return
	
	var singleton_name = parts[0]
	var variable_name = parts[1]

	if has_node("/root/" + singleton_name):
		var singleton = get_node("/root/" + singleton_name)
		if singleton.has_method("set"):
			singleton.set(variable_name, value)
		else:
			push_error("Impossible de définir la propriété '%s' sur %s." % [variable_name, singleton_name])
	else:
		push_error("Le singleton '%s' n'existe pas." % singleton_name)


func _on_choose_creature(variable_path):
	var parts = int(variable_path)
	Global.tutorial_stade = 11
	Global.add_creature(Global.starters_id[parts-1])

func _on_launch_battle():
	_on_dialogue_end()
	Global.tutorial_stade = 12
	SceneLoader.load_scene("res://Scenes/Combat/scène_combat.tscn")

func _on_start_scene(variable_path):
	_on_dialogue_end()
	SceneLoader.load_scene(variable_path)
