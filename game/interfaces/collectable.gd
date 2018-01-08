extends "res://game/interfaces/isable.gd"

func is_collectable():
	if activated:
		return self
	else:
		return null

func _ready():
	required_properties = [
		global.properties.pickup_type,
		global.properties.pickup_duration,
		global.properties.pickup_modifier_mode,
		global.properties.pickup_modifier_duration,
	]
	set_fixed_process(true)
	call_deferred("initialize")

func initialize():
	var timer_show = parent.get_property(global.properties.pickup_duration)
	if timer_show > 0:
		get_node("timer_show").set_wait_time(timer_show)
		get_node("timer_show").start()
	parent.connect("body_enter", self, "process_collect")

func _fixed_process(delta) :

	pass

func process_collect(body):
	#print("something entered pickup body ", body)
	collect(body)

func collect(body):

	var pickup_properties = parent.get_property(null)

	if body.is_in_group(global.groups.player) :
		var body_properties = body.get_property(null)

		var payload = get_node("payload")

		if pickup_properties.has(global.properties.modifier_multi) :
			payload.set_property(global.properties.modifier_multi, pickup_properties[global.properties.modifier_multi])
		if pickup_properties.has(global.properties.modifier_add) :
			payload.set_property(global.properties.modifier_add, pickup_properties[global.properties.modifier_add])

		var timer_modifier = pickup_properties[global.properties.pickup_modifier_duration]
		if timer_modifier > 0 :
			payload.get_node("timer_modifier").set_wait_time(timer_modifier)
			payload.get_node("timer_modifier").start()

		remove_child(payload)
		body.add_child(payload)



		call_deferred("hide")


func hide():
	# getnode("nodename").set("focus/ignore_mouse", true)
	# TODO: add cool effect here
	parent.get_parent().remove_child(parent)
	#visibility.visible = false

func clear():
	parent.queue_free()

# if collectable was not picked up in time, remove it
func _on_timer_show_timeout():
	clear()

