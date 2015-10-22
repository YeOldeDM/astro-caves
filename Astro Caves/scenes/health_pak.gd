
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

var player_class = preload('res://scripts/player.gd')




func _on_Area2D_body_enter( body, amt ):
	if body extends player_class:
		body.heal(amt)
		body.get_node('sound').play('pickup')
		queue_free()
