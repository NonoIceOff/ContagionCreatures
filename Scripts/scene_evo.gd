extends Node2D

@onready var pre_evo_sprite := $CanvasLayer/creaturePreEvo
@onready var post_evo_sprite := $CanvasLayer/creaturePostEvo
@onready var animation_player := $CanvasLayer/AnimationPlayer


func start_evolution(pre_texture_path: String, post_texture_path: String):
	pre_evo_sprite.texture = load(pre_texture_path)
	post_evo_sprite.texture = load(post_texture_path)	
	
func _ready():
	animation_player.play("evolution")
	MusicsPlayer.play_sound("res://Sounds/combat_music.mp3", "Player")

func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name == "evolution":
		queue_free()
