extends Node2D

var creatures = []
var boss_hp = 500
var max_boss_hp = 500
var current_turn = 0
var rng = RandomNumberGenerator.new()
var player_turn = Texture


var dialogue_label: Label
var message_timer: Timer


func _load_creatures_data():
	var file = FileAccess.open("res://Constantes/creatures.json", FileAccess.READ)
	if file:
		var json_data = JSON.parse_string(file.get_as_text())
		if json_data is Array:
			creatures = json_data
		else:
			print("Erreur : données JSON invalides.")
	else:
		print("Erreur : impossible d'ouvrir le fichier JSON.")

func _ready() -> void:
	_load_creatures_data()
	MusicsPlayer.play_sound("res://Sounds/music/boss_fight.mp3", "Musics")

	dialogue_label = get_node("Descriptions")

	message_timer = Timer.new()
	message_timer.wait_time = 1.0
	message_timer.one_shot = true
	message_timer.connect("timeout", Callable(self, "_on_message_timeout")) 
	add_child(message_timer)

	var boss = get_node("Mob")
	var boss_hp_bar = get_node("MobProgressBar")
	boss_hp_bar.max_value = max_boss_hp
	boss_hp_bar.value = boss_hp

	var creatures_node = get_node("Players")  

	for i in range(creatures.size()):
		var creature_data = creatures[i]

		var pos_x = 128
		var pos_y = 256 + i * 264  

		var sprite = Sprite2D.new()
		sprite.texture = load(creature_data.get("texture", "res://Textures/spritePlayer/output/right.png"))
		sprite.scale = Vector2(0.5, 0.5)  
		sprite.position = Vector2(pos_x, pos_y)
		creatures_node.add_child(sprite)
		creature_data["sprite"] = sprite  

		var label = Label.new()
		label.text = creature_data["name"]
		label.position = Vector2(pos_x - 50, pos_y - 128)
		label.add_theme_font_size_override("font_size", 24)  
		creatures_node.add_child(label)

		var progress_bar = ProgressBar.new()
		progress_bar.value = creature_data["hp"]
		progress_bar.max_value = creature_data["hp"]
		progress_bar.size = Vector2(200, 20)
		progress_bar.position = Vector2(pos_x - 100, pos_y + 100)  
		creatures_node.add_child(progress_bar)
		creature_data["progress_bar"] = progress_bar

	_create_buttons()

	start_turn()

func _create_buttons():
	var ui = get_node("UI") 
	var attack_button = get_node("Attaque")
	var special_button = get_node("Speciale")

func start_turn():
	if boss_hp <= 0:
		display_message("Le boss est vaincu !")
		win()
		return

	if current_turn >= creatures.size():
		player_turn = false
		enemy_attack()
		return

	if creatures[current_turn]["hp"] <= 0:
		current_turn += 1
		start_turn() 
		return

	player_turn = true
	display_message(creatures[current_turn]["name"] + " doit attaquer !")

func attack(attacker, attack_type):
	var damage = rng.randi_range(10, 30) if attack_type == "normal" else rng.randi_range(30, 50)
	boss_hp -= damage

	display_message(attacker["name"] + " attaque pour " + str(damage) + " dégâts !")

	get_node("MobProgressBar").value = max(boss_hp, 0)

	var boss_sprite = get_node("Mob")
	boss_sprite.modulate = Color(1, 0.5, 0.5)
	await get_tree().create_timer(0.2).timeout
	boss_sprite.modulate = Color(1, 1, 1)

	var progress_bar = attacker["progress_bar"]
	progress_bar.value = max(attacker["hp"], 0)

	message_timer.start()

func display_message(message: String) -> void:
	dialogue_label.text = message

func enemy_attack():
	print("Le boss attaque !")
	var target_index = rng.randi_range(0, creatures.size() - 1)
	var target = creatures[target_index]
	var damage = rng.randi_range(20, 40)

	target["hp"] -= damage
	display_message("Le boss inflige " + str(damage) + " dégâts à " + target["name"] + "!")

	var progress_bar = target["progress_bar"]
	progress_bar.value = max(target["hp"], 0)

	var sprite = target["sprite"]
	sprite.modulate = Color(1, 0.5, 0.5)
	await get_tree().create_timer(0.2).timeout
	sprite.modulate = Color(1, 1, 1)

	current_turn = 0
	player_turn = true
	start_turn()

func _on_message_timeout():
	current_turn += 1
	start_turn()

func win():
	get_node("UI/WIN").visible = true


func _on_attaque_pressed() -> void:
	if player_turn:
		attack(creatures[current_turn], "normal")


func _on_speciale_pressed() -> void:
	if player_turn:
		attack(creatures[current_turn], "special")
