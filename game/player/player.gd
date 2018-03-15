# player baseship, has Input processor
extends "res://game/ship/baseship.gd"

var object_group = global.groups.player

func _ready():
	fix_collision_shape()

func initialize() :
	#print("initialize player")
	.initialize()

	# register to locator
	register_object(object_group)