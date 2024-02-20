extends Control

var messages_container

func _ready():
	messages_container = get_node("ScrollContainer/VBoxContainer")

func _on_send_pressed():
	send_message(get_node("MessageEdit").text,PlayerStats.pseudo)
	rpc("send_message", get_node("MessageEdit").text, PlayerStats.pseudo)
	get_node("MessageEdit").text = ""

@rpc("any_peer")
func send_message(message,pseudo):
	var container = Panel.new()
	container.custom_minimum_size = Vector2(480,32)
	messages_container.add_child(container)
	
	var pseudo_text = Label.new()
	pseudo_text.custom_minimum_size = Vector2(96,20)
	pseudo_text.position = Vector2(0,-16)
	pseudo_text.text = pseudo
	container.add_child(pseudo_text)
	
	var message_text = RichTextLabel.new()
	message_text.custom_minimum_size = Vector2(472,30)
	message_text.position = Vector2(8,4)
	message_text.text = "[color=gray][i]"+message
	message_text.bbcode_enabled = true
	container.add_child(message_text)
	
	get_node("ScrollContainer").scroll_vertical = 99999999
	
	
func _input(event):
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("chat"):
			if visible == true:
				visible = false
			elif visible == false:
				visible = true
