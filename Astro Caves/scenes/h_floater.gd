
extends RigidBody2D


var life = 8


var direction = 1		#1 = moving down, -1 = moving up
var wall_direction = 0
var SPEED = 18

var fire_rate = 3.14
var burst_rate = 0.8
var burst_count = 3
var burst_timer = -1
var fire_timer = 0.0
var burst_counter = 0

var slowball = preload('res://scenes/slowball.xml')

var player_class = preload('res://scripts/player.gd')

var splode = preload('res://scenes/mob_splode.xml')
var drop = preload('res://scenes/health_pak.xml')
var drop2 = preload('res://scenes/health_pak_big.xml')

var y_pos

func _ready():
	set_process(true)
	y_pos = get_pos().y
	
func _process(delta):

	fire_timer += delta
	
	if burst_timer > -1:
		burst_timer += delta

	if burst_counter >= burst_count:
		burst_counter = 0
		burst_timer = -1
		fire_timer = 0
	
	# lock our X position
	if get_pos().y != y_pos:
		set_pos(Vector2(get_pos().x,y_pos))	
		
		
func _integrate_forces(s):
	var step = s.get_step()
	var lv = get_linear_velocity()
	
	if fire_timer >= fire_rate and burst_counter < burst_count:
		
		if burst_timer < 0:
			burst_timer = 0
		if burst_timer >= burst_rate:
			get_node('sound').play('fire')
			var bullet = slowball.instance()
			bullet.set_pos(get_pos())
			PS2D.body_add_collision_exception(bullet.get_rid(),get_rid())
			get_node('/root/globals').CURRENT_STAGE.add_child(bullet)
			
			var d = sign(get_node('/root/Game/Toon').get_pos().y - get_pos().y)
			var x = rand_range(-4,4)
			
			bullet.set_linear_velocity(Vector2(x,15*d))
			burst_timer = 0
			burst_counter += 1

		
		

	
	for i in range(s.get_contact_count()):
		var col = s.get_contact_collider_object(i)
		var norm = s.get_contact_local_normal(i)
		
		##	HIT THE PLAYER  ##
		if col extends player_class:
			col.get_hit(self,8)
		
		# Assume we only move vertically, hitting floors and ceilings
		if col:
			if norm.x < 0.0:
				wall_direction = -1
			elif norm.x > 0.0:
				wall_direction = 1
			break
			
	if wall_direction != 0 and wall_direction != direction:
		direction = -direction

			
	set_linear_velocity(Vector2(SPEED*direction,0))
		
	
func mob_get_hit(origin,amt):
	get_node('sound').play('hit')
	life -= amt
	
	# DEATH #
	if life <= 0:
		die()


func die():
	#drop health based on player health
	var toon = get_node('/root/Game/Toon')
	var per = (toon.life*1.0 / toon.max_life)
	var chance = min(1.0, randf() + (randf()*0.1) )
	if chance > per:
		var d = null
		if randf() < 0.2:	#drop big health 20% chance
			d = drop2.instance()
		else:				#or else drop baby health
			d = drop.instance()

		d.set_pos(get_pos())
		get_node('/root/globals').CURRENT_STAGE.add_child(d)
	
	#spawn a sploder
	var s = splode.instance()
	s.set_pos(get_pos())
	get_node('/root/globals').CURRENT_STAGE.add_child(s)

	queue_free()



