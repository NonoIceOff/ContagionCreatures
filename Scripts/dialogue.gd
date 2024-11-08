extends Control

@onready var dialogue_label : RichTextLabel = $Paper/Textes 
@onready var choices_container : VBoxContainer = $ChoicesContainer

var dialogues : Array = []
var current_dialogue : int = 0
var is_choice_dialogue : bool = false
var current_choice : Dictionary = {} 

# Fonction pour démarrer le dialogue
func start_dialogue(dialogue_data: Array):
	dialogues = dialogue_data
	current_dialogue = 0
	is_choice_dialogue = false
	show_next_dialogue()

# Fonction pour afficher le dialogue suivant
func show_next_dialogue():
	if current_dialogue < dialogues.size():
		var dialogue = dialogues[current_dialogue]
		current_dialogue += 1

		# Vérifier si c'est un dialogue avec choix
		if dialogue.has("choices"):
			is_choice_dialogue = true
			show_choices(dialogue["choices"])
		else:
			is_choice_dialogue = false
			dialogue_label.bbcode_text = dialogue["text"]
			set_process_input(true)  # Attendre un clic pour afficher le texte suivant
			
			# Vérifier s'il y a une fonction associée à ce texte (action)
			if dialogue.has("action"):
				call_custom_function(dialogue["action"])  # Appel de la fonction associée
	else:
		end_dialogue()

# Fonction pour afficher les choix
func show_choices(choices: Array):
	dialogue_label.bbcode_text = "Choisissez une option:"
	
	# Afficher les boutons de choix
	choices_container.visible = true
	clear_choices()  # Nettoyer les anciens boutons de choix

	for choice in choices:
		var button = Button.new()
		button.text = choice["text"]
		button.set("theme_override_colors/font_color", Color(0,0,0));
		button.self_modulate
		button.custom_minimum_size = Vector2(128,32)
		button.add_theme_font_size_override("font_size", 48)
		var stylebox_theme: StyleBoxFlat = button.get_theme_stylebox("normal")
		stylebox_theme.bg_color = Color("ffffd8")
		button.add_theme_stylebox_override("normal", stylebox_theme)
		
		# Utilisation d'une lambda pour passer le choix
		button.connect("pressed", Callable(self, "_on_choice_pressed").bind(choice))  # Lier le choix avec bind()
		choices_container.add_child(button)

# Fonction pour nettoyer les anciens boutons de choix
func clear_choices():
	for child in choices_container.get_children():
		child.queue_free()  # Supprimer chaque enfant un par un

# Fonction qui gère la sélection d'un choix
func _on_choice_pressed(choice: Dictionary):
	choices_container.visible = false
	current_choice = choice  # L'assignation fonctionne maintenant car current_choice est un dictionnaire
	dialogue_label.bbcode_text = current_choice["response"]
	set_process_input(true)  # Activer l'attente de l'input pour passer au texte suivant
	
	# Appeler la fonction associée au choix
	if choice.has("action"):
		call_custom_function(choice["action"])

# Fonction pour terminer le dialogue
func end_dialogue():
	choices_container.visible = false
	dialogue_label.bbcode_text = "Fin du dialogue."

# Fonction qui gère le clic pour passer au texte suivant
func _input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		if current_choice != {}:  # Vérifie si un choix a été sélectionné
			# Après le choix, afficher le texte suivant
			current_choice = {}  # Réinitialiser le choix en cours
			show_next_dialogue()  # Afficher le dialogue suivant
		elif not is_choice_dialogue:  # Si ce n'est pas un dialogue de choix
			# Afficher le dialogue suivant au clic
			show_next_dialogue()  # Afficher le dialogue suivant

# Fonction pour appeler une fonction personnalisée basée sur l'élément "action"
func call_custom_function(action: Callable):
	if action:
		action.call()  # Appel de la fonction si elle est définie

# Exemple de fonction externe à appeler
func _on_dialogue_start():
	print("Début du dialogue, actions personnalisées ici.")

# Exemple de fonction externe à appeler à la fin du dialogue
func _on_dialogue_end():
	print("Dialogue terminé, actions personnalisées ici.")

# Exemple de dialogue avec des choix et des actions
var dialogue_data = [
	{"text": "Bonjour, comment ça va ?", "action": Callable(self, "_on_dialogue_start")},  # Début du dialogue
	{"text": "Je peux vous aider ?"},
	{"text": "Voulez-vous des informations ?", "choices": [
		{"text": "Oui", "response": "Voici les informations.", "action": Callable(self, "_on_yes_choice")},  # Choix "Oui"
		{"text": "Non", "response": "D'accord, à bientôt!"}
	]},
	{"text": "Fin du dialogue.", "action": Callable(self, "_on_dialogue_end")}  # Fin du dialogue
]

# Exemple de fonction pour le choix "Oui"
func _on_yes_choice():
	print("Vous avez choisi Oui, voici les informations.")

# Initialisation et démarrage du dialogue dans le _ready()
func _ready():
	# Démarre le dialogue
	start_dialogue(dialogue_data)
