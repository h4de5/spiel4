extends "res://game/processor.gd"

var input_group
var input_actions

var input_player1 = {
	"ui_left": 		global.actions.left,
	"ui_right": 	global.actions.right,
	"ui_up": 		global.actions.accelerate,
	"ui_down": 		global.actions.back,
	"ui_select": 	global.actions.fire,
	"ui_accept": 	global.actions.use,
	"ui_page_up": 	global.actions.zoom_in,
	"ui_page_down": global.actions.zoom_out
}

# action-name > possible action in baseship
var input_player2 = {
	"ui_left": "left",
	"ui_right": "right",
	"ui_up": "accelerate",
	"ui_down": "break",
	"ui_select": "fire",
	"ui_accept": "use",
	"ui_page_up": "zoom_in",
	"ui_page_down": "zoom_out"
}

func _ready():
	set_process_input(true)
	# default - use player1 inputs
	input_group = 1
	input_actions = input_player1

func set_parent(p):
	parent = p
	
func set_input_group(groupid):
	input_group = groupid
	if input_group == 1:
		input_actions = input_player1
	pass

func _input(event):
	# input_actions =
	# 	"ui_left": "left",
	# 	e : input_actions[e]
	for e in input_actions :
		if event.is_action(e) :
			parent.handle_action(input_actions[e], event.is_pressed())
		
		"""
		if event.is_action_pressed(e) :
			parent.handle_action(input_actions[e], true)
		elif event.is_action_released(e) :
			parent.handle_action(input_actions[e], false)
		"""
	
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.button_index == BUTTON_WHEEL_UP: parent.handle_action(global.actions.zoom_in, true) #zoom += multi_zoom
		if event.button_index == BUTTON_WHEEL_DOWN: parent.handle_action(global.actions.zoom_out, true) #zoom = zoom-multi_zoom if zoom > 1 else 1
