extends CharacterBody2D

var joueur
var vitesse = 200

func _ready():
	joueur = get_node("../../Player_One")

func _physics_process(delta):
	if joueur : 
		var direction = (joueur.position - position).normalized()
		velocity = direction * vitesse
		move_and_slide()
	else: 
		print ("introuvable")
