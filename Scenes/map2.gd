extends Node2D

var entered = false

<<<<<<< HEAD
=======

>>>>>>> 7106966d40a904464f65641079c7f09d727ec6cd
func _ready():
	get_node("/root/map2/CanvasLayer2/Transition/AnimationPlayer").play("transition_to_screen")
	await get_tree().create_timer(0.05).timeout


<<<<<<< HEAD
=======

>>>>>>> 7106966d40a904464f65641079c7f09d727ec6cd
func _process(delta):
	pass


func _on_leave_to_map_1_body_entered(body):
<<<<<<< HEAD
	#Fonction lorsque le corps entre en collision avec une zone de transition vers la carte.
	#Change la scène vers la carte principale si le joueur entre dans la zone.
=======
>>>>>>> 7106966d40a904464f65641079c7f09d727ec6cd
	entered = false
	if body.is_in_group("Player_One"):
		entered = true
		get_node("/root/main_map/CanvasLayer/Transition/AnimationPlayer").play("screen_to_transition")
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://Scenes/main_map.tscn")


func _on_enter_home_map_2_body_entered(body):
<<<<<<< HEAD
	#Fonction lorsque le corps entre en collision avec une zone de transition vers la maison de la carte.
=======
>>>>>>> 7106966d40a904464f65641079c7f09d727ec6cd
	pass # change scene to the house of the Map2


func _on_enter_donjon_body_entered(body):
<<<<<<< HEAD
	#Fonction lorsque le corps entre en collision avec une zone de transition vers un donjon.
	#Change la scène vers un donjon aléatoire après avoir joué une animation de transition.
=======
>>>>>>> 7106966d40a904464f65641079c7f09d727ec6cd
	entered = false
	if body.is_in_group("Player_One"):
		entered = true
		get_node("/root/map2/CanvasLayer2/Transition/AnimationPlayer").play("screen_to_transition")
		await get_tree().create_timer(0.2).timeout
		var random = randi_range(0,1)
		if random == 0:
			get_tree().change_scene_to_file("res://Scenes/dungeon1.tscn")
		if random == 1:
			get_tree().change_scene_to_file("res://Scenes/dungeon_enigme.tscn")
<<<<<<< HEAD
=======
	
>>>>>>> 7106966d40a904464f65641079c7f09d727ec6cd
