
extends Sprite

# member variables here, example:
# var a=2
# var b="textvar"
var blinker = false
var blink_timer=0
var blink_freq1=20
var blink_freq2=40

func _ready():
	# Initialization here
	set_process(true)
	
func _process(delta):
	get_node('/root/globals').blink(self)


