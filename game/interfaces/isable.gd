extends Node


export var activated = false
var required_properties = {}
var parent

func _ready():
	print("isable ready - start ", self.get_name())
	parent = get_parent()
	
	call_deferred("check_requirements")
	
	print("isable ready - end ", self.get_name())
	

func check_requirements():
	print("isable check_requirements - start ", self.get_name())
	var ret = true
	
	if not parent or not parent.has_method("get_property"):
		print("parent ", parent, " does not have get_properties function")
		ret = false
	elif required_properties != null and required_properties.size() > 0:
		var props = parent.get_property(null)
		
		if props != null and props.size() > 0:
			for prop in required_properties :
				if not props.has(prop): 
					print("parent ", parent, " is missing property ", prop)
					ret = false
	
	print("isable check_requirements - end ", self.get_name(), " ok? ", ret)
	activated = ret
	return ret


# those needs to be overwritten
func is_moveable():
	return false
func is_adjustable():
	return false
func is_destroyable():
	return false
func is_shootable():
	return false

func get_property(prop): 
	return parent.get_property(prop)