
extends RigidBody2D

var GOD_MODE=false

var blinker = false
var blink_timer=0
var blink_freq1 = 2
var blink_freq2 = 3

var SPEED = 32
var ACCEL = 135
var facing = 1		# 1 = facing left, -1 = facing right

var func_down = false

var life = 32
var max_life = 32

var is_hit=false
var hit_duration = 2.0
var hit_timer = 0

var BULLET_SPEED=180
var BULLET_SPREAD=5
var fire_rate = 0.36
var rapid_fire_rate = 0.15

var fire_timer=0
var can_fire=true

var jets_active = true
var jets_direction = 0

var laser_bullet = preload('res://scenes/laser.xml')
var splode = preload('res://scenes/mob_splode.xml')

var jets

var pos = null
var death_timer = -1


var UPGRADE_RAPIDFIRE = false



func _integrate_forces(s):
	# get linear velocity
	var lv = get_linear_velocity()
	var step = s.get_step()

	var new_facing = facing

	# input commands
	var joyx = Input.get_joy_axis(0,0)
	var joyy = Input.get_joy_axis(0,1)
	var UP = Input.is_action_pressed('fly_up')
	var DOWN = Input.is_action_pressed('fly_down')
	var LEFT = Input.is_action_pressed('fly_left')
	var RIGHT = Input.is_action_pressed('fly_right')
	
	var FIRE = Input.is_action_pressed('fire')
	
	#print(joyx,':',joyy)
	
	if FIRE and can_fire:
		var bullet = laser_bullet.instance()
		var pos = get_pos()
		pos.x -= 2*facing
		bullet.set_pos(pos)
		get_node('/root/globals').CURRENT_STAGE.add_child(bullet)
		PS2D.body_add_collision_exception(bullet.get_rid(),get_rid())
		var y = rand_range(-BULLET_SPREAD, BULLET_SPREAD)
		bullet.set_linear_velocity( Vector2(-facing*BULLET_SPEED,y) )
		can_fire=false
		
		get_node('sound').play('laser_bullet_fire')

	# Fire control
	if not can_fire:
		fire_timer += step
		if UPGRADE_RAPIDFIRE:
			if fire_timer >= rapid_fire_rate:
				can_fire=true
				fire_timer *= 0
		else:
			if fire_timer >= fire_rate:
				can_fire=true
				fire_timer *= 0

	# Thrust from movement
	if jets_active:
		if UP and not DOWN:
			lv.y -= ACCEL * step
			jets_direction = 0
			
		if DOWN and not UP:
			lv.y += ACCEL * step
	
			jets_direction = 180
			
		if LEFT and not RIGHT:
			lv.x -= ACCEL * step
			new_facing = 1
			jets_direction = 90
			
		if RIGHT and not LEFT:
			lv.x += ACCEL * step
			new_facing = -1
			jets_direction = 270
		
		if joyx:
			lv.x = SPEED*joyx
			if joyx < 0:
				if not Input.is_action_pressed('hold_facing'):
					new_facing = 1
			elif joyx > 0:
				if not Input.is_action_pressed('hold_facing'):
					new_facing = -1
		if joyy:
			lv.y = SPEED*joyy
		
	if not UP and not DOWN and not RIGHT and not LEFT and abs(joyx)+abs(joyy) <= 0.0:
		jets.set_emitting(false)
		
	else:
		if not jets.is_emitting():
			jets.set_emitting(true)
			set_linear_velocity(get_linear_velocity()*0.993)
			
		


	# obey speed limits
	if lv.x > SPEED:
		lv.x = SPEED
	elif lv.x < -SPEED:
		lv.x = -SPEED
	if lv.y > SPEED:
		lv.y = SPEED
	elif lv.y < -SPEED:
		lv.y = -SPEED
	
	#set facing
	if new_facing != facing:
		facing = new_facing
		get_node('sprite').set_scale(Vector2(facing,1))
	
	# set linear velocity
	lv += s.get_total_gravity()*step
	set_linear_velocity(lv)
	
	

func _ready():
	set_process(true)
	jets = get_node('jets')
	#get_node('/root/globals').OUR_X=2
	#get_node('/root/globals').OUR_Y=2

	
func _process(delta):
	pos = get_pos()
	
	##  Handle Death  ##
	if death_timer >= 0:
		death_timer += delta
	if death_timer > 2.0:
		get_node('/root/globals').CURRENT_STAGE.queue_free()
		get_tree().change_scene('res://scenes/game_over.scn')
	
	## Dampen movement when not thrusting ##
	if not jets.is_emitting():
		set_linear_velocity(get_linear_velocity()*0.7)
	
	var change=false
	
	if pos.x < 3.5:
		pos.x = 120
		set_pos(pos)
		get_node('/root/globals').OUR_X -= 1
		change=true
		
	elif pos.x > 124.5:
		pos.x = 12
		set_pos(pos)
		get_node('/root/globals').OUR_X += 1
		change=true
		
	if pos.y < 3.5:
		pos.y = 80
		set_pos(pos)
		change=true
		get_node('/root/globals').OUR_Y -= 1
	elif pos.y > 84.5:
		pos.y = 8
		set_pos(pos)
		change=true
		get_node('/root/globals').OUR_Y += 1
	
	if change:
		get_node('/root/globals')._set_stage()
	
	if is_hit:
		get_node('/root/globals').blink(self)
		if hit_timer > hit_duration:
			is_hit=false
			hit_timer = 0
			get_node('sprite').set_modulate(Color(1.0,1.0,1.0,1.0))
			
		
			
		else:
			hit_timer += delta
	
	##	TOGGLE GOD MODE  ##
	if Input.is_key_pressed(KEY_F1) and not func_down:
		func_down=true
		if GOD_MODE:
			GOD_MODE=false
			get_node('/root/Game/HUD/root/Message Box').set_text("GOD mode Off")
		else:
			GOD_MODE=true
			get_node('/root/Game/HUD/root/Message Box').set_text("GOD mode On")
			
	#  RESTORE LIFE TO MAX
	if Input.is_key_pressed(KEY_F2) and not func_down:
		func_down=true
		heal(max_life)
	
	#  TOGGLE RAPID-FIRE
	if Input.is_key_pressed(KEY_F3) and not func_down:
		func_down = true
		if UPGRADE_RAPIDFIRE:
			UPGRADE_RAPIDFIRE = false
		else:
			UPGRADE_RAPIDFIRE = true
	
	if Input.is_key_pressed(KEY_F4) and not func_down:
		func_down = true
		var stage = get_node('/root/globals').CURRENT_STAGE
		if stage.has_node('Mobs'):
			for i in stage.get_node('Mobs').get_children():
				print(i.get_name())
	
	if Input.is_key_pressed(KEY_F5) and not func_down:
		func_down=true
		if get_node('/root/globals').CURRENT_STAGE.has_node('Mobs'):
			for mob in get_node('/root/globals').CURRENT_STAGE.get_node('Mobs').get_children():
				mob.die()
	
	#toggle off
	elif not Input.is_key_pressed(KEY_F4) and not Input.is_key_pressed(KEY_F5) and not Input.is_key_pressed(KEY_F3) and not Input.is_key_pressed(KEY_F2) and not Input.is_key_pressed(KEY_F1):
		func_down=false	
	
	
	
func get_hit(origin=null, amt=1):
	if not is_hit:
		get_node('sound').play('ouch')
		if life > 0:	#subtract damage
			if not GOD_MODE:
				print('ouch')
				life -= amt

		
		##  DEATH  ##
		else:
			if death_timer < 0:
				die()
			
		#kick-back
		"""
		if origin:
			var target_pos = origin.get_pos()
			var my_pos = get_pos()
			var vect = target_pos - my_pos
			set_linear_velocity(-vect*4)
		"""
		is_hit=true
		
	#blit the HUD's life bar
	get_node('/root/Game/HUD/root/lifebar').set_frame(life)
	
	#blit message box if we need to
	var per = 0.0
	per = (life*1.0 / max_life)
	if per <= 0.0:
		get_node('/root/Game/HUD/root/Message Box').set_text('0% energy!! -CRITICAL-')
	elif per <= 0.25:
		get_node('/root/Game/HUD/root/Message Box').set_text('Low Energy warning!')
	elif per <= 0.5:
		get_node('/root/Game/HUD/root/Message Box').set_text('50% Energy remains')


func heal(amt):
	life += amt
	if life >= max_life:
		life = max_life
	get_node('/root/Game/HUD/root/lifebar').set_frame(life)

func die():
	death_timer = 0.0
	jets_active=false
	set_mode(MODE_STATIC)
	remove_shape(0)
	var s = splode.instance()
	s.set_pos(get_pos())
	get_node('/root/globals').CURRENT_STAGE.add_child(s)
	

	
