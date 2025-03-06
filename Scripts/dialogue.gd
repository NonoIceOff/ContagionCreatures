extends CanvasLayer

@onready var dialogue_label : RichTextLabel = $Paper/Textes
@onready var choices_container : VBoxContainer = $ChoicesContainer

var dialogues : Array = []
var current_dialogue : int = 0
var is_choice_dialogue : bool = false
var current_choice : Dictionary = {}
var pnj_name = ""

var typing_speed : float = 0.03  # Vitesse d'affichage progressive (optionnel)
var is_typing : bool = false  # Vérifie si un texte est en cours d'affichage

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

### ✅ **Démarrer un dialogue**
func start_dialogue(dialogue_data: Array):
	Global.ui_visible = false
	smooth_zoom(camera[0], 3)
	get_node("Label").text = pnj_name
	dialogues = dialogue_data
	current_dialogue = 0
	is_choice_dialogue = false
	show_next_dialogue()

### ✅ **Afficher le dialogue suivant**
func show_next_dialogue():
	if is_typing:
		return  # Empêche l'affichage multiple

	if current_dialogue < dialogues.size():
		var dialogue = dialogues[current_dialogue]
		current_dialogue += 1

		if dialogue.has("choices"):
			is_choice_dialogue = true
			show_choices(dialogue["choices"])
		else:
			is_choice_dialogue = false
			type_text(dialogue["text"])  # Effet d'affichage progressif

			# Vérifier et exécuter l'action associée
			if dialogue.has("action") and dialogue["action"] is String and has_method(dialogue["action"]):
				call(dialogue["action"])
	else:
		end_dialogue()

### ✅ **Effet d'affichage progressif du texte**
func type_text(full_text: String):
	is_typing = true
	dialogue_label.text = ""
	
	for i in range(full_text.length()):
		dialogue_label.text += full_text[i]
		await get_tree().create_timer(typing_speed).timeout
	
	is_typing = false

### ✅ **Afficher les choix**
func show_choices(choices: Array):
	dialogue_label.text = "Choisissez une option :"

	choices_container.visible = true
	clear_choices()

	for choice in choices:
		var button = Button.new()
		button.text = choice["text"]
		button.custom_minimum_size = Vector2(128, 32)
		button.add_theme_font_size_override("font_size", 48)

		# Changer la couleur du bouton
		var stylebox_theme: StyleBoxFlat = button.get_theme_stylebox("normal").duplicate()
		stylebox_theme.bg_color = Color("ffffd8")
		button.add_theme_stylebox_override("normal", stylebox_theme)

		button.pressed.connect(_on_choice_pressed.bind(choice))
		choices_container.add_child(button)

### ✅ **Nettoyer les anciens boutons de choix**
func clear_choices():
	for child in choices_container.get_children():
		child.queue_free()

### ✅ **Gérer la sélection d'un choix**
func _on_choice_pressed(choice: Dictionary):
	choices_container.visible = false
	current_choice = choice
	type_text(choice["response"])

	# Vérifier et exécuter l'action associée
	if choice.has("action") and choice["action"] is String and has_method(choice["action"]):
		call(choice["action"])

### ✅ **Terminer le dialogue**
func end_dialogue():
	Global.ui_visible = true
	smooth_zoom(camera[0], 1.8)
	choices_container.visible = false
	dialogue_label.text = "Fin du dialogue."

	visible = false
	await get_tree().create_timer(1).timeout
	
	if Quests.quests.get(Quests.current_quest_id).stade != Quests.quests.get(Quests.current_quest_id).descriptions.size():
		if Quests.quests.get(Quests.current_quest_id).stade != Quests.quests.get(Quests.current_quest_id).descriptions.size()-1:
			Quests.advance_stade(Quests.current_quest_id)
			Quests.respawn_pnj(Global.current_map, Quests.current_quest_id)
		else:
			Quests.quests.get(Quests.current_quest_id).finished = true
			Quests.delete_pnj(Global.current_map, Quests.current_quest_id)
			Quests.current_quest_id = -1
	queue_free()


### ✅ **Gérer l'input (clic pour avancer)**
func _input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		click_dialogue()
	var joypads = Input.get_connected_joypads()
	if joypads.size() >= 1:
		if Input.is_action_just_pressed(Controllers.a_input):
			click_dialogue()
		

func click_dialogue():
	if is_typing:
		# Si le texte est en train de s'afficher, on le complète immédiatement
		dialogue_label.text = dialogues[current_dialogue - 1]["text"]
		is_typing = false
	elif current_choice != {}:
		current_choice = {}  
		show_next_dialogue()
	elif not is_choice_dialogue:
		show_next_dialogue()

### ✅ **Exemple de dialogue avec des choix et des actions**
var dialogue_data = [
	{"text": "Bonjour, comment ça va ?", "action": "_on_dialogue_start"},
	{"text": "Je peux vous aider ?"},
	{"text": "Voulez-vous des informations ?", "choices": [
		{"text": "Oui", "response": "Voici les informations.", "action": "_on_yes_choice"},
		{"text": "Non", "response": "D'accord, à bientôt!"}
	]},
	{"text": "Fin du dialogue.", "action": "_on_dialogue_end"}
]

### ✅ **Fonction pour le choix "Oui"**
func _on_yes_choice():
	print("Vous avez choisi Oui, voici les informations.")

### ✅ **Fonction à la fin du dialogue**
func _on_dialogue_end():
	print("Dialogue terminé, action spécifique ici.")
