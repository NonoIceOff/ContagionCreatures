extends Node

func _ready():
	print(" Début du test du Crafting System")

	var craft_manager = load("res://Scripts/CraftsManager.gd").new()
	
	craft_manager.load_player_inventory()
	
	var test_items = ["Collier pierro", "Potion soin"]

	for item_to_craft in test_items:
		print("\n Tentative de craft : " + item_to_craft)
		if craft_manager.craft_item(item_to_craft):
			print(" " + item_to_craft + " a été fabriqué avec succès !")
			craft_manager.save_player_inventory()
		else:
			print(" Impossible de fabriquer " + item_to_craft)

	print("\n Inventaire après test :", craft_manager.player_inventory)
