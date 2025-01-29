extends Node2D

const SERVER_URL = "https://contagioncreaturesapi.vercel.app/api/matchmaking"
var user_id = randi() % 10000  # Simuler un ID unique

func _ready():
	print("🔌 Scène Matchmaking chargée.")
	print("👤 ID Joueur :", user_id)
	join_matchmaking()

# 🔹 Rejoindre la file d'attente
func join_matchmaking():
	print("🔎 Tentative d'ajout à la file d'attente...")
	
	var request = HTTPRequest.new()
	add_child(request)
	request.request_completed.connect(self._on_request_completed)

	var body = JSON.stringify({"user_id": user_id, "level": 10})
	request.request(SERVER_URL + "/join", ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)

# 🔹 Vérifier si un match est trouvé
func check_match_status():
	print("📡 Vérification du statut du matchmaking...")

	var request = HTTPRequest.new()
	add_child(request)
	request.request_completed.connect(self._on_status_response)

	request.request(SERVER_URL + "/status/" + str(user_id), [], HTTPClient.METHOD_GET)

# 🔹 Gérer la réponse après avoir rejoint la file d'attente
func _on_request_completed(result, response_code, headers, body):
	print("📩 Réponse reçue après ajout en matchmaking.")

	if response_code == 200:
		print("✅ Ajouté en file d'attente avec succès.")
		await get_tree().create_timer(3).timeout
		print("🔄 Vérification du matchmaking dans 3 secondes...")
		check_match_status()
	else:
		print("❌ Erreur lors de l'ajout en file d'attente ! Code:", response_code)
		print("💬 Message reçu :", body.get_string_from_utf8())

# 🔹 Gérer la réponse du statut de matchmaking
func _on_status_response(result, response_code, headers, body):
	print("📩 Réponse reçue après vérification du statut.")

	if response_code == 200:
		var response = JSON.parse_string(body.get_string_from_utf8())

		if response.match_found:
			print("🎮 MATCH TROUVÉ ! Adversaire ID:", response.opponent_id)
			start_game(response.opponent_id)
		else:
			print("⌛ Toujours en attente d'un adversaire...")
			await get_tree().create_timer(3).timeout
			print("🔄 Relance de la vérification du matchmaking...")
			check_match_status()
	else:
		print("❌ Erreur lors de la vérification du matchmaking ! Code:", response_code)
		print("💬 Message reçu :", body.get_string_from_utf8())

# 🔹 Démarrer le jeu avec l'adversaire
func start_game(opponent_id):
	print("🚀 Début du match contre :", opponent_id)
	# Ici, on peut charger une autre scène ou afficher l'adversaire.
