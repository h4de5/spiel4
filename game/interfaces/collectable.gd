extends "res://game/interfaces/isable.gd"

func is_adjustable():
	if activated:
		return self
	else:
		return null

func _ready():
	required_properties = [
		global.properties.pickup_type,
		global.properties.pickup_modifier_mode,
		global.properties.pickup_duration
	]

	call_deferred("initialize")