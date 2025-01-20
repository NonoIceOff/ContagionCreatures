extends Sprite2D

var perso_id = PlayerStats.character
var idle = [Vector2(16 , 0),Vector2(64, 0),Vector2(64+48, 0),Vector2(64+48+48, 0),
			Vector2(16 , 64),Vector2(64, 64),Vector2(64+48, 64),Vector2(64+48+48, 64),]


func _process(delta):
	perso_id = PlayerStats.character
	region_rect = Rect2(idle[perso_id][0],idle[perso_id][1],16,16)



func _on_button_perso_1_pressed():
	PlayerStats.character = 0


func _on_button_perso_2_pressed():
	PlayerStats.character = 1


func _on_button_perso_3_pressed():
	PlayerStats.character = 2


func _on_button_perso_4_pressed():
	PlayerStats.character = 3


func _on_button_perso_5_pressed():
	PlayerStats.character = 4


func _on_button_perso_6_pressed():
	PlayerStats.character = 5


func _on_button_perso_7_pressed():
	PlayerStats.character = 6


func _on_button_perso_8_pressed():
	PlayerStats.character = 7
