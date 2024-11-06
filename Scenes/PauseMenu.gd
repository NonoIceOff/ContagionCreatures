extends Node2D

@onready var main = get_node_or_null("/root/main_map")
@onready var sauvegarde_dialog = $ConfirmationDialog
@onready var progress_panel = $ProgressPanel  # Change le type en PopupPanel dans la scène
@onready var progress_bar = $ProgressPanel/ProgressBar  # Barre de progression dans le panneau
var timer: Timer

# Durée totale pour remplir la barre (ajustable selon vos besoins)
var total_progress_duration = 1.0

func _ready():
	sauvegarde_dialog.exclusive = true
	progress_panel.visible = false  # Cache le panneau de progression au début

func _on_reprendre_pressed():
	main.PauseMenu()

func _on_paramètres_pressed():
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")

func _on_sauvegarde_pressed():
	sauvegarde_dialog.visible = true
	sauvegarde_dialog.popup_centered()

func _on_sauvegarde_confirmed():
	Global.save()
	print("Sauvegarde effectuée !")

	# Affiche le panneau de progression
	progress_panel.visible = true
	progress_bar.value = 0

	# Crée un Timer pour gérer la progression si non existant
	if timer == null:
		timer = Timer.new()
		timer.wait_time = total_progress_duration / 10  # Divise la durée totale en étapes pour la progression
		timer.one_shot = false
		timer.connect("timeout", Callable(self, "_on_timer_timeout"))
		add_child(timer)
	
	timer.start()

func _on_timer_timeout():
	progress_bar.value += 10
	
	if progress_bar.value >= 100:
		timer.stop()
		timer.disconnect("timeout", Callable(self, "_on_timer_timeout"))

		# Lance un autre Timer pour fermer le panneau après un court délai
		timer.wait_time = 1.0  # Délai final pour visualiser la progression complète
		timer.one_shot = true
		timer.connect("timeout", Callable(self, "_hide_progress_panel"))
		timer.start()

func _hide_progress_panel():
	progress_panel.hide()
	timer.queue_free()
	timer = null

func _on_menu_principal_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_quitter_pressed():
	get_tree().quit()
