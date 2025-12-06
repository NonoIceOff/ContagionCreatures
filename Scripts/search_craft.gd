extends LineEdit

@onready var craft_search = $"../CraftsList"

var all_items = []
var all_textures = {}

@onready var craft_manager = CraftTableManager.new()

func _ready():
	if craft_search:
		print("CraftsList trouvé : ", craft_search.name)
	else:
		print("Erreur : CraftsList introuvable")

	await get_tree().create_timer(1.0).timeout

	var item_count = craft_search.get_item_count()
	print("Nombre d'items après délai dans craft_search: ", item_count)

	for i in range(item_count):
		var item_text = craft_search.get_item_text(i)
		var craft = craft_manager.craft_list.get(item_text, null)

		if craft:
			var item_texture_path = craft["texture"]
			if ResourceLoader.exists(item_texture_path):
				var item_texture = ResourceLoader.load(item_texture_path)
				all_textures[item_text] = item_texture
				print("Texture chargée pour l'item : ", item_text)
			else:
				print("Erreur : Texture non trouvée pour l'item : ", item_text)
		
		all_items.append(item_text)
	
	connect("text_changed", Callable(self, "_on_text_changed"))

func _on_text_changed(new_text: String):
	craft_search.clear()
	
	if new_text.length() == 0:
		for item in craft_manager.craft_list.keys():
			var craft = craft_manager.craft_list[item]
			var texture: Texture = null
			if ResourceLoader.exists(craft["texture"]):
				texture = ResourceLoader.load(craft["texture"])
			var item_id = craft_search.add_item(item, texture)
			var category = craft["unlock"]
			var is_unlocked = craft_manager.acces.get(category, false)
			craft_search.set_item_disabled(item_id, not is_unlocked)
	else:
		for item in all_items:
			if new_text.to_lower() in item.to_lower():
				var texture = all_textures.get(item, null)
				var item_id = craft_search.add_item(item, texture)
				var craft = craft_manager.craft_list[item]
				var category = craft["unlock"]
				var is_unlocked = craft_manager.acces.get(category, false)
				craft_search.set_item_disabled(item_id, not is_unlocked)
