extends Node2D

var id = 0
var type = ""

func _process(delta):
	get_node("AnimationPlayer").current_animation = "item"


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player_One") == true:
		print("piked up")
		var size_items = Global.items.size()
		var attacks_items = Global.attacks.size()
		
		if type == "item":
			Global.items[id]["quantity"] += 1
			print("+1 item")
		if type == "attack":
			Global.attacks[id]["quantity"] += 1
			print("+1 attack")
					
		queue_free()
