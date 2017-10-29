extends Node

var parent

#export(String, "none", "input", "ai", "network") var processor = "none"
export(PackedScene) var processor

func _ready():
	parent = get_parent()
	if processor != null :
		var processor_instance = processor.instance()
		add_child(processor_instance)
	"""
	if processor != "none" : 
	
		# Load the class resource when calling load()
		var processor_class = load("game/"+processor+".gd")
		
		# Preload the class only once at compile time
		# won't work here 
		#var processor_class = preload("game/"+processor+".gd")
	
	    var processor_instance = processor_class.new()
	    processor_instance._ready()
	"""

func set_processor(proc):
	processor = proc
	#processor.set_parent(self)