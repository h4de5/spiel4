extends "res://game/interfaces/isable.gd"

func is_adjustable():
	return activated
	
func _ready():
	print("adjustable _ready - start ", get_parent().get_name(), " activated: ", activated)
	required_properties = [
		
	]
	#check_requirements()
	print("adjustable _ready - end ", get_parent().get_name(), " activated: ", activated)