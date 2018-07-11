# default weapon for shootable ships
extends "res://game/weapons/weapon.gd"

func _ready():
	properties_base = {
		global.properties.bullet_speed: 2100,
		global.properties.bullet_strength: 40,
		global.properties.bullet_wait: 0.4,
		global.properties.bullet_range: 800,
		global.properties.weapon_rotation_speed: 5,
		global.properties.clearance_rotation: 0.02,
	}

	#activated = true

func set_weapon_rotation(r):
	get_node("Sprite").set_global_rotation(r)
	get_node("Sprite2").set_global_rotation(r)

#	tmp_count += 1
#
#	var rot_local = fmod(r - parent.get_rot(), 2*PI)
#
#	if rot_local > PI:
#		rot_local = -PI + (rot_local - PI)
#	elif rot_local < -PI:
#		rot_local = PI - (rot_local + PI)
#
#	if tmp_count > 5:
#		print("set_weapon_rotation ", r,
#			" parent rot: ", parent.get_rot(),
#			" rot_local ", rot_local,
#			" current rot ", get_node("Sprite").get_rot())
#		tmp_count = 0
#
#	# I am never gonna learn vectors and angesl
#	get_node("Sprite").set_rot(rot_local)
#	get_node("Sprite2").set_rot(rot_local)

func get_weapon_rotation():

	#return fmod(get_node("Sprite").get_rot() + parent.get_rot(), 2*PI)
	return get_node("Sprite").get_global_rotation()

func get_weapon_position():
	return get_global_position()

func shoot(parent, target = null):
	sound_manager.play( preload("res://art/sounds/shot1.wav"), get_global_position())
	
	send_bullet(get_node("Sprite/muzzle").get_global_position(), get_node("Sprite").get_global_rotation())
	send_bullet(get_node("Sprite2/muzzle").get_global_position(), get_node("Sprite2").get_global_rotation())