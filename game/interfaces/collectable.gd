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
		#global.properties.pickup_modifier_duration,
	]

	#set_fixed_process(true)
	call_deferred("initialize")

func initialize():
	# get properties from pickup
	pickup_properties = parent.get_property(null)

	# if pickup_duration is set, start timer
	# remove collectable once timer is over
	var timer_show = pickup_properties[global.properties.pickup_duration]
	if timer_show > 0:
		get_node("timer_show").set_wait_time(timer_show)
		get_node("timer_show").start()
	# connect to body_enter event
	parent.connect("body_entered", self, "collect")


# called when something collected the pickup
func collect(body):
	#if body.is_in_group(global.groups.player) or body.is_in_group(global.groups.npc):
		#var body_properties = body.get_property(null)
	if has_node("payload"):
		var payload = get_node("payload")

		if pickup_properties[global.properties.pickup_type] == global.pickup_types.modifier :
			_handle_modifier(pickup_properties, payload, body)
		if pickup_properties[global.properties.pickup_type] == global.pickup_types.goods :
			_handle_goods(pickup_properties, payload, body)
	else:
		print ("pickup has no payload ..?!")

	call_deferred("collected", "collected")


func _handle_goods(pickup_properties, payload, body):

	var destroyable = interface.is_destroyable(body)
	if destroyable:
		for prop in pickup_properties.modifier_add:
			if prop == global.properties.health:
				destroyable.heal(pickup_properties.modifier_add[prop], self)
			if prop == global.properties.health_max:
				destroyable.life_up(pickup_properties.modifier_add[prop])

	# merges properties from all sub-nodes
	body.properties = interface.collect_properties(body)

func _handle_modifier(pickup_properties, payload, body):
	if pickup_properties.has(global.properties.modifier_multi) :
		payload.set_property(global.properties.modifier_multi, pickup_properties[global.properties.modifier_multi])
	if pickup_properties.has(global.properties.modifier_add) :
		payload.set_property(global.properties.modifier_add, pickup_properties[global.properties.modifier_add])

	# move payload to colliding body
	remove_child(payload)
	body.add_child(payload)

	var timer_modifier = pickup_properties[global.properties.pickup_modifier_duration]
	if timer_modifier > 0 :
		payload.start_modifier_timeout(timer_modifier)

	# merges properties from all sub-nodes
	body.properties = interface.collect_properties(body)


# if collectable was not picked up in time, remove it
func _on_timer_show_timeout():
	collected("timeout")

func collected(reason):
	# TODO: add cool effect here
	# reason can be timeout or collected
	if parent.has_method("collected") :
		parent.collected(reason)
	parent.queue_free()

