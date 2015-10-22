
extends Area2D

var player_class = preload('res://scripts/player.gd')







func _on_upgrade_rapidfire_body_enter( body ):
	if body extends player_class:
		body.UPGRADE_RAPIDFIRE=true
		get_node('/root/Game/HUD/root/upgrade_rapidfire').set_frame(1)
		queue_free()
