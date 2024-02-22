extends Area2D


var entered = false
var Key = false
var pos_replace = Vector2()
var clicked = false
var index = 0

func _ready():
	get_node("Label_E").visible = false
	get_node("PointLight2D").visible = false


func _on_body_entered(body):
	if body.is_in_group("Player_One"):
		pos_replace = Vector2(0,-1)
		entered = true
		get_node("Label_E").visible = true


func _on_body_exited(body):
	if body.is_in_group("Player_One"):
		entered = false
		get_node("Label_E").visible = false

func _process(delta):
	if entered == true and Key == false and clicked == false:
		if Input.is_action_just_pressed("ui_interact"):
			get_node("../FlamesSounds").playing = true
			get_node("PointLight2D").visible = true
			clicked = true
			pos_replace = (position-Vector2(32,0))/64-Vector2(0,1)
			index = pos_replace[0]/2+3
			get_node("../").add_torch(index)
			get_node("../Control/TileMap").set_cell(0, pos_replace, 0, Vector2(8,10), 0)
			get_node("../Control/TileMap").set_cell(1, pos_replace+Vector2(0,-1), 0, Vector2(8,9), 0)
			Global.brazero_numbers += 1
			print(Global.brazero_numbers)
			
			if Global.brazero_numbers == 5:
				if get_node("../").check_torch_order(0) == true:
					get_node("../Control/TileMap").set_cell(0, Vector2(0,3), 0, Vector2(-1,-1), 0)
					get_node("../Control/TileMap").set_cell(1, Vector2(0,3)+Vector2(0,-1), 0, Vector2(-1,-1), 0)
				else:
					Global.brazero_numbers = 0
					get_node("../").reset_torches(0)
			if Global.brazero_numbers == 10:
				if get_node("../").check_torch_order(1) == true:
					get_node("../Control/TileMap").set_cell(0, Vector2(0,11), 0, Vector2(-1,-1), 0)
					get_node("../Control/TileMap").set_cell(1, Vector2(0,11)+Vector2(0,-1), 0, Vector2(-1,-1), 0)
				else:
					Global.brazero_numbers = 5
					get_node("../").reset_torches(1)
			if Global.brazero_numbers == 15:
				if get_node("../").check_torch_order(2) == true:
					get_node("../Control/TileMap").set_cell(0, Vector2(0,19), 0, Vector2(-1,-1), 0)
					get_node("../Control/TileMap").set_cell(1, Vector2(0,19)+Vector2(0,-1), 0, Vector2(-1,-1), 0)
				else:
					Global.brazero_numbers = 10
					get_node("../").reset_torches(2)
			if Global.brazero_numbers == 20:
				if get_node("../").check_torch_order(3) == true:
					get_node("../Control/TileMap").set_cell(0, Vector2(0,27), 0, Vector2(-1,-1), 0)
					get_node("../Control/TileMap").set_cell(1, Vector2(0,27)+Vector2(0,-1), 0, Vector2(-1,-1), 0)
				else:
					Global.brazero_numbers = 15
					get_node("../").reset_torches(3)
				
