extends Label

func _process(delta: float) -> void:
	var joypads = Input.get_connected_joypads()

	if joypads.size() < 1:
		get_node("Pause").texture = load("res://Textures/Buttons/keyboard/keyboard_esc.png")
		get_node("Quest").texture = load("res://Textures/Buttons/keyboard/keyboard_tab.png")
		get_node("Inventory").texture = load("res://Textures/Buttons/keyboard/keyboard_i.png")
		get_node("Carte").texture = load("res://Textures/Buttons/keyboard/keyboard_m.png")
		text = "[TAB] Quêtes
			[ESP] Pause
			[I] Inventaire
			[M] Carte"
	else:
		get_node("Pause").texture = load("res://Textures/Buttons/joypads/joybar_+.png")
		get_node("Quest").texture = load("res://Textures/Buttons/joypads/joybar_r.png")
		get_node("Inventory").texture = load("res://Textures/Buttons/joypads/joybar_l.png")
		get_node("Carte").texture = load("res://Textures/Buttons/joypads/joybar_-.png")
		text = "Quêtes
			Pause
			Inventaire
			Carte"
