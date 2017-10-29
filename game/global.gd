extends Node

# scene paths
var scene_path_player 		= "res://game/player/player.tscn"
var scene_path_enemy 		= "res://game/npc/obstacle.tscn"
var scene_path_game 		= "res://game/scenes/game.tscn"
var scene_path_gameover 	= "res://game/scenes/gameover.tscn"
var scene_path_healthbar 	= "res://game/gui/health.tscn"
var scene_path_camera 		= "res://game/scenes/camera.tscn"


# valid actions for a baseship
enum actions {
	left,
	right,
	accelerate,
	back,
	fire,
	use,
	zoom_in,
	zoom_out
}

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
