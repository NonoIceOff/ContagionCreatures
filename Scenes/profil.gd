extends Node2D

# HTTPRequest node
@onready var http_request: HTTPRequest = $HTTPRequest
@onready var http_request_get_user: HTTPRequest = $GetUser

# Email et password LineEdit fields (Remplacez par les chemins corrects vers vos champs dans la scène)
@onready var l_email_field: LineEdit = get_node("LoginPanel/EmailField")
@onready var l_password_field: LineEdit = get_node("LoginPanel/PasswordField")

@onready var r_email_field: LineEdit = get_node("RegisterPanel/EmailField")
@onready var r_password_field: LineEdit = get_node("RegisterPanel/PasswordField")
@onready var r_username_field: LineEdit = get_node("RegisterPanel/UsernameField")

# API URLs
const REGISTER_URL = "https://contagioncreaturesapi.vercel.app/api/users/register"
const LOGIN_URL = "https://contagioncreaturesapi.vercel.app/api/users/login"

func _init() -> void:
	Global.load_user()
	
	
# Gestion de l'initialisation
func _ready() -> void:
	if Global.user != {}:
		get_node("Panel/username").text = str(Global.user.username)
		get_node("Panel/money").text = str(Global.user.money)+" coins"
		get_node("Panel/points").text = str(Global.user.points)+" points"
		
	# Connecte le signal de réponse de HTTPRequest
	http_request.request_completed.connect(_on_request_completed)


func login():
	var email = l_email_field.text.strip_edges()
	var password = l_password_field.text.strip_edges()
	
	if email == "" or password == "":
		print("L'email et le mot de passe ne peuvent pas être vides.")
		return

	var login_data = {
		"email": email,
		"password": password
	}
	
	# Affiche les données de login pour débogage
	print("Données de connexion:", login_data)

	# Envoie la requête POST à l'API de login avec l'en-tête Content-Type pour JSON
	var headers = ["Content-Type: application/json"]
	var error = http_request.request(LOGIN_URL, headers, HTTPClient.METHOD_POST, JSON.stringify(login_data))
	if error != OK:
		print("Erreur lors de la requête de login:", error)
	
func register():
	var email = r_email_field.text.strip_edges()
	var password = r_password_field.text.strip_edges()
	var username = r_username_field.text.strip_edges()  # Récupère le texte du champ de nom d'utilisateur

	if email == "" or password == "" or username == "":
		print("L'email, le nom d'utilisateur et le mot de passe ne peuvent pas être vides.")
		return

	var register_data = {
		"username": username,
		"email": email,
		"password": password
	}

	# Affiche les données d'inscription pour débogage
	print("Données d'inscription:", register_data)

	# Envoie la requête POST à l'API d'inscription avec l'en-tête Content-Type pour JSON
	var headers = ["Content-Type: application/json"]
	var error = http_request.request(REGISTER_URL, headers, HTTPClient.METHOD_POST, JSON.stringify(register_data))
	if error != OK:
		print("Erreur lors de la requête d'inscription:", error)

# Fonction pour gérer le bouton de login
func _on_login_pressed() -> void:
	get_node("LoginPanel").visible = true
	

# Fonction pour gérer le bouton d'inscription
func _on_register_pressed() -> void:
	get_node("RegisterPanel").visible = true
	

# Gestion de la réponse de la requête HTTP
func _on_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray):
	print("Connexion.....")
	var response_text = body.get_string_from_utf8()
	print("Réponse de la requête:", response_text)

	var json_data = JSON.parse_string(response_text)
	if response_code == 200:
		http_request_get_user.request("https://contagioncreaturesapi.vercel.app/api/users/"+str(json_data.user.id), [], HTTPClient.METHOD_GET)
	else:
		print("error")


func _on_get_user_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print("Récupération de l'utilisateur")
	var response_text = body.get_string_from_utf8()
	print("Réponse de la requête:", response_text)

	var json_data = JSON.parse_string(response_text)
	if response_code == 200:
		Global.user = json_data
		get_node("Panel/username").text = str(Global.user.username)
		get_node("Panel/money").text = str(Global.user.money)+" coins"
		get_node("Panel/points").text = str(Global.user.points)+" points"
		get_node("Waiting").visible = false
		Global.save_user()
		return
	else:
		print("error")
		get_node("Waiting").visible = false


func _on_disconnect_pressed() -> void:
	Global.user = {}
	get_node("Panel/username").text = "Pas connecte"
	get_node("Panel/money").text = "-"
	get_node("Panel/points").text = "-"
	Global.save_user()


func _on_validate_login_pressed() -> void:
	login()
	get_node("Waiting").visible = true
	get_node("LoginPanel").visible = false


func _on_validate_register_pressed() -> void:
	register()
	get_node("Waiting").visible = true
	get_node("RegisterPanel").visible = false


func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")