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
	set_global_rotation(r)

func get_weapon_rotation():
	return get_global_rotation()

func get_weapon_position():
	return get_global_position()


func shoot(parent, target = null):
	send_bullet(get_node("Sprite/muzzle").get_global_position(), get_weapon_rotation())


remote func send_bullet(muzzle_pos, starting_rot):

	if network_manager.is_master(parent):
		rpc("send_bullet", muzzle_pos, starting_rot)

	var newbullet = bullet.duplicate(false)
	newbullet.set_script(bullet.get_script())

	get_node(global.scene_tree_bullets).add_child(newbullet)
	newbullet.set_parent(parent)

	newbullet.set_position(muzzle_pos)
	#var starting_rot = get_weapon_rotation()
	newbullet.set_global_rotation(starting_rot)

	starting_rot -= PI / 2

	var v2 = Vector2(  cos(starting_rot), sin(starting_rot)   ).normalized()
	# it would be more correct, if we add parents velocity ..
	# but the game would not be better through it ->
	# very slow bullets if shooting behind
	#newbullet.set_linear_velocity(v2 * parent.properties[global.properties.bullet_speed] + parent.get_linear_velocity());
	newbullet.set_linear_velocity(v2 * parent.properties[global.properties.bullet_speed]);


