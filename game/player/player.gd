# player baseship, has Input processor
extends "res://game/ship/baseship.gd"

func _ready():
	fix_collision_shape()

func initialize() :
	#print("initialize player")
	.initialize()

	# register to locator
	register_object(global.groups.player)