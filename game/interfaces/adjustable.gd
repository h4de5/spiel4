extends "res://game/interfaces/isable.gd"

func is_adjustable():
	return true
	
func _ready():
	print("im ready adjustable - anfang")
	required_properties = [
		global.properties.health,
		global.properties.health_max
	]
	check_requirements()
	print("im ready adjustable - ende")