
extends Node

const SCREEN_X = 1
const SCREEN_Y = 0

func _ready():
	# Initialization here
	get_node('/root/Game/HUD/root/Message Box').set_text('Incoming Air Defenses')


