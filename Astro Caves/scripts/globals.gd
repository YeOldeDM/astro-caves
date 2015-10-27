extends Node

const SLOWBALL_SPEED = 21


var OUR_X=2
var OUR_Y=1
var CURRENT_STAGE

var stage00 = preload('res://scenes/stage0-0.xml')
var stage10 = preload('res://scenes/stage1-0.xml')
var stage20 = preload('res://scenes/stage2-0.xml')
var stage30 = preload('res://scenes/stage3-0.xml')
var stage40 = preload('res://scenes/stage4-0.xml')
var stage50 = preload('res://scenes/stage5-0.xml')
var stage60 = preload('res://scenes/stage6-0.xml')
var stage70 = preload('res://scenes/stage7-0.xml')

var stage01 = preload('res://scenes/stage0-1.xml')
var stage11 = preload('res://scenes/stage1-1.xml')
var stage21 = preload('res://scenes/stage2-1.xml')
var stage31 = preload('res://scenes/stage3-1.xml')
var stage41 = preload('res://scenes/stage4-1.xml')
var stage71 = preload('res://scenes/stage7-1.xml')

var stage22 = preload('res://scenes/stage2-2.xml')
var stage32 = preload('res://scenes/stage3-2.xml')



func _set_stage():
	var stage_name = str('stage',str(OUR_X),str(OUR_Y))
	CURRENT_STAGE.queue_free()
	if get(stage_name):
		var new_stage = get(stage_name)
		var l = new_stage.instance()
		print(get_node('/root').get_child(0))
		get_node('/root/').get_child(0).add_child(l)
		
		var pip = get_node('/root/Game/HUD/root/Minimap/sprite')
		var x = (OUR_X*2)+OUR_X
		var y = (OUR_Y*2)+OUR_Y
		pip.set_pos( Vector2(x,y) )
	else:
		print('BAD MAP CALLED! ', str(OUR_X,' ',OUR_Y) )
		print('CLEAN OUT YOUR LOCKER AT THE CLUB, BOB...YOURE F***ING FIRED!!!')
		get_tree().quit()	#hard-crash us on purpose. This should NEVER happen! unless we go into a room that hasn't been built yet





func blink(owner):
	"""
	#	HOW TO USE BLINK:	#
	Any object invoking blink() must have the following:
	-A sprite child (the one that is blinking) named exactly "sprite"
	
	The following variables defined in the top-level of the object's script:
	var blinker=false	#A switch for blinking on/off
	var blink_timer=0	#A timer for the blinker
	var blink_freq1=1	#an INT, how many frames the blink will stay 'off'
	var blink_freq2=1	#an INT, how many frames the blink will stay 'on'
	    Tweak freq1/2 to get different 'modulations' of blink patterns.
	"""

	if owner.blinker:
		owner.blink_timer += 1
		if owner.blink_timer > owner.blink_freq1:
			owner.get_node('sprite').set_modulate( Color( 1.0,1.0,1.0, 0.0 ) )
			owner.blink_timer = 0
			owner.blinker = false
	else:
		owner.blink_timer += 1
		if owner.blink_timer > owner.blink_freq2:
			owner.get_node('sprite').set_modulate( Color( 1.0,1.0,1.0, 1.0 ) )
			owner.blink_timer = 0
			owner.blinker = true