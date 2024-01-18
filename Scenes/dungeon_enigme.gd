extends Node2D

var hud_enabled = true
var item_scene = preload("res://Scenes/item.tscn")
var item_types = ["item","attack"]

var intro_var = true

func intro():
	var visible_text = 0
	var intro_state = 0
	get_node("CanvasLayer/DungeonTitle").visible = true
	get_node("Player_One/2").zoom = Vector2(.4,.4)
	get_node("Player_One/2").position = -get_node("Player_One").position+Vector2(0,350)
	for i in 100:
		visible_text += 0.05
		get_node("Player_One/2").zoom += Vector2(.001,.001)
		get_node("CanvasLayer/DungeonTitle").modulate.a = visible_text
		await get_tree().create_timer(0.1).timeout
	intro_state = 1
	for i in 50:
		visible_text -= 0.1
		get_node("CanvasLayer/DungeonTitle").modulate.a = visible_text
		await get_tree().create_timer(0.1).timeout
	intro_var = false
	
	get_node("Player_One/2").zoom = Vector2(2,2)
	get_node("Player_One/PointLight2D").texture_scale = 5
	get_node("Player_One/PointLight2D").visible = true
	get_node("Player_One/2").position = Vector2(30,35)
	
	
func _ready() -> void:
	Global.brazero_numbers = 0
	intro()

	get_node("/root/DungeonEnigme/CanvasLayer/Transition/AnimationPlayer").play("transition_to_screen")
	await get_tree().create_timer(0.3).timeout
	get_node("Control").visible = true

func _process(delta: float) -> void:
	if get_node("Player_One/PointLight2D").texture_scale > 1 and intro_var == false:
		get_node("Player_One/PointLight2D").texture_scale -= 0.1
	
func spawn_item(pos,type,id):
	var item_instance = item_scene.instantiate()
	item_instance.position = pos
	item_instance.id = id
	item_instance.type = type
	if type == "item":
		item_instance.get_node("Texture").texture = load(Global.items[id]["texture"])
	if type == "attack":
		item_instance.get_node("Texture").texture = load(Global.attacks[id]["texture"])
	add_child(item_instance)
