
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"

var player_class = preload('res://scripts/player.gd')

var sploder = preload('res://scenes/laser_splode.xml')

func _ready():
	# Initialization here
	pass




func _on_VisibilityNotifier2D_exit_screen():
	queue_free()
	pass # replace with function body


func _on_CollisionShape2D_body_enter( body ):
	
	if not body extends player_class:
		if body.has_method('mob_get_hit'):
			body.mob_get_hit(self,1)
			
		var s = sploder.instance()
		s.set_pos(get_pos())
		get_parent().add_child(s)
		
		queue_free()

		

