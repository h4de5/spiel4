# default weapon for shootable ships
extends Node

var properties_base = {}
#= {
#	global.properties.clearance_rotation: 0.02,
#}

var bullet
export var activated = false
var parent

func _ready():
	#properties_base[global.properties.clearance_rotation] = 0.02

	bullet = get_node("bullet")
	remove_child(bullet)
	hide()
	#activated = false

func set_parent(p):
	parent = p

func is_activated():
	return activated

func set_weapon_rotation(r):
	set_global_rot(r)

func get_weapon_rotation():
	return get_global_rot()

func get_weapon_position():
	return get_global_pos()

func new_bullet():
	return bullet.duplicate(false)

func shoot(parent, target = null):
	var bullet = new_bullet()
	send_bullet(bullet, get_node("Sprite/muzzle").get_global_pos(), get_weapon_rotation())


func send_bullet(bullet, muzzle_pos, starting_rot):
	get_node(global.scene_tree_bullets).add_child(bullet)
	bullet.set_parent(parent)

	bullet.set_pos(muzzle_pos)
	#var starting_rot = get_weapon_rotation()
	bullet.set_global_rot(starting_rot)

	starting_rot += PI

	var v2 = Vector2(  sin(starting_rot), cos(starting_rot)   ).normalized()
	# it would be more correct, if we add parents velocity ..
	# but the game would not be better through it ->
	# very slow bullets if shooting behind
	#bullet.set_linear_velocity(v2 * parent.properties[global.properties.bullet_speed] + parent.get_linear_velocity());
	bullet.set_linear_velocity(v2 * parent.properties[global.properties.bullet_speed]);
