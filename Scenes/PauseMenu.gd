extends Node2D


@onready var main = get_node_or_null("/root/main_map")    #path vers node map_main
@onready var sauvegarde_dialog = $ConfirmationDialog
@onready var progress_bar = $ConfirmationDialog/ProgressBar

func _on_reprendre_pressed():
	main.PauseMenu()


func _on_paramètres_pressed():
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_sauvegarde_pressed():
	sauvegarde_dialog.visible = true
	
func _on_sauvegarde_confirmed():
	Global.save()
	print("Sauvegarde effectuée !")
	
	progress_bar.visible = true
	progress_bar.value = 0

	var timer = Timer.new()
	timer.wait_time = 0.1  # Délai entre chaque mise à jour
	timer.one_shot = false  # Répéter le timer
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()

func _on_timer_timeout(): #mettre cette fonction dans global pour le réutiliser partout
	progress_bar.value += 10 
	
	if progress_bar.value >= 100:
		progress_bar.visible = false
		$Timer.stop()
		$Timer.queue_free()

func _on_menu_principal_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_quitter_pressed():
	get_tree().quit()
