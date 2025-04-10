extends Node2D

@onready var http := $HTTPRequest
var path_inventory := "res://Constantes/creatures.json"
var creature_id := 1
var item_id := 5

func _ready():
	verifier_evolution(creature_id, item_id)

func verifier_evolution(creature_id: int, item_id: int) -> void:
	var url = "https://contagioncreaturesapi.vercel.app/api/evolutions"
	var headers = ["Content-Type: application/json"]
	var body = {
		"creature_id": creature_id,
		"item_id": item_id
	}
	http.request(url, headers, true, HTTPClient.METHOD_POST, JSON.stringify(body))

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var data = JSON.parse_string(body.get_string_from_utf8())

	if response_code == 200 and data.has("evolved_creature_id"):
		var new_id = data["evolved_creature_id"]
		print(" Évolution vers ID :", new_id)
		remplacer_creature(creature_id, new_id)
		SceneLoader.load_scene("res://Scenes/scene_evo.tscn")
	else:
		print(" Pas d'évolution possible.")

func remplacer_creature(ancienne_id: int, nouvelle_id: int) -> void:
	var file = FileAccess.open(path_inventory, FileAccess.READ)
	if file == null:
		print(" Inventaire introuvable.")
		return
	
	var content = file.get_as_text()
	file.close()

	var inventory = JSON.parse_string(content)
	if inventory == null or !inventory.has("creatures"):
		print(" Inventaire invalide.")
		return

	var creatures = inventory["creatures"]
	var nouvelle_creature = get_creature_info_par_id(nouvelle_id)

	for i in range(creatures.size()):
		if creatures[i]["id"] == ancienne_id:
			creatures.remove_at(i)
			break

	var deja_present = false
	for cr in creatures:
		if cr["id"] == nouvelle_id:
			deja_present = true
			break
	
	if not deja_present:
		creatures.append({
			"id": nouvelle_creature["id"],
			"name": nouvelle_creature["name"]
		})

	# Sauvegarde
	inventory["creatures"] = creatures
	var file_save = FileAccess.open(path_inventory, FileAccess.WRITE)
	file_save.store_string(JSON.stringify(inventory, "\t"))
	file_save.close()

	print("📦 Inventaire mis à jour : ", creatures)

func get_creature_info_par_id(id: int) -> Dictionary:
	# Cette fonction devrait charger un JSON (ex: creatures_db.json) ou une ressource
	# Pour l'exemple, on va simuler :
	var db = {
		5: { "id": 5, "name": "Bambourin" },
		1: { "id": 1, "name": "Wudong" }
	}
	return db.get(id, { "id": id, "name": "Inconnu" })
