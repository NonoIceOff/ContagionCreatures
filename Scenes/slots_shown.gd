extends HBoxContainer

var creatures = []
var http_request: HTTPRequest

func _ready() -> void:
	http_request = HTTPRequest.new()
	add_child(http_request)
	_load_creatures_data()
	for i in creatures.size():
		get_node(str(i+1)+"/Creature").texture = load(creatures[i]["texture"])

func _load_creatures_data():
	var file = FileAccess.open("res://Constantes/creatures.json", FileAccess.READ)
	if file:
		var json_data = JSON.parse_string(file.get_as_text())
		if json_data is Array:
			creatures = json_data
		else:
			print("Erreur : données JSON invalides.")
	else:
		print("Erreur : impossible d'ouvrir le fichier JSON.")
