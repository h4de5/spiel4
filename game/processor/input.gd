extends "res://game/processor/processor.gd"

var input_group
var device_id = 0
var device_type = InputEvent.NONE

var input_actions = {
	"ui_left": 		global.actions.left,
	"ui_right": 	global.actions.right,
	"ui_up": 		global.actions.accelerate,
	"ui_down": 		global.actions.back,
	"ui_accept": 	global.actions.fire,
	#"ui_accept": 	global.actions.use,
	"ui_page_up": 	global.actions.zoom_in,
	"ui_page_down": global.actions.zoom_out,
	"ui_weapon_left": global.actions.target_left,
	"ui_weapon_right": global.actions.target_right,
}

func _ready():
	set_process_input(true)

func set_parent(p):
	parent = p
	
func set_processor_details(device_details):
	device_id = device_details[0]
	device_type = device_details[1]
	
func _input(event):
	print ("new event", event)
	if (event.device == device_id && event.type == device_type):
		if (event.type == InputEvent.MOUSE_MOTION):
			#parent.handle_mousemove(event.pos)
			# TODO - check if global_mouse_pos is realy the best way to do this
			parent.handle_mousemove(parent.get_global_mouse_pos())
		else:
			
			for e in input_actions :
				if event.is_action(e) :
					#parent.handle_action(input_actions[e], event.is_pressed(event))
					parent.handle_action(input_actions[e], Input.is_action_pressed(e))
	
	

