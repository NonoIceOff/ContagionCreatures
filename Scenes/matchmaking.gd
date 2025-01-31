extends Node2D

const SERVER_URL = "https://contagioncreaturesapi.vercel.app/api/matchmaking"

var user_id = randi() % 10000
var match_id = ""
var question_id = 0
var current_question = ""
var correct_answer = ""

func _ready():
	print("🔌 Scène Matchmaking chargée.")
	print("👤 ID Joueur :", user_id)
	join_matchmaking()

func join_matchmaking():
	print("🔎 Tentative d'ajout à la file d'attente avec user_id:", user_id)
	var request = HTTPRequest.new()
	add_child(request)
	request.request_completed.connect(_on_request_completed.bind(request))
	var body = JSON.stringify({"user_id": user_id, "level": 10})
	request.request(SERVER_URL + "/join", ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)

func check_match_status():
	print("📡 Vérification du statut du matchmaking...")
	var request = HTTPRequest.new()
	add_child(request)
	request.request_completed.connect(_on_status_response.bind(request))
	request.request(SERVER_URL + "/status/" + str(user_id), [], HTTPClient.METHOD_GET)

func _on_request_completed(result, response_code, headers, body, request):
	request.queue_free()
	print("📩 Réponse reçue après ajout en matchmaking. Code:", response_code)
	if response_code == 200:
		await get_tree().create_timer(3).timeout
		check_match_status()
	else:
		print("❌ Erreur lors de l'ajout en matchmaking :", body.get_string_from_utf8())

func _on_status_response(result, response_code, headers, body, request):
	request.queue_free()
	print("📩 Réponse reçue après vérification du statut. Code:", response_code)
	if response_code == 200:
		var response = JSON.parse_string(body.get_string_from_utf8())
		if response and response.match_found:
			print("🎮 MATCH TROUVÉ ! Adversaire ID:", response.opponent_id)
			question_id = response.question_id
			start_game(response.opponent_id)
		else:
			await get_tree().create_timer(3).timeout
			check_match_status()

func start_game(opponent_id):
	print("🚀 Début du match contre :", opponent_id)
	get_node("LoadingText").visible = false
	get_node("MatchFounded").visible = false
	get_node("QuestionLabel").visible = true
	get_node("AnswerInput").visible = true
	fetch_question()

func fetch_question():
	var request = HTTPRequest.new()
	add_child(request)
	request.request_completed.connect(_on_question_received.bind(request))
	request.request(SERVER_URL + "/question/" + str(question_id), [], HTTPClient.METHOD_GET)


func _on_question_received(result, response_code, headers, body, request):
	request.queue_free()
	print("📩 Réponse reçue pour la question. Code:", response_code)
	if response_code == 200:
		var response = JSON.parse_string(body.get_string_from_utf8())
		if response and response.id == question_id:
			current_question = response.question
			correct_answer = response.answer
			display_question()

func display_question():
	get_node("QuestionLabel").text = "❓ " + current_question
	await get_tree().create_timer(10).timeout
	get_node("QuestionLabel").text += "\n\n✅ Réponse : " + correct_answer
	await get_tree().create_timer(10).timeout
	get_tree().change_scene_to_file("res://Scenes/scène_combat_multi.tscn")
