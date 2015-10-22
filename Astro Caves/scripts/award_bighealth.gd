
extends Node2D

var award = preload('res://scenes/health_pak_big.xml')

func award():
	print("TADA!")
	var a = award.instance()
	a.set_pos(get_pos())
	get_node('/root/globals').CURRENT_STAGE.add_child(a)
	


