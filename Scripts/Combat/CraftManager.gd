extends Node
class_name CraftManager

func list_craft():
	var acces = {
		"Potion": true,
		"Herboristerie": true
	}
	
	var craft_list = {
		"potion": {
			"ingredients": {
				"herbe": 2,
				"eau": 1
			},
			"unlock": "Potion",
			"result": "potion_soin"
		},
		"potion_mana": {
			"ingredients": {
				"herbe": 1,
				"eau": 2
			},
			"unlock": "Potion",
			"result": "potion_mana"
		},
		"potion_force": {
			"ingredients": {
				"herbe": 1,
				"eau": 1,
				"poussiere": 1
			},
			"unlock": "Potion",
			"result": "potion_force"
		},
		"Herbe Medicinale": {
			"ingredients": {
				"herbe": 1,
				"eau": 1,
				"poussiere": 1,
				"truck" : 2,
				"much" : 3,
				"test" : 4,
				"herbse": 1,
				"eaueze": 1,
				"poussierrzerze": 1,
				"trucezrzerk" : 2,
				"muchdsqd" : 3,
				"tesdqzdqt" : 4,
				"herbereater": 1,
				"earaezratau": 1,
				"psqdqfegoussiere": 1,
				"trudadadadsck" : 2,
				"mucgrgrfh" : 3,
				"tesdazdast" : 4
			},
			"unlock": "Herboristerie",
			"result": "herbe_medicinale"
		},
		"Herbe anti-poison": {
			"ingredients": {
				"herbe": 1,
				"eau": 1,
				"poussiere": 1
			},
			"unlock": "Herboristerie",
			"result": "herbe_anti_poison",
			"common_pourcentage": 0.5,
			"rare_pourcentage": 0.3,
			"epic_pourcentage": 0.2,
			"legendary_pourcentage": 0.1,
			"exotic_pourcentage": 0.05
		}
	}
  
	for craft in craft_list:
		if acces[craft_list[craft]["unlock"]]:
			var ingredients = craft_list[craft]["ingredients"]
			var ingredients_str = ""
			for ingredient in ingredients:
				ingredients_str += str(ingredient) + ": " + str(ingredients[ingredient]) + ", "
			
			# Vérifier et retirer la virgule + espace en fin de chaîne
			if ingredients_str.ends_with(", "):
				ingredients_str = ingredients_str.substr(0, ingredients_str.length() - 2)
			
			print(
				"Craft: " + craft +
				", Ingredients: " + ingredients_str +
				", Result: " + craft_list[craft]["result"]
			)

	return craft_list
