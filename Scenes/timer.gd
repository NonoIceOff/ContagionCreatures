extends RichTextLabel

var time_left : float = 60.0

func _process(delta: float) -> void:
	if visible == true:
		time_left -= delta
		var minutes = int(time_left) / 60
		var seconds = int(time_left) % 60

		# Formatage du temps
		var time_text = "%02d:%02d" % [minutes, seconds]

		# Affichage avec effet de shake
		text = "[shake rate="+str(seconds)+" level=30 connected=1]" + time_text

		# Arrêter le compte à rebours à 00:00
		if time_left <= 0:
			time_left = 0
