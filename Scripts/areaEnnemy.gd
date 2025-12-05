extends Area2D

var entered_Ennemy = false
signal getNode

@onready var label_e_ennemy = $Label_E_ennemy

func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed(Controllers.a_input):
		set_process(false)
		SaveSystem.save()
		emit_signal("getNode")
		await get_tree().create_timer(2).timeout
		SceneLoader.load_scene("res://Scenes/scène_combat.tscn")


func _on_area_ennemy_entered(body):
	if body.is_in_group("Player_One"):
		entered_Ennemy = true
		label_e_ennemy.visible = true
		set_process(true)


func _on_area_ennemy_exited(body):
	if body.is_in_group("Player_One"):
		entered_Ennemy = false
		label_e_ennemy.visible = false
		set_process(false)
