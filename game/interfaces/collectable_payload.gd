extends Node2D

#	properties = {
#		global.properties.movement_speed_forward: 4000,
#		global.properties.movement_speed_back: 2000,
#		global.properties.ship_rotation_speed: 1,
#		global.properties.zoom_speed: 0.2,
#		global.properties.health_max: 1000,
#		global.properties.health: 1000,
#		global.properties.bullet_speed: 800,
#		global.properties.bullet_strength: 50,
#		global.properties.bullet_wait: 0.3,
#		global.properties.bullet_range: 1000,
#		global.properties.weapon_rotation_speed: 1.5,
#		global.properties.clearance_rotation: 0.05
#	}

var properties_base = {
	global.properties.modifier_add: {},
	global.properties.modifier_multi: {}
}

func _ready():
	set_fixed_process(true)

func _fixed_process(delta) :
	var timer = get_node("timer_modifier")
	var progress = get_node("progress_modifer")

	if timer and progress:
		progress.set_value(timer.get_time_left() / timer.get_wait_time() * 100)
		set_rot(get_parent().get_global_rot() * -1)
		var payload_count = count_payloads() - 1
		progress.set_pos(Vector2(progress.get_pos().x, 60 + progress.get_size().height * payload_count))


# get all different properties from this ship
func get_property(type) :
	# if null, return all properties
	if (type == null) :
		return properties_base
	if (type in properties_base) :
		return properties_base[type]
	else :
		return null

func set_property(type, value):
	if (type in properties_base) :
		properties_base[type] = value


# if collectable was picket up and modifier runs out
func _on_timer_modifier_timeout():
	var parent = get_parent()
	parent.remove_child(self)
	# merges properties from all sub-nodes
	parent.properties = interface.collect_properties(parent)


# counts how many payloads a certain node has
# used for positioning the progressbar
func count_payloads():
	var parent = get_parent()
	var payload_count = 0
	for child in parent.get_children():
		if "payload" in child.get_name():
			payload_count += 1
	return payload_count
