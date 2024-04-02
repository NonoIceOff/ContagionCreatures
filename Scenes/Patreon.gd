extends Button

var code = ""

func _ready():
	
	var http_request = HTTPRequest.new()
	add_child(http_request)

	http_request.request_completed.connect(_on_request_completed)

	http_request.request("https://pastebin.com/raw/S38j05iv")

func _process(delta):
	if Global.patreon_active == true:
		disabled = true

func int_to_str(code_int):
	var dico = {65:"a",66:"b",67:"c",68:"d",69:"e",70:"f",71:"g",72:"h",73:"i",74:"j",75:"k",76:"l",77:"m",78:"n",79:"o",80:"p",81:"q",82:"r",83:"s",84:"t",85:"u",86:"v",87:"w",88:"x",89:"y",90:"z"};
	return dico[code_int]


func _on_request_completed(result, response_code, headers, body):
	if response_code == 200 and body.size() > 0:
		for i in body:
			code += int_to_str(i)
		print(code)
	else:
		print("Erreur de requête. Code de réponse :", response_code)


func _on_pressed():
	get_node("../CodePatreon").visible = true
