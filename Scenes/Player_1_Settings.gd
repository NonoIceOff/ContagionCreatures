extends CharacterBody2D

@export var move_speed: float = 200.0
@onready var anim_player: AnimatedSprite2D = $player1
@onready var raycast: RayCast2D = $player1/RayCast2D

var input_velocity: Vector2 = Vector2.ZERO
var facing_direction: Vector2 = Vector2.DOWN  # Direction par défaut (sud)

# Chargé au démarrage
func _ready():
	# Initialiser la direction du RayCast2D (vers le bas par défaut)
	raycast.target_position = facing_direction * 16  # Ajuster la distance
	raycast.enabled = true

# Gestion de la physique et des mouvements
func _physics_process(delta):
	# Réinitialiser la direction
	input_velocity = Vector2.ZERO

	# Gestion des mouvements en fonction de l'entrée utilisateur
	if Input.is_action_pressed("droite"):
		input_velocity.x += 1
		anim_player.play("EastWalk")
	elif Input.is_action_pressed("gauche"):
		input_velocity.x -= 1
		anim_player.play("WestWalk")
	elif Input.is_action_pressed("haut"):
		input_velocity.y -= 1
		anim_player.play("NorthWalk")
	elif Input.is_action_pressed("bas"):
		input_velocity.y += 1
		anim_player.play("SouthWalk")
	else:
		# Arrêter l'animation si aucune touche n'est pressée
		anim_player.stop()

	# Normaliser et appliquer la vitesse
	if input_velocity.length() > 0:
		input_velocity = input_velocity.normalized() * move_speed

	# Définir la vélocité de CharacterBody2D
	velocity = input_velocity

	# Appliquer le mouvement (utilisation de la vélocité interne)
	move_and_slide()

	# Mettre à jour le RayCast2D pour suivre la direction
	update_raycast()

	# Mettre à jour le Z-index
	update_z_index()

# Mise à jour de la position Z (pour la gestion des couches)
func update_z_index():
	# Le z_index est ajusté en fonction de la position Y du joueur
	# Ici, on fait passer le joueur derrière un objet si sa position Y est plus basse
	z_index = int(position.y)

# Mise à jour du RayCast2D pour suivre la direction du joueur
func update_raycast():
	if raycast:
		raycast.target_position = facing_direction * 16  # Ajuste la longueur du RayCast2D
		raycast.rotation = facing_direction.angle()

# Détection via RayCast2D
func interact_with_environment():
	if raycast and raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider:
			print("Interaction avec :", collider.name)
			# Ajoute ici la logique d'interaction
