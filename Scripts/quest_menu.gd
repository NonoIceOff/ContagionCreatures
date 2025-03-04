extends Control

var is_open = false

func _ready():
	await get_tree().process_frame  # 🔹 Attendre que tout soit chargé
	var quest_container = get_node_or_null("ScrollContainer/VBoxContainer")

	if quest_container == null:
		print("❌ Erreur : 'ScrollContainer/VBoxContainer' introuvable !")
		return

	for i in Quests.quests.keys():
		if not Quests.quests.has(i):
			print("⚠️ Quête " + str(i) + " introuvable, ignorée.")
			continue

		var quest = Quests.quests[i]
		var panel = Panel.new()
		panel.name = "Panel" + str(i)
		panel.custom_minimum_size = Vector2(832, 128)

		var title = Label.new()
		title.text = quest.title
		title.name = "Title"
		title.position = Vector2(16, 0)
		title.add_theme_font_size_override("font_size", 64)
		title.autowrap_mode = TextServer.AUTOWRAP_OFF
		panel.add_child(title)

		var description = Label.new()
		description.name = "Description"
		description.text = quest.descriptions[quest.stade]
		description.custom_minimum_size = Vector2(800, 100)
		description.position = Vector2(32, 54)
		description.add_theme_font_size_override("font_size", 32)
		description.modulate = Color(1, 1, 0)
		description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		panel.add_child(description)

		var button = Button.new()
		button.name = "Button" + str(i)
		button.flat = true
		button.focus_mode = Control.FOCUS_NONE
		button.custom_minimum_size = Vector2(832, 128)
		button.pressed.connect(_on_quest_selected.bind(i))
		panel.add_child(button)

		var finished_label = Label.new()
		finished_label.text = "QUEST_FINISHED"
		finished_label.name = "FinishedLabel"
		finished_label.scale = Vector2(3, 3)
		finished_label.position = Vector2(232, 0)
		finished_label.rotation = 0.25
		finished_label.visible = quest.finished
		finished_label.set("theme_override_colors/font_outline_color", Color(1, 0.5, 0))
		finished_label.set("theme_override_constants/outline_size", 10)
		panel.add_child(finished_label)

		quest_container.add_child(panel)

func _on_quest_selected(quest_id):
	if Quests.quests.get(quest_id).finished == false:
		Quests.set_quest(quest_id)
		get_node("AudioStreamPlayer").stream = load("res://Sounds/click.mp3")
		get_node("AudioStreamPlayer").playing = true
		get_node("QuestInfos/TitreQuete").text = Quests.quests[quest_id]["title"]
		get_node("QuestInfos/DescriptionQuete").text = "[color=black]" + tr(Quests.quests[quest_id]["long_description"]) + "[/color]\n\n[color=orange][i][font_size=46]" + tr(Quests.quests[quest_id]["mini_descriptions"][Quests.quests[quest_id]["stade"]]) + "[/font_size][/i][/color]"

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false

func _process(delta):
	if Quests.current_quest_id > -1:
		get_node("ScrollContainer/VBoxContainer/Panel" + str(Quests.current_quest_id) + "/Description").text = Quests.quests[Quests.current_quest_id]["descriptions"][Quests.quests[Quests.current_quest_id]["stade"]]
	
	if Input.is_action_just_pressed("q"):
		if is_open:
			close()
		else:
			open()
			Tutorial.get_node(".").tutorials[6]["progress"] += 100
	
	for i in Quests.quests.keys():
		var panel = get_node_or_null("ScrollContainer/VBoxContainer/Panel" + str(i))
		if panel:
			if i != Quests.current_quest_id:
				panel.self_modulate = Color(0, 0, 0)
			else:
				panel.self_modulate = Color(1, 1, 0, 1)

			if Quests.quests[i]["finished"]:
				panel.self_modulate = Color(0, 0, 0, 0.5)
				panel.get_node("Title").self_modulate = Color(0, 0, 0, 0.5)
				panel.get_node("Description").self_modulate = Color(0, 0, 0, 0.5)
				panel.get_node("FinishedLabel").visible = true

			var button = panel.get_node_or_null("Button" + str(i))
			if button and not Quests.quests[i]["finished"] and button.button_pressed:
				Quests.set_quest(i)
				get_node("AudioStreamPlayer").stream = load("res://Sounds/click.mp3")
				get_node("AudioStreamPlayer").playing = true
				get_node("QuestInfos/TitreQuete").text = Quests.quests[i]["title"]
				get_node("QuestInfos/DescriptionQuete").text = "[color=black]" + tr(Quests.quests[i]["long_description"]) + "[/color]\n\n[color=orange][i][font_size=46]" + tr(Quests.quests[i]["mini_descriptions"][Quests.quests[i]["stade"]]) + "[/font_size][/i][/color]"
				panel.self_modulate = Color(1, 1, 0, 1)
