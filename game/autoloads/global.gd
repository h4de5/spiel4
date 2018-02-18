# global autoloads, used for scene paths and dictonaries
extends Node

# scene paths
const scene_path_player 	= "res://game/player/player.tscn"
const scene_path_enemy 		= "res://game/npc/enemy.tscn"
const scene_path_tower 		= "res://game/npc/tower.tscn"
const scene_path_asteroid	= "res://game/npc/asteroid.tscn"
const scene_path_comet		= "res://game/npc/comet.tscn"
const scene_path_pickup		= "res://game/pickups/pickup.tscn"
const scene_path_game 		= "res://game/main/game.tscn"
const scene_path_gameover 	= "res://game/scenes/gameover.tscn"
const scene_path_healthbar 	= "res://game/gui/health.tscn"
const scene_path_camera 	= "res://game/main/camera.tscn"
#const scene_path_missle 	= "res://game/weapons/missle.tscn"
#const scene_path_bullet 	= "res://game/weapons/bullet.tscn"

const scene_tree_game 			= "/root/game"
const scene_tree_ships 			= "/root/game/ships"
const scene_tree_bullets 		= "/root/game/bullets"
#const scene_tree_ship_locator 	= "/root/game/object_locator"
const scene_tree_player_manager = "/root/game/player_manager"
const scene_tree_camera 		= "/root/game/Camera"


var groups = {
	player		= "player",
	npc			= "npc",
	obstacle	= "obstacle",
	pickup 		= "pickup",
	bullet 		= "bullet",
	missle 		= "missle"
}

var collision_layer_masks = {
	player		= [1, 1+2+4+8+16+32],
	npc 		= [2, 1+2+4+8+16+32],
	obstacle 	= [4, 1+2+4+16+32],
	pickup 		= [8, 1+2],
	bullet 		= [16, 1+2+4+32],
	missle 		= [32, 1+2+4+16+32],
	explosion	= [64, 1+2+4+32]
}



var properties = {
	# moveable
	movement_speed_forward = "movement_speed_forward",
	movement_speed_back = "movement_speed_back",
	ship_rotation_speed = "ship_rotation_speed",
	clearance_rotation = "clearance_rotation",
	zoom_speed = "zoom_speed",

	# shootable
	weapon_rotation_speed = "weapon_rotation_speed",
	bullet_speed = "bullet_speed",
	bullet_strength = "bullet_strength",
	bullet_wait = "bullet_wait",
	bullet_range = "bullet_range",

	# destroyable
	health_max = "health_max",
	health = "health",

	# collectable
	pickup_type = "pickup_type",
	# how long does the modifier last
	pickup_modifier_duration = "pickup_modifier_duration",
	# how long is the collectable available
	pickup_duration = "pickup_duration",

	# modifier
	modifier_add = "modifier_add",
	modifier_multi = "modifier_multi",

	# resizeable bodies
	body_scale = "body_scale",
	body_scale_max = "body_scale_max",
	body_scale_min = "body_scale_min",
}

# the following properties should not be reset on collecting
var properties_fixed = [
	properties.health,
]

enum pickup_types {
	# modifier alters properties temporary
	modifier,
	# new weapons, auto switch? amunition?
	weapon,
	# not temporary, repair packs, amunition
	goods,
	# explode an collect
	bomb,
	# later use in missions?
	passenger
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


