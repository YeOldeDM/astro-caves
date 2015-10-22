
extends Node

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initialization here
	set_process(true)
	
func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		get_tree().change_scene('res://scenes/title.scn')




func _on_Timer_timeout():
	get_tree().change_scene('res://scenes/title.scn')
