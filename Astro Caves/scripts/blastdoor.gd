
extends StaticBody2D

var health = 5
var hits = 0
var regen_timer=0
var regen_time=0.8

var open=false
var did_open=false

func _ready():
	# Initialization here
	set_process(true)
	get_node('animator').play('close')
	get_node('sound').play('close')
	
func _process(delta):

	if not get_node('animator').is_playing():	
		if not open:
			if hits > 0:
				regen_timer += delta + ( hits * ( (hits-2) * 0.0078))
				if regen_timer >= regen_time:
					hits -= 1
					regen_timer = 0
		
			if hits >= health:
				print("open!")
				open=true
				clear_shapes()
			get_node('sprite').set_frame(hits)
			
		else:
			if not did_open:
				did_open=true
				get_node('animator').play('open')
				get_node('sound').set_param(1, 1.0)
				get_node('sound').play('open')

func mob_get_hit(origin,amt):
	if not open:
		hits += amt
		get_node('sound').set_param(1, (hits*1.0*0.1)+0.5)
		get_node('sound').play('hit')


