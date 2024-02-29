extends Control

func _on_quit_pressed():
	visible = false

func _on_confirm_code_pressed():

	if get_node("../Patreon").code == Global.patreon_code:
		var time = Time.get_unix_time_from_system()
		Global.patreon_time = time
		Global.patreon_active = true
		get_node("Label").self_modulate = Color(0,1,0)
		get_node("Label").text = "Code valide\nVous debloquez toutes les fonctionnalites premium"
		Global.save_patreon()
	else:
		Global.patreon_active = false
		get_node("Label").self_modulate = Color(1,0,0)
		get_node("Label").text = "Code invalide\nAbonnez-vous au Patreon pour obtenir le code"


func _on_line_edit_text_changed(new_text):
	Global.patreon_code = new_text
