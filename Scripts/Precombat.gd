extends Node2D

signal precombat_finished

const API_URL = "https://contagioncreaturesapi.vercel.app/api/creatures"
const CREATURES_FILE_PATH = "res://Constantes/creatures.json"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_transition = $CanvasLayer/Transition/AnimationPlayer
@onready var http_get_creatures_player = $GetCreaturesPlayer
@onready var player_sprite_1: Sprite2D = $Creature1
@onready var player_sprite_2: Sprite2D = $Creature2
@onready var player_sprite_3: Sprite2D = $Creature3

var creatures_data = []

func _load_local_json():
	var json_as_text = FileAccess.get_file_as_string(CREATURES_FILE_PATH)
	var parse_result = JSON.parse_string(json_as_text)
	print(parse_result)
	if parse_result == null:
		print("Erreur lors du chargement du fichier JSON local.")
	else:
		print("Type de données JSON correct pour le fichier local.")
	print(parse_result[0].name)
	if parse_result == null:
		print("Erreur lors du chargement du fichier JSON local.")
		return []
	return parse_result
	
func initialize(player_creatures):
	if player_creatures.size() > 0:
		if !player_sprite_1.texture:
			player_sprite_1.texture = load(player_creatures[0]["texture"])
			print(player_sprite_1)
		else:
			print("Texture not found for Creature1:", player_creatures[0]["texture"])

	if player_creatures.size() > 0:
		if !player_sprite_2.texture:
			player_sprite_2.texture = load(player_creatures[1]["texture"])
			print(player_creatures[1]["texture"])
			print(player_sprite_2)
		else:
			print("Texture not found for Creature2:", player_creatures[1]["texture"])

	if player_creatures.size() > 0:
		if !player_sprite_3.texture:
			player_sprite_3.texture = load(player_creatures[2]["texture"])
			print(player_sprite_3)
		else:
			print("Texture not found for Creature3:", player_creatures[2]["texture"])

	# Hide any sprites without assigned textures
	if player_creatures.size() < 3:
		player_sprite_3.visible = false
	if player_creatures.size() < 2:
		player_sprite_2.visible = false


func _ready():
	print("hello combat")
	creatures_data = _load_local_json()
	initialize(creatures_data)
	animation_player.play('precombat_animation')
	animation_player.connect("animation_finished", Callable(self, "_on_precombat_animation_finished"))


func _process(delta):
	pass

func _on_precombat_animation_finished(anim_name):
	animation_transition.play('screen_to_transition')
	await get_tree().create_timer(4).timeout
	get_tree().change_scene_to_file("res://Scenes/scène_combat.tscn")


func _on_get_creatures_player_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response_text = body.get_string_from_utf8()
	var parse_result = JSON.parse_string(response_text)
	creatures_data = parse_result
	print(creatures_data)
