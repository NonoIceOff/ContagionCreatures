extends Node

# Assurez-vous d'avoir un nœud HTTPRequest dans la scène
@onready var http_request: HTTPRequest = $HTTPRequest

# URL de l'API
const API_URL = "https://contagioncreaturesapi.vercel.app/api/users"  # Remplacez par votre URL d'API

func _ready():
	# Connecte le signal pour gérer la réponse
	http_request.request_completed.connect(_on_request_completed)

	# Effectue la requête GET à l'API
	call_api()

func call_api():
	var error = http_request.request(API_URL, [], HTTPClient.METHOD_GET)
	if error != OK:
		print("Erreur lors de l'envoi de la requête: ", error)
	else:
		print("Requête envoyée à l'API.")

# Gestion de la réponse
func _on_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray):
	if response_code == 200:
		var response_data = body.get_string_from_utf8()
		var json_data = JSON.parse_string(response_data)
		print(json_data[0].username)
	else:
		print("Échec de la requête. Code de réponse: ", response_code)
