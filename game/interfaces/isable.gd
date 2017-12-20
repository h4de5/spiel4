extends Node

var required_properties = {}
var parent

func _ready():
	print("im ready isable - anfang")
	parent = get_parent()
	print("im ready isable - ende")
	

func check_requirements():
	print("im ready check_requirements - anfang")
	var ret = true
	if not parent or not parent.has_method("get_properties"):
		print("parent ", parent, " does not have get_properties function")
		return false
	
	if required_properties != null and required_properties.size() > 0:
		var props = parent.get_properties()
		
		if props != null and props.size() > 0:
			for prop in required_properties :
				if not props.has(prop): 
					print("parent ", parent, " is missing property ", prop)
					ret = false
	
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

func get_property():
	pass
