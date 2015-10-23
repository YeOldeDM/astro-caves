
extends StaticBody2D

var fire_rate = 1.4
var fire_timer = 1.2

var laser = preload('res://scenes/death_laserbolt.xml')

func _ready():
	# Initialization here
	set_process(true)
	

func _process(delta):

	if fire_timer >= fire_rate:
		fire_timer = 0
		shoot()
	else:
		fire_timer += delta
		

func shoot():
	var s = laser.instance()
	s.set_pos(get_pos())
	get_node('/root/globals').CURRENT_STAGE.add_child(s)
	
	var player = get_node('/root/Game/Toon')
	if player:
		var vec = (player.get_pos() - get_pos())
	
		s.set_linear_velocity(vec.normalized()*120)
	else:
		s.queue_free()


