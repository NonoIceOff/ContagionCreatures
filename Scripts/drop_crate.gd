extends Node

const API_URL = "https://contagioncreaturesapi.vercel.app/api"
const CREATURES_FILE_PATH = "res://Constantes/creatures.json"
@onready var drop_rate_second_item = 5
@onready var common_item_texture = $Items/CommonItem
@onready var rare_item_texture = $Items/RareItem
@onready var crate_locked_texture = $Crates/CommonCrate
@onready var crate_gold_locked_texture = $Crates/RareCrate

var crate_opened = false
var has_second_item = false
var creatures_data = []
var items_data = []
var http_get_creatures = HTTPRequest.new()
var http_get_creature_drops = HTTPRequest.new()

func _ready():
	has_second_item = (randf() * 100) < drop_rate_second_item
	crate_locked_texture.visible = !has_second_item
	crate_gold_locked_texture.visible = has_second_item
	
	add_child(http_get_creatures)
	add_child(http_get_creature_drops)  
	
	var creature_id = randi_range(1, 10)
	_fetch_creature(creature_id)
	_fetch_creature_drops(creature_id)
	creatures_data = _load_local_json()

func _input(event):
	if crate_opened:
		return  
	
	if event.is_action_pressed("Space") or event.is_action_pressed("leftClick"):
		if crate_locked_texture.visible and !crate_gold_locked_texture.visible:
			crate_locked_texture.play("BaseOpenCase")
			await get_tree().create_timer(1).timeout
			crate_opened = true
			open_crate_effect()
		elif !crate_locked_texture.visible and crate_gold_locked_texture.visible:
			crate_gold_locked_texture.play("RareOpenCase")
			await get_tree().create_timer(1).timeout
			crate_opened = true
			open_crate_effect()

func open_crate_effect():
	crate_locked_texture.scale = Vector2(4, 4) 
	crate_locked_texture.modulate.a = 0.3 
	crate_gold_locked_texture.scale = Vector2(4, 4)
	crate_gold_locked_texture.modulate.a = 0.3
	
	show_first_item()

func show_first_item():
	if common_item_texture:
		common_item_texture.visible = true
	
	if has_second_item:
		show_second_item()

func show_second_item():
	if rare_item_texture:
		rare_item_texture.visible = true

func _fetch_creature(creature_id):
	http_get_creatures.request(API_URL + "/creatures/" + str(creature_id))

func _fetch_creature_drops(creature_id):
	http_get_creature_drops.request(API_URL + "/creatures/" + str(creature_id) + "/drops")
	http_get_creature_drops.connect("request_completed", Callable(self, "_on_http_request_completed"))

func _on_http_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var data = JSON.parse_string(body.get_string_from_utf8())
		if data == null:
			print("Erreur dans la réponse de l'API.")
			return
		
		if "creature" in data:
			creatures_data = data["creature"]
			print("Données de créature chargées :", creatures_data)
		elif "drops" in data:
			items_data = data["drops"]
			print("Données des items (drops) chargées :", items_data)
			apply_item_textures() 


func apply_item_textures():
	#for item in items_data:
		#var texture_path = "res://Textures/" + item["texture"]  
		#var texture = load(texture_path)
		
		if items_data.size() > 0:
			var first_item_texture_path = "res://Textures/" + items_data[0]["texture"]
			var first_item_texture = load(first_item_texture_path)
			if first_item_texture and common_item_texture:
				common_item_texture.texture = first_item_texture
				common_item_texture.visible = true
		
		if has_second_item and items_data.size() > 1:
			var second_item_texture_path = "res://Textures/" + items_data[1]["texture"]
			var second_item_texture = load(second_item_texture_path)
			if second_item_texture and rare_item_texture:
				rare_item_texture.texture = second_item_texture
				rare_item_texture.visible = true

func _load_local_json():
	var json_as_text = FileAccess.get_file_as_string(CREATURES_FILE_PATH)
	var parse_result = JSON.parse_string(json_as_text)
	if parse_result == null:
		print("Erreur lors du chargement du fichier JSON local.")
		return []
	print("Type de données JSON correct pour le fichier local.")
	return parse_result
