extends Node2D

# Déclaration des variables des sprites
@onready var Skill1 = $Skill1/Button_Skill1
@onready var Skill1Panel = $Skill1/Panel
var skill1_active = false
var skill1_unlocked = false
var skill1_cost = 1
var skill1_description = "Skill 1 description"

func _ready():
	_setting_all_panel_text() # Appel de la méthode pour initialiser le texte du panneau
	# Connexion du signal "pressed" du bouton à la méthode _on_Button_Skill1_pressed
	Skill1.connect("pressed", Callable(self, "_on_Button_Skill1_pressed"))
	# Connexion du signal "mouse_entered"
	Skill1.connect("mouse_entered", Callable(self, "_on_Button_Skill1_mouse_entered"))	
	Skill1.connect("mouse_exited", Callable(self, "_on_Button_Skill1_mouse_exited"))



# Méthode appelée lorsque le bouton est pressé
func _on_Button_Skill1_pressed():
	# Vérification si le bouton est déjà sélectionné et modifie la couleur pour montrer actif ou inactif
	if not skill1_unlocked:
		print("Skill 1 is not unlocked yet!")
		return
	
	if skill1_active:
		Skill1.modulate = Color(1, 1, 1) # Couleur normale
		skill1_active = false
	else:
		Skill1.modulate = Color(0.5, 0.5, 0.5) # Couleur grisée
		skill1_active = true
	
func _on_Button_Skill1_mouse_entered():	
	print("Mouse entered")
	Skill1Panel.visible = true



func _on_Button_Skill1_mouse_exited():
	print("Mouse exited")
	Skill1Panel.visible = false
	
	
func _setting_all_panel_text() -> void:
	# Récupération des deux labels déjà présents dans la hiérarchie
	var top_label    = $Skill1/Panel/Top_label
	var bottom_label = $Skill1/Panel/Bot_label

	# --- Propriétés communes ------------------------------------------
	top_label.add_theme_font_size_override("font_size", 10)
	bottom_label.add_theme_font_size_override("font_size", 10)

	# --- Texte du label du haut ---------------------------------------
	if skill1_unlocked:
		top_label.text = "Skill 1 active" if skill1_active else "Skill 1 inactive"
	else:
		top_label.text = "Coût : %d " % skill1_cost

	# --- Texte du label du bas ----------------------------------------
	bottom_label.text = skill1_description
