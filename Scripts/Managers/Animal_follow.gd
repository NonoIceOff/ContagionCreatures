extends CharacterBody2D

var joueur
var vitesse = 200
var joueur_found = false

func _ready():
	joueur = get_node_or_null("../../Player_One")
	joueur_found = joueur != null
	if not joueur_found:
		push_error("Joueur introuvable pour Animal_follow")

func _physics_process(delta):
	if joueur_found and joueur: 
		var direction = (joueur.position - position).normalized()
		velocity = direction * vitesse
		move_and_slide()
