# enemy baseship, controlled by AI processor
extends "res://game/ship/baseship.gd"

func _ready():
	fix_collision_shape()

func initialize() :
	# call baseship init
	.initialize()

	# add to group enemy
	register_object(global.groups.npc)

	# make the AI stear it
	#get_node('processor_selector').set_processor("AI")

func destroy(destroyer):
	.destroy(destroyer)
	#get_node(global.scene_tree_game).spawn_enemy()