# handles input from keyboard. mouse and controllers,
# used in processor selector, baseship and moveable interface

extends "res://game/processor/processor.gd"

var input_group
var device_id = 0
var device_types = []
const controller_stick_deadzone = 0.1
var left_stick_direction = Vector2()
var mouse_hold_left = false;
var mouse_hold_right = false;

func _ready():
	set_process_input(true)
	moveable = interface.is_moveable(parent)
	shootable = interface.is_shootable(parent)
	connect("tree_exiting", self, "_on_input_tree_exiting")

func set_processor_details(device_details):
	device_id = device_details[0]
	device_types = device_details[1]
	input_group = device_details[2]

func reset_processor_details():
	input_group = null
	device_id = 0
	device_types = []
	# InputEvent.NONE

# func setup_input_map():
	#for old_event in InputMap.get_action_list(action_name):
	#	if old_event is InputEventKey:
	#		InputMap.action_erase_event(action_name, old_event)



func _input(event):
	# FIXME - check with: shootable = interface.is_shootable()

	if event.is_echo():
		get_tree().set_input_as_handled()
		return

	#var moveable = interface.is_moveable(parent)
	#var shootable = interface.is_shootable(parent)
	if (event.device == device_id && device_types.has(event.get_class())):
		if (event is InputEventMouseMotion):

			get_tree().set_input_as_handled()

			# drag and move
			if mouse_hold_left:
				moveable.handle_target(moveable.get_global_mouse_position())

			# TODO - check if global_mouse_pos is realy the best way to do this
			if shootable :
				shootable.handle_mousemove(parent.get_global_mouse_position())
		elif (event is InputEventMouseButton):
			if moveable:
				if event.is_pressed():

					if event.button_index == BUTTON_LEFT:
						moveable.handle_target(moveable.get_global_mouse_position())
						mouse_hold_left = true

					elif event.button_index == BUTTON_RIGHT:
						# reset target on right click
						moveable.handle_target(Vector2(0,0))
						mouse_hold_right = true

					elif event.button_index == BUTTON_MIDDLE:
						moveable.get_parent().position = Vector2(0,0)
				else:
					if event.button_index == BUTTON_LEFT:
						mouse_hold_left = false

					elif event.button_index == BUTTON_RIGHT:
						mouse_hold_right = false

		elif (event is InputEventJoypadMotion):
			match event.axis:
				0,1: # left stick x-axis
					get_tree().set_input_as_handled()
					var axis_value = abs(event.axis_value)
					var axis_value_sign = sign(event.axis_value)

					if axis_value < controller_stick_deadzone:
						axis_value = 0
					else:
						axis_value = range_lerp(axis_value, controller_stick_deadzone, 1, 0, 1)

					axis_value = axis_value * axis_value_sign
					if event.axis == 0:
						left_stick_direction.x = axis_value
					elif event.axis == 1:
						left_stick_direction.y = axis_value

					if moveable:
						moveable.handle_direction(left_stick_direction)

				6: # left trigger
					get_tree().set_input_as_handled()
					# ship.handle_action(Action.Accelerate, event.axis_value)
					if moveable:
						moveable.handle_action(global.actions.fire, event.axis_value)

				7: # right trigger
					get_tree().set_input_as_handled()
					if moveable:
						moveable.handle_action(global.actions.accelerate, event.axis_value)
				_: # default
					print("print unknown controller axis: ", event.axis)
		else:
			#print ("got event ", event)

			for e in input_manager.input_map :
				if InputMap.has_action(e) && event.is_action(e) :
					# do not set mouse input as handled
					# otherwise gui buttons cannot be clicked
					if (not event is InputEventMouseButton):
						get_tree().set_input_as_handled()
					if moveable:
						moveable.handle_action(input_manager.input_map[e]["action"], Input.is_action_pressed(e))
					if shootable:
						shootable.handle_action(input_manager.input_map[e]["action"], Input.is_action_pressed(e))
				elif !InputMap.has_action(e):
					print("Action ", e, " is currently not in the input map, maybe somethings wrong with the initialization")


#			if event is InputEventKey:
#				var camera = get_node(global.scene_tree_camera)
#				match event.scancode:
#					KEY_I:
#						get_tree().set_input_as_handled()
#						camera.position.y -= 20
#					KEY_J:
#						get_tree().set_input_as_handled()
#						camera.position.x -= 20
#					KEY_K:
#						get_tree().set_input_as_handled()
#						camera.position.y += 20
#					KEY_L:
#						get_tree().set_input_as_handled()
#						camera.position.x += 20




# if player is removed, remove from device list in player_manager
func _on_input_tree_exiting():
	if input_group:
		player_manager.unregister_device(input_group, device_id)
	reset_processor_details()