extends CanvasLayer

var tutorials = {
	2: {
		"title":"Deplacez vous avec Z Q S D",
		"icon":"res://Textures/Tuto/movement.png",
		"progress":0
	},
	3: {
		"title":"Interagissez avec quelque chose",
		"icon":"res://Textures/Tuto/interaction.png",
		"progress":0
	},
	4: {
		"title":"Enclenchez un combat",
		"icon":"res://Textures/Tuto/combat.png",
		"progress":0
	},
	5: {
		"title":"Gagnez un combat",
		"icon":"res://Textures/Tuto/trophy.png",
		"progress":0
	},
	6: {
		"title":"Ouvrez le menu des quetes [TAB]",
		"icon":"res://Textures/Tuto/quest.png",
		"progress":0
	},
	7: {
		"title":"Completez au moins une quete",
		"icon":"res://Textures/Tuto/quest_completed.png",
		"progress":0
	},
}

func _ready():
	visible = false

func _process(delta):
	if tutorials.has(Global.tutorial_stade): # Si y'a un tuto
		if tutorials[Global.tutorial_stade]["progress"] >= 100: # S'il est terminé
			visible = false
			Global.tutorial_stade += 1
			get_node("AudioStreamPlayer2D").stream = load("res://Sounds/tuto_completed.mp3")
			get_node("AudioStreamPlayer2D").playing = true
		else:
			visible = true
			get_node("Container/Label").text = tutorials[Global.tutorial_stade]["title"]
			get_node("Container/Icon").texture = load(tutorials[Global.tutorial_stade]["icon"])
			get_node("Container/ProgressBar").value = tutorials[Global.tutorial_stade]["progress"]
