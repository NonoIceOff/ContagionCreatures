extends Node2D
@onready var http_request_get_item = $getItem
var player_items = []  

const API_ITEMS_URL = "https://contagioncreaturesapi.vercel.app/api/items"
const ITEMS_FILE_PATH = "res://Constantes/items.json"

func _ready():
	http_request_get_item.request(API_ITEMS_URL)  

func _on_get_item_request_completed(result, response_code, headers, body):
	print("Node")
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var parse_result = JSON.parse_string(response_text)
		if parse_result:
			player_items = parse_result
			print("Items récupérés : ", player_items)
		else:
			print("Erreur : Réponse API invalide")
	else:
		print("Erreur HTTP : Code ", response_code)
