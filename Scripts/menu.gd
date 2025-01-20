extends Node2D

func _init() -> void:
	Global.load_user()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.load_localisation()
	if Global.user != {}:
		get_node("Profile").text = Global.user.username
		get_node("Profile/PatreonCode").text = "Voir votre profil"
	
	
func _process(delta):
	pass


func _on_profile_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/profil.tscn")
