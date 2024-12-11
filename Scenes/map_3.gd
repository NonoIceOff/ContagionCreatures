extends Node2D

@onready var transition_scene = $ui/Transition/AnimationPlayer
@onready var soundEffect = $SoundEffectFx
func _ready() -> void:
		
	transition_scene.play("transition_to_screen")
	await get_tree().create_timer(0.3).timeout
	soundEffect.play()


func _process(delta: float) -> void:
	print($TileMap/Player_One.z_index)
	print($TileMap/Player_One.position.y)
	
