extends Button



func _on_pressed():
	DirAccess.remove_absolute("user://save.txt")
