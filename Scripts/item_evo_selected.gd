extends Control

signal item_selected(item_id)

@onready var flow_container := $CanvasLayer/NinePatchRect/Panel/ScrollContainer/FlowContainer
@onready var audio := $AudioStreamPlayer

const ITEM_SLOT_SIZE = Vector2(160, 160)

func set_items(item_list: Array):
	# Nettoyage
	for child in flow_container.get_children():
		child.queue_free()

	for item in item_list:
		var slot = ColorRect.new()
		slot.color = Color(0.1, 0.1, 0.1, 0.1)
		slot.custom_minimum_size = ITEM_SLOT_SIZE
		slot.mouse_filter = Control.MOUSE_FILTER_IGNORE

		var vbox = VBoxContainer.new()
		vbox.anchor_right = 1
		vbox.anchor_bottom = 1
		vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
		vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE

		# Icône
		var icon = Sprite2D.new()
		var texture = load("res://Textures/Items/" + item["texture"])
		icon.texture = texture
		icon.centered = true
		icon.scale = Vector2(0.5, 0.5)
		icon.scale = Vector2(3,3)
		icon.position = Vector2(ITEM_SLOT_SIZE.x / 2, 50)
		
		vbox.add_child(icon)

		# Nom
		var name_label = Label.new()
		name_label.text = item["name"]
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		vbox.add_child(name_label)

		# Quantité
		var quantity_label = Label.new()
		quantity_label.text = "x" + str(item["quantity"])
		quantity_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		quantity_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		quantity_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		vbox.add_child(quantity_label)

		slot.add_child(vbox)

		# Bouton par-dessus tout
		var button = Button.new()
		button.text = ""
		button.flat = true
		button.focus_mode = Control.FOCUS_NONE
		button.mouse_filter = Control.MOUSE_FILTER_STOP
		button.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		button.connect("pressed", Callable(self, "_on_item_pressed").bind(item))
		slot.add_child(button)

		flow_container.add_child(slot)

func _on_item_pressed(item):
	audio.play()
	if typeof(item) != TYPE_DICTIONARY or not item.has("id"):
		push_error("ERREUR: L'item est invalide ou ne contient pas de 'id' : " + str(item))
		return

	emit_signal("item_selected", item["id"])
	_fade_and_close()

func _fade_and_close():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.4).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2(0.8, 0.8), 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(Callable(self, "queue_free"))
