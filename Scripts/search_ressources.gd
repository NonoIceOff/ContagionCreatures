extends LineEdit

@onready var inventory_list = $"../ResourcesList"
var all_items = []
var all_textures = {}

const ITEMS_FILE_PATH = "res://Constantes/items.json"

func _ready():
	if inventory_list:
		print(inventory_list.name)
	else:
		print("Erreur")

	load_inventory_items()
	connect("text_changed", Callable(self, "_on_text_changed"))

func load_inventory_items():
	if not FileAccess.file_exists(ITEMS_FILE_PATH):
		print("Erreur")
		return
	
	var file = FileAccess.open(ITEMS_FILE_PATH, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var parse_result = JSON.parse_string(content)
		
		if parse_result is Array:
			for item in parse_result:
				all_items.append(item)
				if ResourceLoader.exists(item["texture"]):
					var texture = ResourceLoader.load(item["texture"])
					all_textures[item["name"]] = texture
				else:
					print("Texture introuvable")
		else:
			print("Erreur Json")
	else:
		print("Erreur Fichier")

func _on_text_changed(new_text: String):
	inventory_list.clear()
	
	if new_text.length() == 0:
		for item in all_items:
			var texture = all_textures.get(item["name"], null)
			inventory_list.add_item(" x" + str(item["quantity"]), texture)
	else:
		for item in all_items:
			if new_text.to_lower() in item["name"].to_lower():
				var texture = all_textures.get(item["name"], null)
				inventory_list.add_item(" x" + str(item["quantity"]), texture)
