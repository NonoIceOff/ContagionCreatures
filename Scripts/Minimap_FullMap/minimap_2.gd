extends Control

# Cache des nodes
@onready var camera = $SubViewportContainer/SubViewport/Camera2D
@onready var animation_player = $AnimationPlayer
@onready var pin_point = $PinPoint
@onready var player_point = $PlayerPoint
@onready var position_label = $Position

# Point jaune dans la miniMap
var pin
var player_node = null

# Constantes
const PIN_SCALE = 0.1
const PIN_MIN_X = 20
const PIN_MIN_Y = 20
const PIN_MAX_X = 212  # 32 + 180
const PIN_MAX_Y = 212  # 32 + 180

func _ready():
	var enter_home = get_node_or_null("/root/map2/Enter_home_Map2")
	if enter_home:
		pin = enter_home.position
	else:
		pin = Vector2.ZERO
	
	# Cache player
	player_node = get_node_or_null("/root/map2/Player_One")
	if not player_node:
		player_node = owner.find_child("Player_One")

	
func _physics_process(delta):
	if not player_node:
		return
	
	# Optimisation : cache position player
	var player_pos = player_node.position
	
	if animation_player:
		animation_player.current_animation = "pin"
	
	camera.position = player_pos
	
	# Optimisation : calcul pin optimisé
	var enter_home = get_node_or_null("/root/map2/Enter_home_Map2")
	if enter_home:
		pin = enter_home.position
	
	if pin_point and player_point:
		var point_pos = pin - player_pos
		# Optimisation : clamp en une seule ligne avec Vector2
		var new_pin_pos = point_pos * PIN_SCALE + player_point.position
		pin_point.position.x = clamp(new_pin_pos.x, PIN_MIN_X, PIN_MAX_X)
		pin_point.position.y = clamp(new_pin_pos.y, PIN_MIN_Y, PIN_MAX_Y)
	
	# Optimisation : mise à jour texte formaté
	if position_label:
		position_label.text = "X: %d  |  Y: %d" % [int(player_pos.x), int(player_pos.y)]

func change_pin(position):
	pin = position
	
func showPoint_miniMap():
	Global.saved_point_position
	
	
