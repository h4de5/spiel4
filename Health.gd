extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (NodePath) var target

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	set_fixed_process(true)
	
	pass


func _fixed_process(delta):
	set_pos(get_node(target).get_pos());