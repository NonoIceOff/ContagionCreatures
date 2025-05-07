extends Node2D

var menu_fade_out = false
var text = ""
var quest_names = []

func _init() -> void:
	SaveSystem.load()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))
	http_request.request("https://contagioncreaturesapi.vercel.app/api/texts")
		
	if Global.user != {}:
		get_node("Background/Menu/Right_part/VBoxContainer/VBoxContainer2/VBoxContainer/ProfileButton").text = Global.user.username
		get_node("Background/Menu/Right_part/VBoxContainer/VBoxContainer2/VBoxContainer/ConnexionStatus").text = "Voir votre profil"

	init_save_text()
	init_quest_names()
	

func init_quest_names():
	print("Initialisation des quêtes")
	# Récupération de tous les fichiers dans res://Constantes/Quests
	var dir = DirAccess.open("res://Constantes/Quests")
	if dir == null:
		print("Erreur lors de l'ouverture du répertoire.")
		return
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break # Fin de la liste des fichiers (quêtes)
		if file_name.ends_with(".json") and not dir.current_is_dir():
			var file_path = "res://Constantes/Quests/" + file_name
			var quest_file = FileAccess.open(file_path, FileAccess.READ)
			if quest_file:
				var content = quest_file.get_as_text()
				var json = JSON.parse_string(content)
				if typeof(json) == TYPE_DICTIONARY and json.has("title"):
					var newCheckbox = CheckButton.new()
					newCheckbox.text = json["title"]
					newCheckbox.add_theme_font_size_override("font_size", 46)
					newCheckbox.add_theme_color_override("font_color", Color(0.5, 0, 0))
					newCheckbox.focus_mode = Control.FOCUS_NONE
					newCheckbox.button_pressed = true

					get_node("SaveOptions/VBoxContainer").add_child(newCheckbox)
					quest_names.append(json["title"])
				else:
					print("Fichier sans clé 'title' :", file_name)
			else:
				print("Erreur lors de l'ouverture de :", file_name)
			quest_file.close()

func init_save_text():
	print("Initialisation du texte de sauvegarde")
	var dir = DirAccess.open("user://") # Ouvre l'accès au dossier "user://"

	
	for i in range(1, 4):
		var folder_path = "Saves/File" + str(i)
		print("passage à la sauvegarde " + str(i))
		var save_name = ""

		var node_label = get_node("VBoxContainer/Fichier" + str(i) + "/RichTextLabel")
		var node_stats = get_node("VBoxContainer/Fichier" + str(i) + "/Stats")

		node_label.text = "[color=red]SAUVEGARDE " + str(i) + " VIDE[/color]"
		
		if dir.dir_exists(folder_path): # Si le dossier existe
			var saves_dir = DirAccess.open("user://" + folder_path)
			if saves_dir != null:
				saves_dir.list_dir_begin() # On commence à lire les fichiers du dossier de sauvegardes
				while true: # On boucle tant qu'il y a des fichiers
					var file_name = saves_dir.get_next()
					print(file_name)
					if file_name == "":
						break # On sort de la boucle quand il n'y en a plus
					if file_name.ends_with(".txt"):
						save_name = file_name.substr(0, file_name.length() - 4) # On enlève le .txt
						break
				saves_dir.list_dir_end()

		var load_file = ConfigFile.new()
		var save_path = "user://Saves/File" + str(i) + "/" + "unknown.txt"
		print(save_path)
		var error = load_file.load_encrypted_pass(save_path, "gentle_duck")
		var vies = 100
		var monnaie = 0
		var level = 0
		var seconds = 0
		if error != OK:
			print("Erreur de chargement du fichier de sauvegarde :", error)
		else:
			print("Sauvegarde chargée avec succès.")
			vies = load_file.get_value("Player", "health", 0)
			monnaie = load_file.get_value("Player", "money", 0)
			level = load_file.get_value("Player", "level", 0)
			seconds = load_file.get_value("Stats", "Time Played", 0)
			print("seconds", seconds)

		
		if save_name != "":
			node_label.text = "[font_size=128][rainbow freq=0.02 sat=0.8 val=1 speed=2]" + save_name.to_upper() + "[/rainbow]"
			var hours = int(seconds) / 3600
			var minutes = (int(seconds) % 3600) / 60
			var secs = int(seconds) % 60
			node_stats.text = "[font_size=32]❤" + str(vies) + "\n💰" + str(monnaie) + "\nNiveau " + str(level) + "\n[color=blue]" + str(hours).pad_zeros(2) + ":" + str(minutes).pad_zeros(2) + ":" + str(secs).pad_zeros(2)
			get_node("VBoxContainer/Fichier" + str(i) + "/Delete").visible = true


func _physics_process(delta):
	if menu_fade_out == true:
		set_modulate(lerp(get_modulate(), Color(1, 1, 1, 0), 0.02))


func delete_directory(folder_path):
	var dir = DirAccess.open("user://") # Ouvre l'accès au dossier "user://"
	if dir.change_dir(folder_path) == OK: # Si le dossier existe
		dir.list_dir_begin() # Commence à lister les fichiers et dossiers
		while true:
			var file_name = dir.get_next()
			if file_name == "":
				break # Fin de la liste
			if file_name != "." and file_name != "..": # Ignore les entrées spéciales
				if dir.current_is_dir():
					# Appel récursif pour supprimer les sous-dossiers
					delete_directory(folder_path + "/" + file_name)
				else:
					# Supprime les fichiers
					dir.remove(file_name)
					print("Fichier supprimé :", file_name)
		dir.list_dir_end()
		dir.change_dir("..")
		var folder_name = folder_path.get_file()
		dir.remove(folder_name)
		print("Dossier supprimé :", folder_name)
	else:
		print("Erreur lors de la suppression du dossier :", folder_path)

func _process(delta):
	for i in range(1, 4):
		if get_node("VBoxContainer/Fichier" + str(i) + "/Delete/Button").is_pressed() == true:
			var dir = DirAccess.open("user://") # Ouvre l'accès au dossier "user://"
			var folder_path = "Saves/File" + str(i)
			print(folder_path)
			if dir.change_dir(folder_path) == OK: # Si le dossier existe
				delete_directory(folder_path + "/") # Supprime le dossier
				print("Dossier supprimé :", folder_path)
				get_node("VBoxContainer/Fichier" + str(i) + "/RichTextLabel").text = "[color=red]SAUVEGARDE " + str(i) + " VIDÉE[/color]"
				get_node("VBoxContainer/Fichier" + str(i) + "/Stats").text = ""
				get_node("SaveOptions").visible = false
			else:
				print("Erreur lors de la suppression du dossier :", folder_path)


		if get_node("VBoxContainer/Fichier" + str(i)).is_pressed() == true:
			var dir = DirAccess.open("user://") # Ouvre l'accès au dossier "user://"
			var folder_path = "Saves/File" + str(i)
			print(folder_path)
			var save_file_found = false
		
			if dir.change_dir(folder_path) != OK: # Si pas de save
				get_node("SaveOptions").visible = true
				var prefix_text = ["Kilo", "Mega", "Giga", "Peta", "Tera", "Exa", "Zetta", "Yotta"]
				var base_text = ["Red", "Green", "Blue", "Yellow", "Pink", "Purple"]
				var suffix_text = ["House", "Car", "Boat", "Plane", "Train", "Rocket"]
				var text = prefix_text[randi() % prefix_text.size()] + base_text[randi() % base_text.size()] + suffix_text[randi() % suffix_text.size()]
				get_node("SaveOptions/LineEdit").placeholder_text = str(text)
				get_node("SaveOptions/LineEdit").text = str(text)
				SaveSystem.file_id = i
			else:
				get_tree().change_scene_to_file("res://Scenes/map3.tscn")
				SaveSystem.file_id = i
				SaveSystem.load()
		
	if float(get_modulate()[3]) <= 0.1:
		get_tree().change_scene_to_file("res://Scenes/map3.tscn")

func _on_leave_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_exit_pressed() -> void:
	get_node("SaveOptions").visible = false


func _on_create_pressed() -> void:
	var custom_filename = get_node("SaveOptions/LineEdit").text
	SaveSystem.filename = custom_filename
	get_tree().change_scene_to_file("res://Scenes/map3.tscn")
	SaveSystem.save()
