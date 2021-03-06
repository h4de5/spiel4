# baseclass for interfaces
extends Node2D

export var activated = false
var required_properties = {}
var parent

func _ready():
	#print("isable ready - start ", self.get_name())
	set_parent()
	call_deferred("check_requirements")
	#print("isable ready - end ", self.get_name())

func set_parent(p = null):
	if p == null:
		parent = get_parent()
	else:
		parent = p

func check_requirements():
	#print("isable check_requirements - start ", self.get_name())
	var ret = true

	if not parent or not parent.has_method("get_property"):
		print_error("function", "get_property")
		ret = false
	elif required_properties != null and required_properties.size() > 0:
		var props = parent.get_property(null)
		if props != null and props.size() > 0:
			for prop in required_properties :
				if not props.has(prop):
					print_error("property", prop)
					ret = false

	#print("isable check_requirements - end ", self.get_name(), " ok? ", ret)
	activated = ret
	return ret

func print_error(type, name):
	print("object ", parent.get_name(), " (", parent,
		") does not have ", type ," * ", name ," * to enable interface ",
		self.get_name(), " (", self, ")")