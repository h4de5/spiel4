extends Node

var registered_devices = {
	InputEvent.KEY: [],
	InputEvent.JOYSTICK_BUTTON: []
	}
	
var device_groups = {
	InputEvent.KEY: [InputEvent.KEY, InputEvent.MOUSE_MOTION, InputEvent.MOUSE_BUTTON ],
	InputEvent.JOYSTICK_BUTTON: [InputEvent.JOYSTICK_BUTTON, InputEvent.JOYSTICK_MOTION]
}

func _ready():
	set_process_input(true)

func _input(event):
	
	if (event.device != null && event.type != InputEvent.NONE) :
		#print("device input ", event.device, " with type ", event.type)
		var inputtype = null
		for device_group in device_groups :
			if device_groups[device_group].has(event.type):
				inputtype = device_group
				break
			
		if(inputtype != null && not registered_devices[inputtype].has(event.device)) :
			registered_devices[inputtype].append(event.device)
			get_parent().spawn_player("Input", [event.device, device_groups[inputtype]])
			
		