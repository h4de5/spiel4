extends Node


var input_map = {
	"ui_left": {
		"action": global.actions.left,
		"scancodes_key": [KEY_LEFT, KEY_A],
		"scancodes_dpad": [JOY_DPAD_LEFT, JOY_BUTTON_14],
		"scancodes_mouse": [],
	},
	"ui_right": {
		"action": global.actions.right,
		"scancodes_key": [KEY_RIGHT, KEY_D],
		"scancodes_dpad": [JOY_DPAD_RIGHT, JOY_BUTTON_15],
		"scancodes_mouse": [],
	},
	"ui_up": {
		"action": global.actions.accelerate,
		"scancodes_key": [KEY_UP, KEY_W,],
		"scancodes_dpad": [JOY_DPAD_UP, JOY_BUTTON_12],
		"scancodes_mouse": [],
	},
	"ui_down": {
		"action": global.actions.back,
		"scancodes_key": [KEY_DOWN, KEY_S],
		"scancodes_dpad": [JOY_DPAD_DOWN, JOY_BUTTON_13],
		"scancodes_mouse": [],
	},

	"ui_accept": {
		"action": global.actions.fire,
		"scancodes_key": [KEY_SHIFT, KEY_CONTROL],
		"scancodes_dpad": [JOY_BUTTON_0],
		"scancodes_mouse": [BUTTON_XBUTTON1],
	},
	"ui_select": {
		"action": global.actions.use,
		"scancodes_key": [KEY_ENTER, KEY_TAB],
		"scancodes_dpad": [JOY_BUTTON_3],
		"scancodes_mouse": [BUTTON_XBUTTON2],
	},
#	"ui_cancel": {
#		"action": global.actions.cancel,
#		"scancodes_key": [KEY_BACKSPACE, KEY_Q],
#		"scancodes_dpad": [JOY_BUTTON_1],
#		"scancodes_mouse": [BUTTON_MIDDLE],
#	},
}

func _ready():
	# rebuild input map from list above

	build_input_map()
	# test_input_map()

func build_input_map():
	for action_identifier in input_map :
		# remove everything first
		InputMap.action_erase_events(action_identifier)
		InputMap.erase_action(action_identifier)

		# add it again
		InputMap.add_action(action_identifier)

		for scancode in input_map[action_identifier]["scancodes_key"] :
			var ev = InputEventKey.new()
			ev.scancode = scancode
			InputMap.action_add_event(action_identifier, ev)
		for scancode in input_map[action_identifier]["scancodes_dpad"] :
			var ev = InputEventJoypadButton.new()
			ev.button_index = scancode
			InputMap.action_add_event(action_identifier, ev)
		for scancode in input_map[action_identifier]["scancodes_mouse"] :
			var ev = InputEventMouseButton.new()
			ev.button_index = scancode
			InputMap.action_add_event(action_identifier, ev)


func test_input_map():
	print("input actions: ", InputMap.get_actions())
	for action in InputMap.get_actions() :
		print("event for ", action, ": ", InputMap.get_action_list(action))
		for event in InputMap.get_action_list(action) :
			if event is InputEventJoypadButton:
				print("event for ", event.button_index )
			else:
				print("event for ", event)
