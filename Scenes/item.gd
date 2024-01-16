extends Node2D

var id = 0

func _process(delta):
	get_node("AnimationPlayer").current_animation = "item"


func _on_area_2d_body_entered(body):
	print("piked up")
	var size_items = Global.items.size()
	var attacks_items = Global.attacks.size()
	
	if Global.items.has(id):
		Global.items[id]["quantity"] += 1
	else:
		if Global.attacks.has(id-size_items):
			Global.attacks[id-size_items]["quantity"] += 1
				
	queue_free()
