extends Node

# scene paths
const scene_path_player 	= "res://game/player/player.tscn"
const scene_path_enemy 		= "res://game/npc/enemy.tscn"
const scene_path_game 		= "res://game/main/game.tscn"
const scene_path_gameover 	= "res://game/scenes/gameover.tscn"
const scene_path_healthbar 	= "res://game/gui/health.tscn"
const scene_path_camera 	= "res://game/main/camera.tscn"
const scene_path_missle 	= "res://game/npc/missle.tscn"
const scene_path_bullet 	= "res://game/npc/bullet.tscn"

const scene_tree_game 			= "/root/Game"
const scene_tree_ship_locator 	= "/root/Game/ship_locator"
const scene_tree_player_manager = "/root/Game/player_manager"
const scene_tree_camera = "/root/Game/Camera"


var groups = {
	player= "player",
	enemy= "enemy",
	obstacle= "obstacle",
	bullet= "bullet",
	missle= "missle"
}



	
# valid actions for a baseship
enum actions {
	left,
	right,
	target_left,
	target_right,
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
	ship_rotation_speed,
	weapon_rotation_speed,
	clearance_rotation,
	zoom_speed,
	bullet_speed,
	bullet_strength,
	bullet_wait,
	bullet_range,
	health_max,
	health
}
