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

# geht - is blöd
#export(Array) var modifier_add
# geht - kann ned geändert werden
# export(Dictionary) var modifier_multi
# geht ned
#export(String, global.properties.movement_speed_forward, global.properties.movement_speed_back, global.properties.ship_rotation_speed, global.properties.weapon_rotation_speed, global.properties.bullet_speed, global.properties.bullet_strength, global.properties.bullet_wait, global.properties.bullet_range) var export_modifier
# geht - is blöd
#export(String, "global.properties.movement_speed_forward", "global.properties.movement_speed_back") var export_modifier
# geht ned
#export(Array, String) var modifier_add

export(String, "", "modifier_add", "modifier_multi") var modifier_type
#export var modifier_names = StringArray()
#export var modifier_values = FloatArray()
export var modifier_exports = StringArray()
export(float) var modifier_timer

var properties_base = {
	global.properties.modifier_add: {},
	global.properties.modifier_multi: {}
}

func _ready():
	set_fixed_process(true)

	get_node("progress_modifer").hide()

	# merges properties from all sub-nodes
	if modifier_exports.size() > 0 and modifier_type:

		for idx in range(0, modifier_exports.size(), 2):
			properties_base[modifier_type][modifier_exports[idx]] = float(modifier_exports[idx+1])

		if "properties" in get_parent():
			get_parent().properties = interface.collect_properties(get_parent())

		if modifier_timer :
			start_modifier_timeout(modifier_timer)


func _fixed_process(delta) :
	var timer = get_node("timer_modifier")
	var progress = get_node("progress_modifer")

	if timer and progress and progress.is_visible():
		progress.set_value(timer.get_time_left() / timer.get_wait_time() * 100)
		set_rot(get_parent().get_global_rot() * -1)
		var payload_count = get_own_payload_position() - 1
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

func start_modifier_timeout(timer):
	get_node("timer_modifier").set_wait_time(timer)
	get_node("timer_modifier").start()
	get_node("progress_modifer").show()

# if collectable was picket up and modifier runs out
func _on_timer_modifier_timeout():
	var parent = get_parent()
	parent.remove_child(self)
	# merges properties from all sub-nodes
	parent.properties = interface.collect_properties(parent)

# goes through all payloads of parent and
# returns position of current payload
# used for positioning the progressbar
func get_own_payload_position():
	var parent = get_parent()
	var payload_count = 0
	var payload_current = 0
	for child in parent.get_children():
		if "payload" in child.get_name():
			if child.has_node("progress_modifer") and child.get_node("progress_modifer").is_visible():
				payload_count += 1
		# get own position in payload list
		if child == self:
			payload_current = payload_count
	return payload_current


func revamp_progress(color):
	var progress = get_node("progress_modifer")
	var stylebox = StyleBoxFlat.new()
	#var v2 = Vector2()
	stylebox.set_bg_color(color)
	#progress.get("custom_styles/fg").set_bg_color(color)
	#progress.draw_style_box(stylebox)
	progress.set('custom_styles/fg', stylebox)
