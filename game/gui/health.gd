# healthbar class, used by destroyable interface is baseships
extends Control

#export (NodePath) var target
var owner
var owner_path

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
		if wr.get_ref():
			set_pos(owner.get_pos())
			if not owner.has_method("get_property"):
				# BUG - bei vielen gegner tritt hier immer wieder ei nfehler auf
				# owner ist eine bullet (?) oder eine Progressbar (?)
				# Invalid call. Nonexistent function 'get_property' in base 'RigidBody2D (bullet.gd)'.
				#get_tree().set_pause(true)
				queue_free()
			else :
				var health_max = owner.get_property(global.properties.health_max)
				var health = owner.get_property(global.properties.health)
				if has_node("ProgressBar"):
					var progressbar = get_node("ProgressBar")
					progressbar.set_max(health_max)
					progressbar.set_value(health)
		else:
			queue_free()
	#else :
	#	set_post(OS.get_window_size().x / 2, OS.get_window_size().y / 2)

func set_owner(o):
	owner = o
	owner_path = o.get_path()

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