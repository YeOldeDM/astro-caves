
extends StaticBody2D


func _ready():
	# Initialization here
	set_process(true)

	get_node('animator').play('close')
	get_node('sound').play('close')

func open():
	get_node('animator').play('open')
	get_node('sound').play('open')
	clear_shapes()



