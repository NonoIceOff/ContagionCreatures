extends Node2D

var ArrowAttack = 11





	
var texts = {
	0: {
		"text": "Vous avez inflige ... degats au mechant !",
		"has_choices": false,
		"text_choices": ["Oui", "Non"],
		"has_suite": true,
		"choices_jump_to": [0, 0]
	},
	1: {
		"text": "C'est à ... d'attaquer maintenant ",
		"has_choices": false,
		"text_choices": ["Oui", "Non"],
		"has_suite": false,
		"choices_jump_to": [0, 0]
	},
}

func _ready():
	var i = 0
	for keys in Global.actual_animal:
		for key in Global.attacks:
			i += 1
			var button = Button.new()
			button.name = str(key)
			button.position = Vector2(80+300*i,256)
			button.custom_minimum_size = Vector2(280,100)
			add_child(button)
			
			var title = Label.new()
			title.name = "Title"
			title.text = Global.attacks[key]["name"]
			title.custom_minimum_size = Vector2(280,64)
			title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			button.add_child(title)
			
			var value = Label.new()
			value.name = "Value"
			value.text = "ATK "+str(Global.attacks[key]["value"])
			value.position.y = 46
			value.custom_minimum_size = Vector2(280,16)
			value.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			value.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			button.add_child(value)
			
			var boost = Label.new()
			boost.name = "Boost"
			boost.text = str(Global.attacks[key]["boost"])+str("%")
			boost.position = Vector2(250,80)
			boost.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			boost.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			if Global.attacks[key]["boost"] >= 0:
				boost.modulate = Color(0,1,0)
			else:
				boost.modulate = Color(1,0,0)
			button.add_child(boost)
			
			var type = Label.new()
			type.name = "Type"
			type.text = str(Global.attacks[key]["type"][0])
			type.position.y = 65
			type.custom_minimum_size = Vector2(280,16)
			type.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			type.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			if Global.actual_animal[keys]["type"] == Global.attacks[key]["type"]:
				type.modulate = Color(0,1,0)
			else:
				type.modulate = Color(1,0,0)
			button.add_child(type)
			
			var sprite = Sprite2D.new()
			sprite.name = "Sprite"
			sprite.texture = load(Global.attacks[key]["texture"])
			sprite.scale = Vector2(2,2)
			sprite.position = Vector2(135,-30)
			button.add_child(sprite)

func _process(delta):
	for key in Global.attacks:
		if get_node_or_null(str(key)) != null:
			if get_node(str(key)).button_pressed == true:
				take_damage(Global.attacks[key])
				queue_free()

func take_damage(attack):
	get_node("/root/SceneCombat/Button").disabled = true
	get_node("/root/SceneCombat/Button2").disabled = true
	get_node("/root/SceneCombat/Button3").disabled = true
	texts[0]["text"] = "Vous utilisez "+str(attack["name"])+" et vous infligez "+str(attack["value"])+" degats a "+get_node("/root/SceneCombat/ContainerMob/Pseudo").text+"."
	texts[1]["text"] = "C'est a "+get_node("/root/SceneCombat/ContainerMob/Pseudo").text+" d'attaquer maintenant "
	get_node("/root/SceneCombat").spawn_dialogue(texts)
	get_node("/root/SceneCombat").pv_enemy -= attack["value"]
	get_node("/root/SceneCombat/AnimationPlayer").play("Damage_Enemy") 
	await get_node("/root/SceneCombat/AnimationPlayer").animation_finished
	

func _Exit():
	queue_free()
