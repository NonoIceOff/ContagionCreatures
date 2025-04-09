extends Node2D

var menu_fade_out = false

func _init() -> void:
	Global.load()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var load_file = ConfigFile.new()
	var error = load_file.load_encrypted_pass("user://save.txt", "gentle_duck")
	if error != OK:
		print("Erreur de chargement du fichier de sauvegarde :", error)
		return
		
	if Global.user != {}:
		get_node("Menu/Right_part/VBoxContainer/VBoxContainer2/VBoxContainer/ProfileButton").text = Global.user.username
		get_node("Menu/Right_part/VBoxContainer/VBoxContainer2/VBoxContainer/ConnexionStatus").text = "Voir votre profil"


func _on_multiplayer_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/multiplayer/multiplayer.tscn")


func _on_solo_button_pressed() -> void:
	menu_fade_out = true
	load_next_scene()

func _physics_process(delta):
	if menu_fade_out == true:
		set_modulate(lerp(get_modulate(), Color(1,1,1,0), 0.02))

func _process(delta):
	if float(get_modulate()[3]) <= 0.1:
		get_tree().change_scene_to_file("res://Scenes/map3.tscn")
	

func load_next_scene():
	print(Global.tutorial_stade)
	if Global.tutorial_stade >= 9:
		SceneLoader.load_scene("res://Scenes/map3.tscn")
	else:
		SceneLoader.load_scene("res://Scenes/intro.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_ost_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/music_playlist.tscn")


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Credit_of_the_game.tscn")


func _on_profile_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/profil.tscn")


func _on_instagram_button_pressed() -> void:
	OS.shell_open("https://www.instagram.com/contagion_creatures/")


func _on_discord_button_pressed() -> void:
	OS.shell_open("https://discord.gg/JSyQFFEqaS")


func _on_leave_button_pressed() -> void:
	get_tree().quit()
