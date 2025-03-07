extends Node2D



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
		get_node("Profile").text = Global.user.username
		get_node("Profile/PatreonCode").text = "Voir votre profil"

func _on_profile_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/profil.tscn")
