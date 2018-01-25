# handles input from keyboard. mouse and controllers,
# used in processor selector, baseship and moveable interface

extends "res://game/processor/processor.gd"

var input_group
var device_id = 0
var device_types = [InputEvent.NONE]

var input_actions = {
	"ui_left": 		global.actions.left,
	"ui_right": 	global.actions.right,
	"ui_up": 		global.actions.accelerate,
	"ui_down": 		global.actions.back,
	"ui_accept": 	global.actions.fire,
	#"ui_accept": 	global.actions.use,
	#"ui_page_up": 	global.actions.zoom_in,
	#"ui_page_down": global.actions.zoom_out,
	"ui_weapon_left": global.actions.target_left,
	"ui_weapon_right": global.actions.target_right,
}

func _ready():
	set_process_input(true)
	moveable = interface.is_moveable(parent)
	shootable = interface.is_shootable(parent)

func set_processor_details(device_details):
	device_id = device_details[0]
	device_types = device_details[1]
	input_group = device_details[2]

func reset_processor_details():
	input_group = null
	device_id = 0
	device_types = [InputEvent.NONE]

func _input(event):
	# FIXME - check with: shootable = interface.is_shootable()

	#var moveable = interface.is_moveable(parent)
	#var shootable = interface.is_shootable(parent)

	if (event.device == device_id && device_types.has(event.type)):
		if (event.type == InputEvent.MOUSE_MOTION):
			#parent.handle_mousemove(event.pos)
			# TODO - check if global_mouse_pos is realy the best way to do this
			if shootable:
				shootable.handle_mousemove(parent.get_global_mouse_pos())
		else:
			print ("got event ", event)
			for e in input_actions :

				if event.is_action(e) :

					#parent.handle_action(input_actions[e], event.is_pressed(event))
					if moveable:
						moveable.handle_action(input_actions[e], Input.is_action_pressed(e))
					if shootable:
						shootable.handle_action(input_actions[e], Input.is_action_pressed(e))


func _on_Input_exit_tree():
	if input_group:
		var player_manager = get_node(global.scene_tree_player_manager)
		player_manager.unregister_device(input_group, device_id)
	reset_processor_details()