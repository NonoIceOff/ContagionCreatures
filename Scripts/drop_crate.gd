extends Node

const API_URL = "https://contagioncreaturesapi.vercel.app/api"
@onready var common_item_texture = $Items/CommonItem
@onready var rare_item_texture = $Items/RareItem
@onready var common_item_label = $Items/CommonItemLabel
@onready var rare_item_label = $Items/RareItemLabel
@onready var crate_locked_texture = $Crates/CommonCrate
@onready var crate_gold_locked_texture = $Crates/RareCrate

var crate_opened = false
var items_data = []
var current_item_index = 0
var items_revealed = false
var http_get_creature_drops = HTTPRequest.new()

func _ready():
	common_item_texture.visible = false
	rare_item_texture.visible = false
	common_item_label.visible = false
	rare_item_label.visible = false

	add_child(http_get_creature_drops)
	http_get_creature_drops.connect("request_completed", Callable(self, "_on_creature_drops_received"))
	http_get_creature_drops.request(API_URL + "/creatures/1/drops")


func _input(event):
	if crate_opened and (event.is_action_pressed("Space") or event.is_action_pressed("leftClick")):
		if !items_revealed:
			show_next_item()
		else:
			next_scene()

	elif not crate_opened and (event.is_action_pressed("Space") or event.is_action_pressed("leftClick")):
		if crate_locked_texture.visible and !crate_gold_locked_texture.visible:
			crate_locked_texture.play("BaseOpenCase")
			await get_tree().create_timer(1).timeout  
			crate_opened = true
			open_crate_effect()
		elif !crate_locked_texture.visible and crate_gold_locked_texture.visible:
			crate_gold_locked_texture.play("RareOpenCase")  
			await get_tree().create_timer(1).timeout 
			crate_opened = true
			open_crate_effect()


func open_crate_effect():
	await get_tree().create_timer(0.5).timeout 
	crate_locked_texture.scale = Vector2(4, 4)
	crate_locked_texture.modulate.a = 0.3
	crate_locked_texture.visible = false
	crate_gold_locked_texture.scale = Vector2(4, 4)
	crate_gold_locked_texture.modulate.a = 0.3
	crate_gold_locked_texture.visible = false
	show_first_item()


func show_first_item():
	if items_data.size() > 0:
		common_item_texture.visible = true
		common_item_texture.position = Vector2(980 - (common_item_texture.texture.get_width() * 2) / 2, 540)  
		common_item_texture.scale = Vector2(2, 2)  
		
		common_item_label.visible = true
		common_item_label.text = items_data[0].get("name", "Item")  
		print(items_data[0].get("name", "Item"))
		
		var label_width = common_item_label.get_minimum_size().x
		common_item_label.position = Vector2(
			common_item_texture.position.x + (common_item_texture.texture.get_width() * 2 - label_width) / 2,
			common_item_texture.position.y + common_item_texture.texture.get_height() * 2 + 10
		)

		current_item_index = 0
		animate_item_appearance(common_item_texture, common_item_label, 0)

	if items_data.size() <= 1:
		items_revealed = true


func show_second_item():
	if items_data.size() > 1:
		rare_item_texture.visible = true
		rare_item_texture.position = Vector2(980 - (rare_item_texture.texture.get_width() * 2) / 2, 540)
		rare_item_texture.scale = Vector2(2, 2)
		rare_item_label.visible = true
		rare_item_label.text = items_data[1].get("name", "Item")
		print(items_data[1].get("name", "Item"))
		
		var label_width = rare_item_label.get_minimum_size().x
		rare_item_label.position = Vector2(
			rare_item_texture.position.x + (rare_item_texture.texture.get_width() * 2 - label_width) / 2,
			rare_item_texture.position.y + rare_item_texture.texture.get_height() * 2 + 10
		)

		current_item_index = 1
		animate_item_appearance(rare_item_texture, rare_item_label, 0)

func show_next_item():
	if current_item_index == 0 and items_data.size() > 1:
		common_item_texture.visible = false
		common_item_label.visible = false
		show_second_item()
	else:
		common_item_texture.visible = true
		rare_item_texture.visible = items_data.size() > 1

		common_item_texture.position = Vector2(790 - (common_item_texture.texture.get_width() * 2) / 2, 540)
		rare_item_texture.position = Vector2(1210 - (rare_item_texture.texture.get_width() * 2) / 2, 540)

		common_item_label.position = common_item_texture.position + Vector2(common_item_texture.texture.get_width(), 60)
		rare_item_label.position = rare_item_texture.position + Vector2(rare_item_texture.texture.get_width(), 60)

		common_item_label.visible = true
		rare_item_label.visible = items_data.size() > 1
		
		animate_reveal_items()

		items_revealed = true


func next_scene():
	queue_free()


func _on_creature_drops_received(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print("Result Code:", result)
	print("HTTP Response Code:", response_code)
	var response_text = body.get_string_from_utf8()
	print("Response Body:", response_text)

	if response_code == 200:
		var parse_result = JSON.parse_string(response_text)
		if typeof(parse_result) == TYPE_ARRAY:
			items_data = parse_result
			print("Items Data Received:", items_data)

			if items_data.size() > 1:
				crate_locked_texture.visible = false
				crate_gold_locked_texture.visible = true
			else:
				crate_locked_texture.visible = true
				crate_gold_locked_texture.visible = false

			apply_item_textures()
	else:
		print("Failed to fetch creature drops. HTTP code:", response_code)


func apply_item_textures():
	if items_data.size() > 0:
		var first_item_texture_path = "res://Textures/" + items_data[0].get("texture", "default_texture.png")
		var first_item_texture = load(first_item_texture_path)
		if first_item_texture:
			common_item_texture.texture = first_item_texture

	if items_data.size() > 1:
		var second_item_texture_path = "res://Textures/" + items_data[1].get("texture", "default_texture.png")
		var second_item_texture = load(second_item_texture_path)
		if second_item_texture:
			rare_item_texture.texture = second_item_texture
			
			
#_____________________________________ANIMATION_FUNCTION_________________________________________________

func animate_item_appearance(sprite: Sprite2D, label: Label, delay: float) -> void:
	var tween = get_tree().create_tween()

	# Animation de la texture : Zoom avec rotation
	sprite.scale = Vector2(0, 0)  # Taille initiale
	sprite.rotation = -0.5  # Angle initial (léger)
	sprite.modulate.a = 0  # Transparence initiale

	tween.tween_property(sprite, "scale", Vector2(2, 2), 0.6).set_delay(delay).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "rotation", 0, 0.6).set_delay(delay).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "modulate:a", 1, 0.6).set_delay(delay).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	# Animation du label : Apparition avec léger glissement
	label.position += Vector2(0, 20)  # Position initiale (un peu en bas)
	label.modulate.a = 0  # Transparence initiale

	tween.tween_property(label, "position", label.position - Vector2(0, 20), 0.6).set_delay(delay).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate:a", 1, 0.6).set_delay(delay).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func animate_reveal_items():
	var tween = get_tree().create_tween()

	# Réinitialise les propriétés des items pour l'animation
	common_item_texture.scale = Vector2(0, 0)
	rare_item_texture.scale = Vector2(0, 0)
	common_item_texture.modulate.a = 0
	rare_item_texture.modulate.a = 0
	common_item_label.modulate.a = 0
	rare_item_label.modulate.a = 0

	# Animation de l'item commun
	tween.tween_property(common_item_texture, "scale", Vector2(2, 2), 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(common_item_texture, "modulate:a", 1, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(common_item_texture, "position", Vector2(790 - (common_item_texture.texture.get_width() * 2) / 2, 540), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

	# Animation du label commun
	tween.tween_property(common_item_label, "modulate:a", 1, 0.5).set_delay(0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	if items_data.size() > 1:
		# Décalage pour l'item rare
		tween.tween_property(rare_item_texture, "scale", Vector2(2, 2), 0.5).set_delay(0.3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		tween.tween_property(rare_item_texture, "modulate:a", 1, 0.5).set_delay(0.3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(rare_item_texture, "position", Vector2(1210 - (rare_item_texture.texture.get_width() * 2) / 2, 540), 0.5).set_delay(0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

		# Animation du label rare
		tween.tween_property(rare_item_label, "modulate:a", 1, 0.5).set_delay(0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)


func animate_transition(current_sprite: Sprite2D, current_label: Label, next_sprite: Sprite2D, next_label: Label) -> void:
	var tween = get_tree().create_tween()

	# Animation de sortie de l'item courant
	tween.tween_property(current_sprite, "position", current_sprite.position - Vector2(300, 0), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(current_sprite, "rotation", 0.5, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(current_sprite, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(current_label, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	# Animation d'entrée pour l'item suivant
	next_sprite.position += Vector2(300, 0)  # Déplacement initial
	next_sprite.scale = Vector2(0.5, 0.5)  # Taille initiale réduite
	next_sprite.modulate.a = 0  # Opacité initiale

	tween.tween_property(next_sprite, "position", next_sprite.position - Vector2(300, 0), 0.6).set_delay(0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(next_sprite, "scale", Vector2(2, 2), 0.6).set_delay(0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(next_sprite, "modulate:a", 1, 0.6).set_delay(0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	# Animation du label de l'item suivant
	next_label.position += Vector2(0, 20)  # Position initiale
	next_label.modulate.a = 0  # Transparence initiale

	tween.tween_property(next_label, "position", next_label.position - Vector2(0, 20), 0.6).set_delay(0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(next_label, "modulate:a", 1, 0.6).set_delay(0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func animate_reveal_all():
	var tween = get_tree().create_tween()

	# Déplace les items côte à côte
	tween.tween_property(common_item_texture, "position", Vector2(750 - (common_item_texture.texture.get_width() * 2) / 2, 540), 0.6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(rare_item_texture, "position", Vector2(1170 - (rare_item_texture.texture.get_width() * 2) / 2, 540), 0.6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

	tween.tween_callback(Callable(self, "_shine_effect")).set_delay(0.6)

func _shine_effect():
	var tween = get_tree().create_tween()

	# Simulation d'un éclat lumineux sur les items
	common_item_texture.modulate = Color(1.5, 1.5, 1.5, 1)  # Augmente la luminosité
	rare_item_texture.modulate = Color(1.5, 1.5, 1.5, 1)  # Augmente la luminosité

	tween.tween_property(common_item_texture, "modulate", Color(1, 1, 1, 1), 0.3)
	tween.tween_property(rare_item_texture, "modulate", Color(1, 1, 1, 1), 0.3)
