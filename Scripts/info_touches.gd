extends Label

func _process(delta: float) -> void:
	var joypads = Input.get_connected_joypads()

	if joypads.size() < 1:
		text = "[TAB] Quêtes
			[ESP] Pause
			[I] Inventaire
			[A] Encyclopédie
			[M] Carte"
	else:
		text = "[R] Quêtes
			[+] Pause
			[L] Inventaire
			[/] Encyclopédie
			[-] Carte"
