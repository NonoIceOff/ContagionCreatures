extends Area2D


@onready var global_vars = get_node("/root/Global")
var e_interact = Global.interact

func _process(_delta):
	$Trigger.visible = true
	$Interact.visible = Global.interact


func _on_interact_area_entered(body):
	if body.name == "Player_One":
		Global.interact = true


func _on_interact_area_exited(body):
	if body.name == "Player_One":
		Global.interact = false






