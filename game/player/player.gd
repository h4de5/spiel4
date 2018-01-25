# player baseship, has Input processor
extends "res://game/ship/baseship.gd"

func _ready():
	fix_collision_shape()

func initialize() :
	#print("initialize player")
	.initialize()

	properties_base[global.properties.modifier_add] = {
		global.properties.movement_speed_forward: 1000,
	}
	# register to locator
	register_object(global.groups.player)