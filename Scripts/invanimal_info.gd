extends Control

@onready var http := $HTTPRequest
var selected_creature : Dictionary
var selected_item_id : int = -1
var selected_item_name: String = ""
var inv_path = "res://Constantes/items.json"

func _ready():
	$CanvasLayer/itemEvolvedButton.connect("pressed", Callable(self, "_on_equip_item_pressed"))
	http.connect("request_completed", Callable(self, "_on_HTTPRequest_request_completed"))

func set_creature_data(creature_data: Dictionary):
	selected_creature = creature_data
	$CanvasLayer/Name.text = creature_data["name"]
	$CanvasLayer/Description.text = creature_data["description"]
	$CanvasLayer/Animal.texture = load("res://Textures/Animals/" + creature_data["texture"])
	$CanvasLayer/HPMax.text = "HP: " + str(creature_data["hp"])
	$CanvasLayer/Speed.text = "Vitesse: " + str(creature_data["speed"])
	$CanvasLayer/Element1.text = "Élément 1 : " + str(creature_data["element1"])
	$CanvasLayer/Element2.text = "Élément 2 : " + str(creature_data["element2"])
	
	if FileAccess.file_exists(inv_path):
		var file = FileAccess.open(inv_path, FileAccess.READ)
		var inv_data = JSON.parse_string(file.get_as_text())
		file.close()

		if typeof(inv_data) == TYPE_ARRAY:
			var owned = false
			for c in inv_data:
				if int(c["id"]) == int(creature_data["id"]):
					owned = true
					break

			$CanvasLayer/itemEvolvedButton.visible = owned
		else:
			print(" Fichier d'inventaire mal formé.")
			$CanvasLayer/itemEvolvedButton.visible = false
	else:
		print(" Aucun fichier d’inventaire trouvé.")
		$CanvasLayer/itemEvolvedButton.visible = false

func _on_equip_item_pressed():
	$AudioStreamPlayer.play()
	var item_popup = load("res://Scenes/itemEvoSelected.tscn").instantiate()
	add_child(item_popup)
	item_popup.set_items(get_player_items())
	item_popup.connect("item_selected", Callable(self, "_on_item_selected"))

func _on_item_selected(item_id: int):
	selected_item_id = item_id
	
	for item in get_player_items():
		if int(item["id"] == selected_item_id):
			selected_item_name = item["name"]
			break
	
	var url = "https://contagioncreaturesapi.vercel.app/api/evolutions"
	http.request(url, [], HTTPClient.METHOD_GET)
	print(" Recherche d'évolution pour la créature :", selected_creature["name"])
	print("Request")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code != 200:
		print(" Erreur serveur :", response_code)
		return

	var evolutions = JSON.parse_string(body.get_string_from_utf8())
	if typeof(evolutions) != TYPE_ARRAY:
		print(" Format d'évolution incorrect :", evolutions)
		return

	var matched_evolution = null
	for evo in evolutions:
		if int(evo["initial_creature_id"]) == int(selected_creature["id"]):
			matched_evolution = evo
			break

	if matched_evolution == null:
		print(" Aucune évolution trouvée pour :", selected_creature["name"])
		return

	var required_item_name = matched_evolution["neededItem"]["name"]
	print(" Item requis :", required_item_name, "| Item sélectionné :", selected_item_name)
	if required_item_name != selected_item_name:
		print(" Mauvais item sélectionné.")
		return

	updateCreaturesInventory(matched_evolution)
	consume_item(selected_item_name)

func get_evolution_id_for_creature(creature_id: int) -> int:
	if typeof(selected_creature) != TYPE_DICTIONARY:
		print(" selected_creature n’est pas un dictionnaire :", selected_creature)
		return -1
	
	if selected_creature.has("id_evolutions_creatures_initial_creature_id"):
		print("ID d'évolution trouvé :", selected_creature["id_evolutions_creatures_initial_creature_id"])
		return int(selected_creature["id_evolutions_creatures_initial_creature_id"])
	else:
		print(" Pas de champ 'id_evolutions_creatures_initial_creature_id' dans cette créature.")
		return -1

func get_player_items() -> Array:
	
	var file = FileAccess.open(inv_path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	return data
	
func updateCreaturesInventory(creature_data: Dictionary):
	var path = "res://Constantes/creatures.json"
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		print("Impossible d'ouvrir l'inventaire.")
		return
	
	var content = file.get_as_text()
	file.close()

	var data = JSON.parse_string(content)
	if data == null:
		print("Erreur lors de l'analyse du fichier JSON.")
		return

	var creatures = data
	var creature_updated = false
	for i in range(creatures.size()):
		if int(creatures[i]["id"]) == int(selected_creature["id"]):
			creatures[i] = {
				"id": int(creature_data["id"]),
				"name": creature_data["name"],
				"description": creature_data["description"],
				"texture": creature_data["texture"],
				"hp": int(creature_data["hp"]),
				"speed": creature_data["speed"],
				"element1": creature_data["element1"],
				"element2": creature_data["element2"],
				"type": creature_data["type"],
				"is_infected": creature_data["is_infected"],
				"texture_back": creature_data["texture_backward"]
			}
			creature_updated = true
			break

	if creature_updated:
		var save_file = FileAccess.open(path, FileAccess.WRITE)
		save_file.store_string(JSON.stringify(creatures, "\t"))
		save_file.close()

		print("Inventaire mis à jour avec :", creature_data["name"])
		queue_free()
	else:
		print("Aucune créature trouvée à remplacer.")

func consume_item(item_name: String):
	var path = "res://Constantes/items.json"
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		print(" Impossible d'ouvrir l'inventaire d'items.")
		return

	var items_data = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(items_data) != TYPE_ARRAY:
		print(" Fichier items.json mal formé.")
		return

	for item in items_data:
		if item["name"] == item_name:
			if item.has("quantity") and item["quantity"] > 0:
				item["quantity"] -= 1
				print(" Item consommé :", item_name, "| Nouvelle quantité :", item["quantity"])
			else:
				print(" Plus d'exemplaire de :", item_name)
			break

	var file_save = FileAccess.open(path, FileAccess.WRITE)
	file_save.store_string(JSON.stringify(items_data, "\t"))
	file_save.close()

func _on_x_pressed() -> void:
	$AudioStreamPlayerback.play()
	queue_free()
