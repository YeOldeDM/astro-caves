
extends Node

var player_class = preload('res://scripts/player.gd')

var cleared=false

func _ready():
	get_node('/root/globals').CURRENT_STAGE = self
	#check_for_clear()	#initial check for clear upon entering room
	set_process(true)
	
func _process(delta):
	if not cleared:
		check_for_clear()


func _on_Area2D_body_enter( body,x,y ):
	if body extends player_class:
		var g = get_property_list()
		get_node('/root/globals')._set_stage(self, str('stage',x,y))

func _on_Spikes_body_enter( body ):
	if body extends player_class:
		body.get_hit(null,16)

func check_for_clear():
	if not has_node('Mobs'):
		cleared=true
	else:
		if get_node('Mobs').get_child_count() < 1:
			cleared = true
		"""
		var go=true

		for i in get_node('Mobs').get_children():
			if i == from_mob:
				continue
			else:
				go=false
		if go:
			cleared=true
		"""

	
	if cleared:
		##	DO STUFF  ##
		#print("Clear!")
		if has_node('BlockDoors'):
			for i in get_node('BlockDoors').get_children():
				i.open()
		if has_node('Rewards'):
			for i in get_node('Rewards').get_children():
				i.award()
	
	