extends Node2D



func _init() -> void:
	SaveSystem.load()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_profile_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/profil.tscn")
