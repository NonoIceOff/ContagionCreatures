extends Node2D

@onready var interact_label = $TableCraftNode2D/TileMapLayer/craftTableArea2D/Interact
@onready var craft_menu = get_node("../Control/Player_One/player1/2/CanvasLayer/GameUI/PopupMenu/CraftMenuScreenContainer")

var can_interact = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if can_interact == true:
		if Input.is_action_just_pressed("ui_interact"):
			load_game_ui_scene()
			Engine.time_scale = 0
			Global.can_move = false

func _on_craft_table_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player_One"):
		interact_label.visible = true
		can_interact = true
		

func _on_craft_table_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player_One"):
		interact_label.visible = false
		can_interact = false

func load_game_ui_scene() -> void:
	craft_menu.visible = true
