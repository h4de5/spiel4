# default weapon for shootable ships
extends "res://game/weapons/weapon.gd"

func _ready():
	properties_base = {
		global.properties.bullet_speed: 950,
		global.properties.bullet_strength: 50,
		global.properties.bullet_wait: 0.3,
		global.properties.bullet_range: 1000,
		global.properties.weapon_rotation_speed: 4,
		global.properties.clearance_rotation: 0.02,
	}

	#activated = true

func shoot(parent, target = null):
	sound_manager.play( preload("res://art/sounds/shot2.wav"), get_global_position())
	.shoot(parent, target)