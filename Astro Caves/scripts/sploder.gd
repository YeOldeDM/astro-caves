
extends Sprite

###
#	A general script for freeing one-off animated
#	sprites once they've played their animation
###
func _ready():
	var sfx = get_node('sound').get_sample_library()
	get_node('sound').play('splode')
	
func _on_AnimationPlayer_finished():
	queue_free()
