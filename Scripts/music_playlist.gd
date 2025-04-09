extends Control

@onready var musics_list = $ScrollContainer/VBoxContainer
@onready var audio_player = $AudioStreamPlayer2D
@onready var progress_bar = $ProgressBar
@onready var actual_time_label = $ActualTime
@onready var max_time_label = $MaxTime
@onready var pause_button = $Pause

var musics = [
	{"title":"Combat 1", "description":"une description banale", "file":"res://Sounds/music/combat_1.mp3"},
	{"title":"Combat 2", "description":"une description banale", "file":"res://Sounds/music/combat_2.mp3"},
	{"title":"Combat 3", "description":"une description banale", "file":"res://Sounds/music/combat_3.mp3"},
	{"title":"Credits", "description":"une description banale", "file":"res://Sounds/music/credits.mp3"},
	{"title":"Menu Principal", "description":"une description banale", "file":"res://Sounds/music/main_menu.mp3"},
	{"title":"Menu Multijoueur", "description":"une description banale", "file":"res://Sounds/music/multiplayer_menu.mp3"},
	{"title":"Donjons 1", "description":"une description banale", "file":"res://Sounds/music/dungeons.ogg"},
	{"title":"Combat Music", "description":"une description banale", "file":"res://Sounds/combat_music.mp3"},
	{"title":"Dungeon Sound", "description":"une description banale", "file":"res://Sounds/dungeon_sound.mp3"},
	{"title":"Lens - Bobby Richards", "description":"une description banale", "file":"res://Sounds/Lens - Bobby Richards.mp3"},
	{"title":"Music Debut", "description":"une description banale", "file":"res://Sounds/music_debut.mp3"},
	{"title":"Puzzles 2", "description":"une description banale", "file":"res://Sounds/Puzzles_2.mp3"},
	{"title":"Reversed Dungeon Sound", "description":"une description banale", "file":"res://Sounds/reversed_dungeon_sound.mp3"},
	{"title":"Start Cinematic Dark Music", "description":"une description banale", "file":"res://Sounds/start_cinematic_dark_music.mp3"},
	{"title":"Victory", "description":"une description banale", "file":"res://Sounds/victory.mp3"}
];


# Appelée lors de l'entrée dans la scène
func _ready() -> void:
	for i in musics:
		var box = Button.new()
		box.name = "Box_" + str(i)
		box.add_to_group("buttons")
		box.custom_minimum_size = Vector2(564, 128)
		
		var title = Label.new()
		title.text = str(i["title"])
		title.add_theme_font_size_override("font_size", 48)
		title.position = Vector2(8, 4)
		box.add_child(title)
		
		var description = Label.new()
		description.text = str(i["description"])
		description.add_theme_font_size_override("font_size", 24)
		description.position = Vector2(8, 48)
		box.add_child(description)
		
		# Utilise un Callable pour passer les données à la fonction de rappel
		box.connect("pressed", Callable(self, "_on_music_button_pressed").bind(i))
		musics_list.add_child(box)

# Fonction de rappel pour gérer la sélection de musique
func _on_music_button_pressed(music_data: Dictionary) -> void:
	audio_player.stream = load(music_data["file"])
	audio_player.play()
	pause_button.text = "II"  # Met le bouton en mode pause par défaut

# Appelée à chaque frame pour mettre à jour la barre de progression et les labels de temps
func _process(delta: float) -> void:
	progress_bar.max_value = audio_player.stream.get_length()
	progress_bar.value = audio_player.get_playback_position()

	# Convertit le temps actuel et maximum en format mm:ss
	var current_time = audio_player.get_playback_position()
	var max_time = audio_player.stream.get_length()
	
	actual_time_label.text = "%02d:%02d" % [int(current_time / 60), int(current_time) % 60]
	max_time_label.text = "%02d:%02d" % [int(max_time / 60), int(max_time) % 60]

# Gère la pause et la reprise de la musique
func _on_pause_pressed() -> void:
	audio_player.stream_paused = !audio_player.stream_paused
	pause_button.text = "II" if !audio_player.stream_paused else ">"


func _on_tree_entered() -> void:
	Global.selected_index = 0


func _on_retour_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
