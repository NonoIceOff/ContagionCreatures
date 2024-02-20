extends Control

@onready var camera = get_node("SubViewportContainer/SubViewport/Camera2D")

var pin
#Point jaune dans la miniMap
# Variable pour stocker la position du point jaune

func _ready():
	pin = get_node("/root/main_map/MobPNJ/Ennemy").position
	
func _physics_process(delta):
	#Mettre à jour l'animation du point jaune.
	get_node("AnimationPlayer").current_animation = "pin"
	#Mettre à jour la position de la caméra pour suivre le joueur.
	camera.position = owner.find_child("Player_One").position
	#Mettre à jour la position du point jaune à la position de l'ennemi dans la carte principale
	pin = get_node("/root/main_map/MobPNJ/Ennemy").position
	#Calculer la position relative du point par rapport à la caméra
	var point_pos = pin - camera.position
	#Mettre à jour la position du point jaune dans la mini-carte
	get_node("PinPoint").position = point_pos *0.1 + get_node("PlayerPoint").position
	
	#Limiter la position du point jaune pour qu'il reste dans les limites de la mini-carte
	if get_node("PinPoint").position.x < 20:
		get_node("PinPoint").position.x = 20
		
	if get_node("PinPoint").position.y < 20:
		get_node("PinPoint").position.y = 20
		
	if get_node("PinPoint").position.x > 32+180:
		get_node("PinPoint").position.x = 32+180
		
	if get_node("PinPoint").position.y > 32+180:
		get_node("PinPoint").position.y = 32+180
		
	get_node("Position").text = "X: "+str(int(get_node("/root/main_map/Player_One").position.x))+"  |  Y: "+str(int(get_node("/root/main_map/Player_One").position.y))

func change_pin(position):
	#Fonction pour changer la position du point jaune
	pin = position
	
