extends Control

@onready var http := $HTTPRequest
var selected_creature : Dictionary
var selected_item_id : int = -1

func _ready():
	# Le bouton d’évolution
	$CanvasLayer/itemEvolvedButton.connect("pressed", Callable(self, "_on_equip_item_pressed"))

func set_creature_data(creature_data: Dictionary):
	selected_creature = creature_data
	$CanvasLayer/Name.text = creature_data["name"]
	$CanvasLayer/Description.text = creature_data["description"]
	$CanvasLayer/Animal.texture = load("res://Textures/Animals/" + creature_data["texture"])
	$CanvasLayer/HPMax.text = "HP: " + str(creature_data["hp"])
	$CanvasLayer/Speed.text = "Vitesse: " + str(creature_data["speed"])
	$CanvasLayer/Element1.text = "Élément 1 : " + str(creature_data["element1"])
	$CanvasLayer/Element2.text = "Élément 2 : " + str(creature_data["element2"])

func _on_equip_item_pressed():
	# Ici, soit tu fais une UI de sélection d'item, soit tu en choisis un par défaut pour le test
	selected_item_id = 9 # EXEMPLE : Plume dorée

	# Appel API pour vérifier l’évolution
	var url = "https://contagioncreaturesapi.vercel.app/api/evolutions"
	var headers = ["Content-Type: application/json"]
	var body = {
		"creature_id": int(selected_creature["id"]),
		"item_id": selected_item_id
	}
	http.request(url, headers, true, HTTPClient.METHOD_POST, JSON.stringify(body))

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var data = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200 and data.has("evolved_creature_id"):
		var evolved_id = int(data["evolved_creature_id"])
		print(" Évolution validée ! Nouvelle créature ID : ", evolved_id)
		mettre_a_jour_inventaire(evolved_id)
	else:
		print(" Aucun résultat d’évolution.")

func mettre_a_jour_inventaire(nouvelle_creature_id: int):
	var inv_path = "user://inventory_creatures.json"
	var file = FileAccess.open(inv_path, FileAccess.READ)
	if file == null:
		print(" Impossible d'ouvrir l'inventaire.")
		return

	var data = JSON.parse_string(file.get_as_text())
	file.close()

	if data == null or !data.has("creatures"):
		print(" Fichier inventaire mal formé.")
		return

	var creatures = data["creatures"]

	for i in range(creatures.size()):
		if int(creatures[i]["id"]) == int(selected_creature["id"]):
			creatures.remove_at(i)
			break

	var db_file = FileAccess.open("res://Constantes/creatures.json", FileAccess.READ)
	var db = JSON.parse_string(db_file.get_as_text())
	db_file.close()

	for creature in db:
		if int(creature["id"]) == nouvelle_creature_id:
			creatures.append(creature)
			break

	data["creatures"] = creatures
	var file_save = FileAccess.open(inv_path, FileAccess.WRITE)
	file_save.store_string(JSON.stringify(data, "\t"))
	file_save.close()

	print(" Inventaire mis à jour.")
	queue_free()



func _on_x_pressed() -> void:
	queue_free()
