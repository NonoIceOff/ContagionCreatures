extends Control

var creatures = []
var click_count := 0

func _load_creatures_data():
	var file = FileAccess.open("res://Constantes/creatures.json", FileAccess.READ)
	if file:
		var json_data = JSON.parse_string(file.get_as_text())
		if json_data is Array:
			creatures = json_data
		else:
			print("Erreur : données JSON invalides.")
	else:
		print("Erreur : impossible d'ouvrir le fichier JSON.")

func _ready() -> void:
	_load_creatures_data()
	for i in creatures.size():
		var creature = creatures[i]
		print(creature)

		var MobChoiceContainer = Panel.new()
		MobChoiceContainer.name = "MobChoiceContainer"+str(int(creature["id"]))
		MobChoiceContainer.position = Vector2(64+i*316, 164)
		MobChoiceContainer.custom_minimum_size = Vector2(300, 200)
		add_child(MobChoiceContainer)
		
		var MobChoiceButton = Button.new()
		MobChoiceButton.custom_minimum_size = Vector2(300, 200)
		MobChoiceButton.name = "MobChoiceButton" + str(i)
		MobChoiceContainer.add_child(MobChoiceButton)

		# Connecte le bouton au handler
		MobChoiceButton.pressed.connect(_on_MobChoiceButton_pressed.bind(MobChoiceButton, creature))



		var LabelMob = Label.new()
		LabelMob.position = Vector2(16, 16)
		LabelMob.scale = Vector2(3,3)
		LabelMob.text = creature["name"]
		MobChoiceContainer.add_child(LabelMob)
		
		var SpriteMob = Sprite2D.new()
		SpriteMob.texture = load(creature["texture"])
		SpriteMob.position = Vector2(150, 132)
		SpriteMob.scale = Vector2(0.3,0.3)
		MobChoiceContainer.add_child(SpriteMob)

func _on_MobChoiceButton_pressed(button: Button, creature_data: Dictionary):
	click_count += 1
	button.disabled = true

	# Ajoute la créature sélectionnée à BossFight
	get_node("/root/BossFight").creatures.append(creature_data)

	if click_count >= 3:
		visible = false
		get_node("/root/BossFight").spawn_mobs()
