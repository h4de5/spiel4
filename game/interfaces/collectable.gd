extends "res://game/interfaces/isable.gd"

var pickup_properties

func is_collectable():
	if activated:
		return self
	else:
		return null

func _ready():
	required_properties = [
		global.properties.pickup_type,
		global.properties.pickup_duration,
		#global.properties.pickup_modifier_mode,
		global.properties.pickup_modifier_duration,
	]


	#set_fixed_process(true)
	call_deferred("initialize")

func initialize():
	pickup_properties = parent.get_property(null)

	var timer_show = pickup_properties[global.properties.pickup_duration]
	if timer_show > 0:
		get_node("timer_show").set_wait_time(timer_show)
		get_node("timer_show").start()
	parent.connect("body_enter", self, "process_collect")

	get_node("payload/progress_modifer").hide()

#func _fixed_process(delta) :
#	pass

func process_collect(body):
	#print("something entered pickup body ", body)
	collect(body)

func collect(body):

	if body.is_in_group(global.groups.player) or body.is_in_group(global.groups.enemy):
		#var body_properties = body.get_property(null)

		if has_node("payload"):
			var payload = get_node("payload")

			get_node("payload/progress_modifer").show()

			if pickup_properties.has(global.properties.modifier_multi) :
				payload.set_property(global.properties.modifier_multi, pickup_properties[global.properties.modifier_multi])
			if pickup_properties.has(global.properties.modifier_add) :
				payload.set_property(global.properties.modifier_add, pickup_properties[global.properties.modifier_add])

			var timer_modifier = pickup_properties[global.properties.pickup_modifier_duration]
			if timer_modifier > 0 :
				payload.get_node("timer_modifier").set_wait_time(timer_modifier)
				payload.get_node("timer_modifier").start()

			# move payload to colliding body
			remove_child(payload)
			body.add_child(payload)

			# merges properties from all sub-nodes
			body.properties = interface.collect_properties(body)

			call_deferred("collected", "collected")

# if collectable was not picked up in time, remove it
func _on_timer_show_timeout():
	collected("timeout")

func collected(reason):
	# TODO: add cool effect here
	# reason can be timeout or collected
	if parent.has_method("collected") :
		parent.collected(reason)
	parent.queue_free()

