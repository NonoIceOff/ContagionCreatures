extends Control

signal item_selected(item_id)

@onready var buttons_container := $CanvasLayer/Panel/VBoxContainer/ItemButtonsContainer

func set_items(item_list: Array):
	for child in buttons_container.get_children():
		child.queue_free()

	for item in item_list:
		var btn = Button.new()
		btn.icon = load(item["texture"])
		btn.text = item["name"] + " x" + str(item["quantity"])
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.connect("pressed", Callable(self, "_on_item_pressed").bind(item))
		buttons_container.add_child(btn)

func _on_item_pressed(item):
	if typeof(item) != TYPE_DICTIONARY or not item.has("id"):
		push_error(" ERREUR: L'item est invalide ou ne contient pas de 'id' : " + str(item))
		return

	emit_signal("item_selected", item["id"])
	queue_free()
