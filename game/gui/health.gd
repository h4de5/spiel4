extends Control

#export (NodePath) var target
var owner

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	resetHealth()
	set_fixed_process(true)

func _fixed_process(delta):
	#if target != "" and get_node(target) != null:
	#	set_pos(get_node(target).get_pos());
	if owner != null:
		# to prevent error when ship is destroyed
		var wr = weakref(owner);
		if (wr.get_ref()):
			set_pos(owner.get_pos())
			var progressbar = get_node("ProgressBar")
			if(progressbar != null): 
				progressbar.set_max(owner.get_property(global.properties.health_max))
				progressbar.set_value(owner.get_property(global.properties.health) )
		else:
			queue_free()
	#else :
	#	set_post(OS.get_window_size().x / 2, OS.get_window_size().y / 2)

func set_owner(o):
	owner = o

func changeHealth(value):
	#var progressbar = get_node("ProgressBar")
	#progressbar.set_value(progressbar.get_value() + value)
	pass

func resetHealth():
	#var progressbar = get_node("ProgressBar")
	#progressbar.set_value(100)
	pass

func getHealth():
	return get_node("ProgressBar").get_value()