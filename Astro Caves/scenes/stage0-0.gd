
extends Node

var player_class = preload('res://scripts/player.gd')




func _on_Area2D_body_enter( body,x,y ):
	if body extends player_class:
		var g = get_property_list()
		get_node('/root/globals')._set_stage(str('stage',x,y))
	
