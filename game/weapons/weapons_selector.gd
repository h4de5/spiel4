# selects weapon, delivers current weapon to get position and orientation
extends Node

func get_active_weapon():
	var weapons = get_children()
	for weapon in weapons:
		if weapon.is_activated():
			return weapon
	return null
