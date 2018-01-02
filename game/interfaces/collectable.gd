extends "res://game/interfaces/isable.gd"

func is_collectable():
	if activated:
		return self
	else:
		return null

func _ready():
	required_properties = [
		global.properties.pickup_type,
		global.properties.pickup_modifier_mode,
		global.properties.pickup_modifier_duration
	]

	call_deferred("initialize")

func collect(body):

	var pickup_properties = parent.get_property(null)

	if body.is_in_group(global.groups.player) :
		var body_properties = body.get_property(null)
		hide()


func hide():
	# getnode("nodename").set("focus/ignore_mouse", true)
	# TODO: add cool effect here
	parent.get_parent().remove_child(parent)
	#visibility.visible = false

func clear():
	queue_free()