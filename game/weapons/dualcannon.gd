# default weapon for shootable ships
extends "res://game/weapons/weapon.gd"


var tmp_count

func _ready():

	tmp_count = 0

	properties_base = {
		global.properties.bullet_speed: 900,
		global.properties.bullet_strength: 40,
		global.properties.bullet_wait: 0.4,
		global.properties.bullet_range: 800,
		global.properties.weapon_rotation_speed: 3,
		#global.properties.clearance_rotation: 0.02,
	}

	activated = true

func set_weapon_rotation(r):
	tmp_count += 1

	var rot_local = fmod(r - parent.get_rot(), 2*PI)

	if rot_local > PI:
		rot_local = -PI + (rot_local - PI)
	elif rot_local < -PI:
		rot_local = PI - (rot_local + PI)

	if tmp_count > 5:
		print("set_weapon_rotation ", r,
			" parent rot: ", parent.get_rot(),
			" rot_local ", rot_local,
			" current rot ", get_node("Sprite").get_rot())
		tmp_count = 0

	# I am never gonna learn vectors and angesl
	get_node("Sprite").set_rot(rot_local)
	get_node("Sprite2").set_rot(rot_local)

func get_weapon_rotation():

	return fmod(get_node("Sprite").get_rot() + parent.get_rot(), 2*PI)

func get_weapon_position():
	return get_global_pos()

func shoot(parent, target = null):

	.shoot(parent, target)

	var bullet = new_bullet()
	get_node(global.scene_tree_bullets).add_child(bullet)
	bullet.set_parent(parent)
	bullet.set_pos(get_node("Sprite2/muzzle2").get_global_pos())

	#var starting_rot = (parent.get_node("weapon").get_global_rot()) + PI

	var starting_rot = get_node("Sprite2").get_rot() + parent.get_rot()
	bullet.set_global_rot(starting_rot)

	starting_rot += PI

	var v2 = Vector2(  sin(starting_rot), cos(starting_rot)   ).normalized()
	bullet.set_linear_velocity(v2 * parent.properties[global.properties.bullet_speed]);