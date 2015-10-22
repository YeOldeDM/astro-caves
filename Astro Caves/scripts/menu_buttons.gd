
extends Control



func _ready():
	# Initialization here
	pass




func _on_QuitButton_pressed():
	get_tree().quit()


func _on_StartButton_pressed():
	get_tree().change_scene('res://scenes/main_scene.scn')
