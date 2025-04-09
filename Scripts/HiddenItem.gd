extends Area2D

@export var item_name: String = "Pierre"
@export var item_quantity: int = 1
@onready var shineStar = $".."

var player_in_area = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("Player_One"):
		player_in_area = true
		print("Player entered the area. Press 'E' to pick up the item.")

func _on_body_exited(body):
	if body.is_in_group("Player_One"):
		player_in_area = false

func _process(_delta):
	if player_in_area:
		print("Player in area")
		if player_in_area and Input.is_action_just_pressed("ui_interact"):
			print("key e pressed")
			_add_item_to_inventory()
			queue_free()
			shineStar.queue_free()

func _add_item_to_inventory():
	print("Attempting to add item to inventory")
	if not FileAccess.file_exists("res://Constantes/items.json"):
		print("File does not exist, creating it")
		var file = FileAccess.open("res://Constantes/items.json", FileAccess.WRITE)
		file.store_string("[]")
		file.close()

	var file = FileAccess.open("res://Constantes/items.json", FileAccess.READ_WRITE)
	if file:
		print("File opened successfully")
		var content = file.get_as_text()
		var inventory = JSON.parse_string(content)
		if inventory is Array:
			print("Inventory loaded successfully")
			var item_found = false
			for item in inventory:
				if item["name"] == item_name:
					item["quantity"] = int(item["quantity"]) + item_quantity
					item_found = true
					print("Item found, updated quantity")
					break
			if not item_found:
				print("Item not found, adding new item")
				inventory.append({
					"id": int(inventory.size() + 1),
					"name": item_name,
					"mode": "Ressource",
					"description": "test",
					"texture": "res://Textures/Items/Pierre.png",
					"coef": 1,
					"type": "type",
					"quantity": item_quantity
				})
			
			for item in inventory:
				item["id"] = int(item["id"])
				item["quantity"] = int(item["quantity"])
				item["coef"] = int(item["coef"])

			file.store_string(JSON.stringify(inventory, "\t"))
			file.close()
			print("Item ajouté : " + item_name)
		else:
			print("Erreur : JSON invalide")
	else:
		print("Erreur : Impossible d'ouvrir le fichier items.json")
