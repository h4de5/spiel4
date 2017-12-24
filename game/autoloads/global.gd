# global autoloads, used for scene paths and dictonaries
extends Node

# scene paths
const scene_path_player 	= "res://game/player/player.tscn"
const scene_path_enemy 		= "res://game/npc/enemy.tscn"
const scene_path_game 		= "res://game/main/game.tscn"
const scene_path_gameover 	= "res://game/scenes/gameover.tscn"
const scene_path_healthbar 	= "res://game/gui/health.tscn"
const scene_path_camera 	= "res://game/main/camera.tscn"
#const scene_path_missle 	= "res://game/weapons/missle.tscn"
#const scene_path_bullet 	= "res://game/weapons/bullet.tscn"

const scene_tree_game 			= "/root/Game"
const scene_tree_ships 			= "/root/Game/ships"
const scene_tree_bullets 		= "/root/Game/bullets"
const scene_tree_ship_locator 	= "/root/Game/ship_locator"
const scene_tree_player_manager = "/root/Game/player_manager"
const scene_tree_camera 		= "/root/Game/Camera"


var groups = {
	player= "player",
	enemy= "enemy",
	obstacle= "obstacle",
	bullet= "bullet",
	missle= "missle"
}

var properties = {
	movement_speed_forward = "movement_speed_forward",
	movement_speed_back = "movement_speed_back",
	ship_rotation_speed = "ship_rotation_speed",
	weapon_rotation_speed = "weapon_rotation_speed",
	clearance_rotation = "clearance_rotation",
	zoom_speed = "zoom_speed",
	bullet_speed = "bullet_speed",
	bullet_strength = "bullet_strength",
	bullet_wait = "bullet_wait",
	bullet_range = "bullet_range",
	health_max = "health_max",
	health = "health"
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


