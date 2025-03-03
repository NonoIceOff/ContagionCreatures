extends Node2D

@onready var main_player = $"../../../.."
@onready var sauvegarde_dialog = $ConfirmationDialog
@onready var progress_panel = $ProgressPanel  # Panneau contenant la barre de progression
@onready var progress_bar = $ProgressPanel/ProgressBar  # Barre de progression
var timer: Timer

# Durée totale pour remplir la barre (ajustable selon vos besoins)
var total_progress_duration = 1.0  # En secondes
var progress_step_duration = 0.1  # Intervalle entre chaque étape de progression (en secondes)

func _ready():
	sauvegarde_dialog.exclusive = true
	progress_panel.visible = false

func _on_reprendre_pressed():
	main_player.PauseMenu()

func _on_paramètres_pressed():
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")

func _on_sauvegarde_pressed():
	sauvegarde_dialog.visible = true
	sauvegarde_dialog.popup_centered()

func _on_sauvegarde_confirmed():
	# Sauvegarde des données
	Global.save()
	print("Sauvegarde effectuée !")

	# Initialise la barre de progression
	progress_panel.visible = true
	progress_bar.value = 0

	# Crée ou réinitialise le Timer pour gérer la progression
	if timer == null:
		timer = Timer.new()
		add_child(timer)
		timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	
	timer.wait_time = progress_step_duration  # Définit le pas de progression
	timer.one_shot = false
	timer.start()

func _on_timer_timeout():
	# Augmente la valeur de la ProgressBar
	progress_bar.value += (progress_step_duration / total_progress_duration) * 100
	_hide_progress_panel()
	if progress_bar.value >= 100:
		timer.stop()
		_hide_progress_panel()

func _hide_progress_panel():
	# Cache le panneau de progression et nettoie le Timer
	progress_panel.visible = false
	if timer != null:
		timer.queue_free()
		timer = null

func _on_menu_principal_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_quitter_pressed():
	get_tree().quit()
