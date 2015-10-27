
extends StaticBody2D


func _ready():
	# Initialization here
	get_node('animator').play('close')
	get_node('sound').play('close')

func _process(delta):
	if get_node('sprite').get_frame() >= 7:
		clear_shapes()
		set_process(false)

func open():
	get_node('animator').play('open')
	get_node('sound').play('open')
	set_process(true)



