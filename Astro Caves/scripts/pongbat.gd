
extends RigidBody2D

var SPEED = 20
var life = 3

var player_class = preload('res://scripts/player.gd')

var splode = preload('res://scenes/mob_splode.xml')
var drop = preload('res://scenes/health_pak.xml')
var drop2 = preload('res://scenes/health_pak_big.xml')

func _ready():
	set_linear_velocity(Vector2(1,1)*SPEED)

	
func _integrate_forces(state):
	var direction = get_linear_velocity()
	var step = state.get_step()

	
	for i in range(state.get_contact_count()):
		var pos = get_pos()
		var col = state.get_contact_collider_object(i)
		var norm = state.get_contact_local_normal(i)

		if col:
			if col extends player_class:
				col.get_hit(self,2)
			if get_node('up_ray').is_colliding() or pos.y <= 0:
				direction.y = SPEED

			if get_node('down_ray').is_colliding() or pos.y >= 88:
				direction.y = -SPEED
			
			if get_node('left_ray').is_colliding() or pos.x <= 0:
				direction.x = SPEED
			
			if get_node('right_ray').is_colliding() or pos.x >= 128:
				direction.x = -SPEED

			break
	print(direction)
	set_linear_velocity(direction)
	
func mob_get_hit(origin,amt):
	#get_node('sound').play('hit')
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



