# default weapon for shootable ships
extends Node

var properties_base = {
	global.properties.bullet_speed: 800,
	global.properties.bullet_strength: 5,
	global.properties.bullet_wait: 0.3,
	global.properties.bullet_range: 1000,
	global.properties.weapon_rotation_speed: 1.5,
	global.properties.clearance_rotation: 0.05,
}

var bullet
var activated

func _ready():
	bullet = get_node("bullet")
	remove_child(bullet)
	activated = true

# get all different properties from this ship
#func get_property(type) :
#	# if null, return all properties
#	if (type == null) :
#		return properties_base
#	if (type in properties_base) :
#		return properties_base[type]
#	else :
#		return null

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
	get_node(global.scene_tree_bullets).add_child(bullet)
	bullet.set_parent(parent)
	bullet.set_pos(get_node("muzzle").get_global_pos())

	#var starting_rot = (parent.get_node("weapon").get_global_rot()) + PI
	var starting_rot = get_global_rot()
	bullet.set_global_rot(starting_rot)

	starting_rot += PI

	var v2 = Vector2(  sin(starting_rot), cos(starting_rot)   ).normalized()
	bullet.set_linear_velocity(v2 * parent.properties[global.properties.bullet_speed]);
