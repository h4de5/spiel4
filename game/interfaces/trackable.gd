extends "res://game/interfaces/isable.gd"

func is_trackable():
	if activated:
		return self
	else:
		return null

func _ready():
	#print("trackable _ready - start ", get_parent().get_name(), " activated: ", activated)
	required_properties = [

	]
	#check_requirements()
	#print("trackable _ready - end ", get_parent().get_name(), " activated: ", activated)
	call_deferred("initialize")

func initialize():
	pass

func _enter_tree():
	indicator_manager.register_trackable(parent)

func _exit_tree():
	indicator_manager.unregister_trackable(parent)
