
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
var player_class = preload('res://scripts/player.gd')

func _ready():
	set_process(true)
	
func _process(delta):
	var pos = get_pos()
	if pos.x < 0 or pos.x > 128 or pos.y < 0 or pos.y > 88:
		queue_free()

func _on_Area2D_body_enter( body ):
	if body extends player_class:
		if not body.is_hit:
			body.get_hit(self)
			queue_free()

