extends Node

var current_processor
var processor_input
var processor_network
var processor_ai

func _ready():
	processor_input = get_node("Input")
	processor_network = get_node("Network")
	processor_ai = get_node("AI")
	
	remove_processor()

func remove_processor() :
	if has_node("Input"):
		remove_child(processor_input)
	if has_node("Network"):
		remove_child(processor_network)
	if has_node("AI"):
		remove_child(processor_ai)

func set_processor(processor) :
	
	remove_processor()
	
	if processor == "Input" :
		current_processor = processor_input
	if processor == "Network" :
		current_processor = processor_network
	if processor == "AI" :
		current_processor = processor_ai
		
	add_child(current_processor)

func get_processor() :
	return current_processor