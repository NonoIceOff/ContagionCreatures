extends Node2D

func button_Item():
	queue_free()


	print("Here we go!!")

#{}


	
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
		i += 1
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
		value.text = "Effets "+str(Global.items[key]["effets"])
		value.position.y = 46
		value.custom_minimum_size = Vector2(280,16)
		value.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		value.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		value.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.add_child(value)
	
		
		var sprite = Sprite2D.new()
		sprite.name = "Sprite"
		sprite.texture = load(Global.items[key]["texture"])
		sprite.scale = Vector2(0.25,0.25)
		sprite.position = Vector2(135,-30)
		button.add_child(sprite)

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
	if item["type"][0] == "regen":
		if get_node("/root/SceneCombat").pv_player+item["type"][1] <= 100:
			get_node("/root/SceneCombat").pv_player += item["type"][1]
		else:
			texts[0]["text"] = "Vous ne pouvez pas utiliser "+str(item["name"])+" car vous avez deja suffisemment de vie."
			
	if item["type"][0] == "atk":
		boost(item["type"][1])

	if item["type"][0] == "def":
		boost(item["type"][1])
		
	if item["type"][0] == "antidote":
		infected()
			
	get_node("/root/SceneCombat").spawn_dialogue(texts)
	get_node("/root/SceneCombat").pv_enemy -= item["value"]
	get_node("/root/SceneCombat/AnimationPlayer").play("Damage_Enemy") 
	await get_node("/root/SceneCombat/AnimationPlayer").animation_finished
	
	
func boost(i):
	for key in Global.attacks:
		Global.attacks[key]["value"] *= i
		Global.attacks[key]["boost"] += int(i*100-100)



func infected():
	Global.can_desinfected = false
	Global.is_infected = true
	if get_node("/root/SceneCombat").pv_enemy < 20 and Global.is_infected:
		Global.can_desinfected = true
		Global.canUse_antidote = true
		use_antidote()
		

		

func use_antidote():
	var chance = randi_range(0,100)
	var animal_infected = get_node("/root/SceneCombat/ContainerMob/Creatures/Animal_infected")
	var animal_disinfected = get_node("/root/SceneCombat/ContainerMob/Creatures/Animal_disinfected")
	var button_disabled = get_node("/root/SceneCombat/Node2D/1")
	if get_node_or_null("/root/SceneCombat/ContainerMob/Creatures/Animal_infected") != null:
		if chance < 80:
			
			print("jejejej")
			button_disabled.disabled = true
			
			animal_disinfected.visible = false
			animal_infected.visible = true
			
			animal_infected.queue_free()
			texts[0]["text"] = "Vous utilisez l'antidote!"
			
			
			Global.canUse_antidote = false
			Global.is_infected = false
			
			animal_disinfected.visible = true
			animal_infected.visible = false
			
		else:
			animal_infected.visible = true
			animal_disinfected.visible = false

func _Exit():
	queue_free()
