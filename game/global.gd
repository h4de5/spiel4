extends Node

# scene paths
const scene_path_player 	= "res://game/player/player.tscn"
#const scene_path_enemy 	= "res://game/npc/obstacle.tscn"
const scene_path_enemy 		= "res://game/npc/enemy.tscn"
const scene_path_game 		= "res://game/scenes/game.tscn"
const scene_path_gameover 	= "res://game/scenes/gameover.tscn"
const scene_path_healthbar 	= "res://game/gui/health.tscn"
const scene_path_camera 	= "res://game/scenes/camera.tscn"
const scene_path_missle 	= "res://game/npc/missle.tscn"
const scene_path_bullet 	= "res://game/npc/bullet.tscn"

enum groups {
	player,
	enemy,
	obstacle,
	bullet,
	missle
}
	
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

enum properties {
	movement_speed_forward,
	movement_speed_back,
	rotation_speed,
	zoom_speed,
	bullet_speed,
	bullet_strength,
	bullet_wait,
	health_max,
	health
}

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
