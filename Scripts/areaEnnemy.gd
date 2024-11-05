extends Area2D

var entered_Ennemy = false
signal getNode

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if entered_Ennemy == true:
		if Input.is_action_just_pressed("ui_interact"):
			Global.save()
			Tutorial.get_node(".").tutorials[4]["progress"] += 100
			emit_signal("getNode")
			await get_tree().create_timer(2).timeout
			get_tree().change_scene_to_file("res://Scenes/scène_combat.tscn")
			

func _on_area_ennemy_entered(body):
	if body.is_in_group("Player_One"):
		print("enter")
		entered_Ennemy = true
		get_node("Label_E_ennemy").visible = true


func _on_area_ennemy_exited(body):
	if body.is_in_group("Player_One"):
		print("exit")
		entered_Ennemy = false
		get_node("Label_E_ennemy").visible = false
