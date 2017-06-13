extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (NodePath) var target
var target_obj

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	resetHealth()
	
	set_fixed_process(true)
	
	
	pass


func _fixed_process(delta):
	#if target != "" and get_node(target) != null:
	#	set_pos(get_node(target).get_pos());
	#if target_obj != null:
	set_pos(target_obj.get_pos());

func changeHealth(value):
	var progressbar = get_node("ProgressBar")
	progressbar.set_value(progressbar.get_value() + value)

func resetHealth():
	var progressbar = get_node("ProgressBar")
	progressbar.set_value(100)

func getHealth():
	return get_node("ProgressBar").get_value()