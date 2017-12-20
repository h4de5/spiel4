extends "res://game/interfaces/isable.gd"

func is_destroyable():
	return true
	
func _ready():
	required_properties = [
		global.properties.health,
		global.properties.health_max
	]
	check_requirements()