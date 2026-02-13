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
			# Charger le nom depuis settings.txt
			var settings_file = ConfigFile.new()
			var settings_path = "user://Saves/File" + str(i) + "/settings.txt"
			var settings_error = settings_file.load(settings_path)
			if settings_error == OK:
				save_name = settings_file.get_value("File", "Name", "")
				print("Nom chargé depuis settings.txt : ", save_name)
			else:
				print("⚠️ Impossible de charger settings.txt pour File" + str(i))

		# Charger le vrai nom du fichier depuis settings.txt
		var actual_filename = save_name if save_name != "" else "unknown"
		
		var load_file = ConfigFile.new()
		var save_path = "user://Saves/File" + str(i) + "/" + actual_filename + ".txt"
		print("Tentative de chargement: ", save_path)
		var error = load_file.load_encrypted_pass(save_path, "gentle_duck")
		var vies = 100
		var monnaie = 0
		var level = 0
		var seconds = 0
		if error != OK:
			print("⚠️ Erreur de chargement du fichier de sauvegarde :", error)
		else:
			print("✅ Sauvegarde chargée avec succès.")
			vies = load_file.get_value("Player", "health", 100)
			monnaie = load_file.get_value("Player", "money", 0)
			level = load_file.get_value("Player", "level", 1)
			seconds = load_file.get_value("Stats", "Time Played", 0)
			print("⏱️ Temps de jeu: ", seconds, " secondes")

		
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
	var dir = DirAccess.open("user://" + folder_path)
	if dir == null:
		print("Erreur : Impossible d'ouvrir le dossier :", folder_path)
		return
	
	# Supprimer tous les fichiers dans le dossier
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		if file_name != "." and file_name != "..":
			if dir.current_is_dir():
				# Appel récursif pour supprimer les sous-dossiers
				delete_directory(folder_path + "/" + file_name)
			else:
				# Supprime les fichiers
				var full_path = "user://" + folder_path + "/" + file_name
				if DirAccess.remove_absolute(full_path) == OK:
					print("Fichier supprimé :", full_path)
				else:
					print("Erreur lors de la suppression du fichier :", full_path)
	dir.list_dir_end()
	
	# Supprimer le dossier lui-même
	var full_folder_path = "user://" + folder_path
	if DirAccess.remove_absolute(full_folder_path) == OK:
		print("Dossier supprimé :", full_folder_path)
	else:
		print("Erreur lors de la suppression du dossier :", full_folder_path)

func _process(delta):
	for i in range(1, 4):
		if get_node("VBoxContainer/Fichier" + str(i) + "/Delete/Button").is_pressed() == true:
			var folder_path = "Saves/File" + str(i)
			print("Suppression du dossier :", folder_path)
			delete_directory(folder_path)
			get_node("VBoxContainer/Fichier" + str(i) + "/RichTextLabel").text = "[color=red]SAUVEGARDE " + str(i) + " VIDE[/color]"
			get_node("VBoxContainer/Fichier" + str(i) + "/Stats").text = ""
			get_node("VBoxContainer/Fichier" + str(i) + "/Delete").visible = false
			get_node("SaveOptions").visible = false

		if get_node("VBoxContainer/Fichier" + str(i)).is_pressed() == true:
			var dir = DirAccess.open("user://")
			var folder_path = "Saves/File" + str(i)
			print(folder_path)
			
			if dir.change_dir(folder_path) != OK:
				get_node("SaveOptions").visible = true
				var prefix_text = ["Kilo", "Mega", "Giga", "Peta", "Tera", "Exa", "Zetta", "Yotta"]
				var base_text = ["Red", "Green", "Blue", "Yellow", "Pink", "Purple"]
				var suffix_text = ["House", "Car", "Boat", "Plane", "Train", "Rocket"]
				var text = prefix_text[randi() % prefix_text.size()] + base_text[randi() % base_text.size()] + suffix_text[randi() % suffix_text.size()]
				get_node("SaveOptions/LineEdit").placeholder_text = str(text)
				get_node("SaveOptions/LineEdit").text = str(text)
				SaveSystem.file_id = i
			else:
				SaveSystem.file_id = i
				SaveSystem.load()
				menu_fade_out = true
	
	if float(get_modulate()[3]) <= 0.1:
		get_tree().change_scene_to_file("res://Scenes/Maps/map3.tscn")

func _on_leave_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Maps/map3.tscn")


func _on_exit_pressed() -> void:
	get_node("SaveOptions").visible = false


func _on_create_pressed() -> void:
	var custom_filename = get_node("SaveOptions/LineEdit").text
	SaveSystem.filename = custom_filename
	SaveSystem.save_file_infos()
	menu_fade_out = true
