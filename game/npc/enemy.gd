# enemy baseship, controlled by AI processor
extends "res://game/ship/baseship.gd"

var object_group = global.groups.npc

func _ready():
	fix_collision_shape()

func initialize() :
	# call baseship init
	.initialize()

	# add to group enemy
	register_object(object_group)

	# make the AI stear it
	#get_node('processor_selector').set_processor("AI")

func destroy(by_whom):
	.destroy(by_whom)

	if network_manager.is_offline() or network_manager.is_server():
		#get_node(global.scene_tree_game).spawn_object(scene_path, main_group)
		get_node(global.scene_tree_game).spawn_enemy()