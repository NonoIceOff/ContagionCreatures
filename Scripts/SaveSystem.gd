extends Node

var file_id = 1
var filename = "unknown"

func save_file_infos():
	var save_file = ConfigFile.new()
	save_file.set_value("File", "Name", filename)
	var file_folder = filename
	var save_path := "user://Saves/" + str(file_folder) + "/settings.txt"
	save_file.save(save_path)

func save():
	var save_file = ConfigFile.new()
	save_file.set_value("Tuto", "Stade", Global.tutorial_stade)
	save_file.set_value("Tuto", "Type", Global.tutorial)
	save_file.set_value("Tuto", "Validate", Global.tutorial_validate)
	save_file.set_value("Tags", "Blue", Global.pinb)
	save_file.set_value("Tags", "Red", Global.pinr)
	save_file.set_value("Tags", "Yellow", Global.piny)
	save_file.set_value("Tags", "Green", Global.ping)

	save_file.set_value("Tutorial", "Stade", Global.tutorial_stade)
	save_file.set_value("Tutorial", "Validate", Global.tutorial_validate)
	save_file.set_value("Tutorial", "Tutorial", Global.tutorial)
	
	save_file.set_value("Quests", "infos", Quests.quests)
	save_file.set_value("Quests", "current", Quests.current_quest_id)
	if get_node_or_null("/root/main_map/CanvasLayer/Minimap") != null:
		save_file.set_value("Quests", "radar_position", get_node("/root/main_map/CanvasLayer/Minimap").pin)
		save_file.set_value("Quests", "radar_enabled", true)
	else:
		save_file.set_value("Quests", "radar_position", Vector2(0, 0))
		save_file.set_value("Quests", "radar_enabled", false)

	save_file.set_value("Player", "pseudo", PlayerStats.pseudo)
	save_file.set_value("Player", "health", PlayerStats.health)
	save_file.set_value("Player", "skin", PlayerStats.skin)
	save_file.set_value("Player", "level", PlayerStats.level)
	save_file.set_value("Player", "monnaie", PlayerStats.money)

	var player_node = get_node_or_null("/root/"+Global.current_map+"/TileMap/Player_One")
	if player_node:
		save_file.set_value("Player", "position", player_node.position)
	else:
		print("Le joueur n'est pas disponible pour la sauvegarde de position.")

	save_file.set_value("Time", "hour", Global.current_hour)
	save_file.set_value("Time", "minute", Global.current_minute)
	save_file.set_value("Time", "day", Global.current_day)
	save_file.set_value("Time", "color", Global.target_color)

	var dir := DirAccess.open("user://")
	if dir == null:
		push_error("Impossible d'ouvrir le répertoire user://")
		return

	# Créer "Saves" s'il n'existe pas
	if not dir.dir_exists("Saves"):
		dir.make_dir("Saves")

	# Aller dans "Saves"
	dir.change_dir("Saves")

	# Créer "FileX" s'il n'existe pas
	var file_folder := "File" + str(file_id)
	if not dir.dir_exists(file_folder):
		dir.make_dir(file_folder)

	# Sauvegarde
	var save_path: String = "user://Saves/" + file_folder + "/" + filename + ".txt"
	save_file.save_encrypted_pass(save_path, "gentle_duck")
	print("Sauvegarde terminée.")


func load():
	var load_file = ConfigFile.new()
	var save_path = "user://Saves/File" + str(file_id) + "/" + filename + ".txt"
	var error = load_file.load_encrypted_pass(save_path, "gentle_duck")
	if error != OK:
		print("Erreur de chargement du fichier de sauvegarde :", error)
		return

	Global.pinb = load_file.get_value("Tags", "Blue", Global.pinb)
	Global.pinr = load_file.get_value("Tags", "Red", Global.pinr)
	Global.piny = load_file.get_value("Tags", "Yellow", Global.piny)
	Global.ping = load_file.get_value("Tags", "Green", Global.ping)
	Global.tutorial_stade = 20
	Global.tutorial_validate = load_file.get_value("Tutorial", "Validate", Global.tutorial_validate)
	Global.tutorial = load_file.get_value("Tutorial", "Tutorial", Global.tutorial)
	
	PlayerStats.pseudo = load_file.get_value("Player", "pseudo", PlayerStats.pseudo)
	PlayerStats.health = load_file.get_value("Player", "health", PlayerStats.health)
	PlayerStats.skin = load_file.get_value("Player", "skin", PlayerStats.skin)
	PlayerStats.level = load_file.get_value("Player", "level", PlayerStats.level)
	PlayerStats.money = load_file.get_value("Player", "money", PlayerStats.money)

	var player_node = get_node_or_null("/root/"+Global.current_map+"/TileMap/Player_One")
	if player_node:
		player_node.position = load_file.get_value("Player", "position", Vector2(0, 0))
		print("Position joueur chargée :", player_node.position)
	else:
		print("Erreur : Le joueur n'a pas été trouvé dans la scène.")
	
	Global.current_hour = load_file.get_value("Time", "hour", Global.current_hour)
	Global.current_minute = load_file.get_value("Time", "minute", Global.current_minute)
	Global.current_day = load_file.get_value("Time", "day", Global.current_day)
	Global.target_color = load_file.get_value("Time", "color", Global.target_color)
	print("color:"+ str(Global.target_color))

func load_position():
	# Appelle le chargement différé
	call_deferred("_apply_player_position")

func load_user():
	var load_file = ConfigFile.new()
	load_file.load_encrypted_pass("user://user.txt", "user_key")
	Global.user = load_file.get_value("User","Data",Global.user)

func save_user():
	var save_file = ConfigFile.new()
	save_file.set_value("User","Data",Global.user)
	save_file.save_encrypted_pass("user://user.txt", "user_key")
	
func load_localisation():
	var load_file = ConfigFile.new()
	load_file.load_encrypted_pass("user://languages.txt", "gentle_duck")
	TranslationServer.set_locale(load_file.get_value("Languages","Current",TranslationServer.get_locale()))
	
func save_localisation():
	var save_file = ConfigFile.new()
	save_file.set_value("Languages","Current",TranslationServer.get_locale())
	save_file.save_encrypted_pass("user://languages.txt", "gentle_duck")
