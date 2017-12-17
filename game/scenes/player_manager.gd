extends Node

var registered_devices = {
	InputEvent.KEY: [],
	InputEvent.JOYSTICK_BUTTON: []
	}

func _ready():
	set_process_input(true)

func _input(event):
	
	if (event.device != null && event.type != InputEvent.NONE) :
		print("device input ", event.device, " with type ", event.type)
		var inputtype = null
		if(event.type == InputEvent.KEY or event.type == InputEvent.MOUSE_MOTION) :
			inputtype = InputEvent.KEY
		elif(event.type == InputEvent.JOYSTICK_MOTION or event.type == InputEvent.JOYSTICK_MOTION ) :
			inputtype = InputEvent.JOYSTICK_BUTTON
		
			
		if(inputtype != null && not registered_devices[inputtype].has(event.device)) :
			registered_devices[inputtype].append(event.device)
			get_parent().spawn_player("Input", [event.device, inputtype])
			
		