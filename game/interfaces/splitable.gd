# interface to make a node split on beeing destroy
extends "res://game/interfaces/isable.gd"

export(PackedScene) var left_part
export(PackedScene) var right_part

func is_splitable():
	if activated:
		return self
	else:
		return null

func _ready():
	call_deferred("initialize")

func initialize():

	if not is_splitable():
		return

	var destroyable = interface.is_destroyable(parent)
	if destroyable :
		destroyable.connect("been_destroyed", self, "_on_been_destroyed")


func _on_been_destroyed(by_whom):
	var resizeable
	var body_scale = Vector2(1,1)
	
#
#	if left_part or right_part:
#		# check if parent is resized
#		resizeable = interface.is_resizeable(parent)
#		if resizeable and resizeable.body_scale != Vector2(1,1):
#			body_scale = resizeable.body_scale
		
	if left_part:
		create_part(left_part, parent.get_property(global.properties.body_scale))

	if right_part :
		create_part(right_part, parent.get_property(global.properties.body_scale))
		

func create_part(part_scene, body_scale):
	var part = part_scene.instance()
	part.skip_reset_position = true
	get_tree().current_scene.add_child(part)
	part.position = parent.position
	part.rotation = parent.rotation
	part.linear_velocity = parent.linear_velocity
	part.angular_velocity = parent.angular_velocity
	call_deferred("resize_body_part", part, body_scale)

func resize_body_part(part, body_scale):
	var resizeable = interface.is_resizeable(part)
	if resizeable and body_scale != Vector2(1,1):
		resizeable.resize_body_to(body_scale)