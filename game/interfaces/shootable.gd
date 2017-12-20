extends "res://game/interfaces/isable.gd"


func is_shootable():
	return true
	
func _ready():
	required_properties = [
		global.properties.bullet_speed,
		global.properties.bullet_strength,
		global.properties.bullet_wait,
		global.properties.bullet_range
	]

	check_requirements()