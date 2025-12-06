extends Control

var is_open = false

func _ready():
	await get_tree().process_frame
	
	# Le nœud racine ignore la souris, mais pas les enfants interactifs
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# On autorise les clics sur les zones interactives
	if get_node_or_null("ScrollContainer"):
		get_node("ScrollContainer").mouse_filter = Control.MOUSE_FILTER_PASS
	if get_node_or_null("QuestInfos"):
		get_node("QuestInfos").mouse_filter = Control.MOUSE_FILTER_PASS
	
	var quest_container = get_node_or_null("ScrollContainer/VBoxContainer")
	if quest_container:
		quest_container.mouse_filter = Control.MOUSE_FILTER_PASS
		print("✅ VBoxContainer configuré")

	if quest_container == null:
		print("❌ Erreur : 'ScrollContainer/VBoxContainer' introuvable !")
		return

	for i in Quests.quests.keys():
		if not Quests.quests.has(i):
			print("⚠️ Quête " + str(i) + " introuvable, ignorée.")
			continue

		var quest = Quests.quests[i]
		var button = Button.new()
		button.name = "Panel" + str(i)
		button.custom_minimum_size = Vector2(832, 128)
		button.flat = false
		button.focus_mode = Control.FOCUS_NONE
		button.mouse_filter = Control.MOUSE_FILTER_PASS
		button.pressed.connect(_on_quest_selected.bind(i))
		
		var title = Label.new()
		title.text = str(quest["title"]).to_upper()
		title.name = "Title"
		title.position = Vector2(16, 0)
		title.add_theme_font_size_override("font_size", 64)
		title.autowrap_mode = TextServer.AUTOWRAP_OFF
		title.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(title)

		var description = Label.new()
		description.name = "Description"
		description.text = quest["descriptions"][quest["stade"]]
		description.custom_minimum_size = Vector2(800, 100)
		description.position = Vector2(32, 54)
		description.add_theme_font_size_override("font_size", 32)
		description.modulate = Color(1, 1, 0)
		description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		description.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(description)
		
		print("✅ Bouton créé pour quête " + str(i))

		var finished_label = Label.new()
		finished_label.text = "QUEST_FINISHED"
		finished_label.name = "FinishedLabel"
		finished_label.scale = Vector2(3, 3)
		finished_label.position = Vector2(232, 0)
		finished_label.rotation = 0.25
		finished_label.visible = quest["finished"]
		finished_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		finished_label.set("theme_override_colors/font_outline_color", Color(1, 0.5, 0))
		finished_label.set("theme_override_constants/outline_size", 10)
		button.add_child(finished_label)

		quest_container.add_child(button)

func _on_quest_selected(quest_id):
	print("Quête sélectionnée : " + str(quest_id))
	Quests.set_quest(quest_id)
	update_quest_display(quest_id)

func update_quest_display(quest_id):
	if not Quests.quests.has(quest_id):
		return
		
	var quest = Quests.quests[quest_id]
	var descriptions = quest["mini_descriptions"]
	var current_stade = quest["stade"]
	
	get_node("AudioStreamPlayer").stream = load("res://Sounds/click.mp3")
	get_node("AudioStreamPlayer").playing = true
	
	# Mise à jour du titre
	get_node("QuestInfos/TitreQuete").text = quest["title"]
	
	# Mise à jour de la description longue + description courante
	get_node("QuestInfos/DescriptionQuete").text = "[color=black]" + tr(quest["long_description"]) + "[/color]\n\n[color=orange][i][font_size=46]" + tr(quest["mini_descriptions"][current_stade]) + "[/font_size][/i][/color]"
	
	# Mise à jour de la barre de progression
	get_node("QuestInfos/ProgressBar").max_value = descriptions.size()
	get_node("QuestInfos/ProgressBar").value = current_stade
	
	# Mise à jour du status des étapes
	var quest_status_node = get_node("QuestInfos/QuestStatus")
	quest_status_node.text = ""
	
	for i in descriptions.size():
		quest_status_node.text += "\n"
		
		if i < current_stade:
			quest_status_node.text += "[color=gray]   ✔️   " + str(descriptions[i])
		elif i == current_stade:
			quest_status_node.text += "[color=lime]   🚧   " + str(descriptions[i])
		else:
			quest_status_node.text += "[color=black]   ❌   " + masquer_texte(str(descriptions[i]))

func masquer_texte(original_text: String) -> String:
	var length = original_text.length()
	
	var obscured_text = ""
	for i in length:
		obscured_text += text_to_contafont(original_text[i])  # Masque avec des blocs

	return obscured_text

func text_to_contafont(char):
	char = str(char).to_lower()
	return "[img=24x24]res://Textures/Font/contafont_"+str(char)+".png[/img]"
	
func open():
	visible = true
	is_open = true
	print("🔓 Menu des quêtes ouvert")

func close():
	visible = false
	is_open = false

func _process(delta):
	# Mise à jour de la description courte dans la liste
	if Quests.current_quest_id > -1:
		var panel = get_node_or_null("ScrollContainer/VBoxContainer/Panel" + str(Quests.current_quest_id))
		if panel:
			var desc_label = panel.get_node_or_null("Description")
			if desc_label and Quests.quests.has(Quests.current_quest_id):
				desc_label.text = Quests.quests[Quests.current_quest_id]["descriptions"][Quests.quests[Quests.current_quest_id]["stade"]]
	
	# La touche "q" est maintenant gérée dans ui.gd de manière centralisée
	
	# Mise à jour visuelle des boutons
	for i in Quests.quests.keys():
		var button = get_node_or_null("ScrollContainer/VBoxContainer/Panel" + str(i))
		if button:
			# Coloration selon sélection
			if i != Quests.current_quest_id:
				button.self_modulate = Color(0.5, 0.5, 0.5)
			else:
				button.self_modulate = Color(1, 1, 0, 1)

			# Affichage des quêtes terminées
			if Quests.quests[i]["finished"]:
				button.self_modulate = Color(0, 0, 0, 0.5)
				button.get_node("Title").self_modulate = Color(0, 0, 0, 0.5)
				button.get_node("Description").self_modulate = Color(0, 0, 0, 0.5)
				button.get_node("FinishedLabel").visible = true
