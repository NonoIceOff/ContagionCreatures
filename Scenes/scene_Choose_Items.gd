extends Node2D



func button_Item():
	queue_free()

	print("Here we go!!")
	
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
	for key in Global.items:
		
		
		var button = Button.new()
		button.name = str(key)
		button.position = Vector2(80+300*i,256)
		button.custom_minimum_size = Vector2(280,160)
		add_child(button)
		
		var title = Label.new()
		title.name = "Title"
		title.text = Global.items[key]["name"]
		title.custom_minimum_size = Vector2(280,64)
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		button.add_child(title)
		
		var value = Label.new()
		value.name = "Value"
		value.text = "Effets :"+str(Global.items[key]["effets"])
		value.position.y = 46
		value.custom_minimum_size = Vector2(280,16)
		value.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		value.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		value.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.add_child(value)
	
		
		var sprite = Sprite2D.new()
		sprite.name = "Sprite"
		sprite.texture = load(Global.items[key]["texture"])
		sprite.scale = Vector2(3,3)
		sprite.position = Vector2(135,-30)
		button.add_child(sprite)
		i += 1
	

func _process(delta):
	for key in Global.items:
		if get_node_or_null(str(key)) != null:
			if get_node(str(key)).button_pressed == true:
				take_damage(Global.items[key])
				queue_free()

func take_damage(item):
	get_node("/root/SceneCombat/Button").disabled = true
	get_node("/root/SceneCombat/Button2").disabled = true
	get_node("/root/SceneCombat/Button3").disabled = true
	texts[0]["text"] = "Vous utilisez "+str(item["name"])+" ce qui vous donne "+str(item["effets"])
	texts[1]["text"] = "C'est a "+get_node("/root/SceneCombat/ContainerMob/Pseudo").text+" d'attaquer maintenant "
	
	# Si c'est des PV à donner
	if item["type"][1] == "regen":
		if get_node("/root/SceneCombat").pv_player+item["type"][0] <= 100:
			get_node("/root/SceneCombat").pv_player += item["type"][0]
		else:
			texts[0]["text"] = "Vous ne pouvez pas utiliser "+str(item["name"])+" car vous avez deja suffisemment de vie."
			
	if item["type"][1] == "atk":
		boost(item["type"][0])

	if item["type"][1] == "def":
		var defense_boost = item["type"][0]  
		reduce_damage(defense_boost)
		
	if item["type"][1] == "antidote":
		infected()
		
	
	get_node("/root/SceneCombat").spawn_dialogue(texts)
	get_node("/root/SceneCombat").pv_enemy -= item["value"]
	get_node("/root/SceneCombat/AnimationPlayer").play("Damage_Enemy") 
	await get_node("/root/SceneCombat/AnimationPlayer").animation_finished
	
func reduce_damage(defense_boost: int):
	get_node("/root/SceneCombat").defense_player += defense_boost
	var reduced_damage = max( Global.enemy_attack - get_node("/root/SceneCombat").defense_player, 0)
	print(reduced_damage)
	return reduced_damage
	

func boost(i: float):
	for key in Global.attacks:
		var new_boost = Global.attacks[key]["value"] * (i - 1)
		Global.attacks[key]["value"] += int(new_boost)
		print("value : " + str(Global.attacks[key]["value"]))
		Global.attacks[key]["boost"] += int(i * 100-100)
		print("boost : " + str(Global.attacks[key]["boost"]))




func infected():
	Global.can_desinfected = false
	Global.is_infected = true
	if get_node("/root/SceneCombat").pv_enemy < 20 and Global.is_infected:
		Global.can_desinfected = true
		Global.canUse_antidote = true
		use_antidote()

func use_antidote():
	var chance = randi_range(0,100)
	for key in Global.animals_enemy:
		if get_node_or_null("/root/SceneCombat").animalE != null:
			
			if chance < 80:
				
				get_node("/root/SceneCombat/Sprite_animal_enemy").texture = load(Global.animals_enemy[0]["textureA"])
				
				texts[0]["text"] = "Vous utilisez l'antidote!"
				
				Global.canUse_antidote = false
				Global.is_infected = false
				
				
				
			else:
				get_node("/root/SceneCombat/Sprite_animal_enemy").texture = load(Global.animals_enemy[0]["texture_infected"])

func _Exit():
	queue_free()
