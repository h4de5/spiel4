# provides methods to select a specific processor for a baseship
extends Node

#var current_processor
export(String, "none", "Input", "Network", "AI") var use_processor
#export PackedScene current_processor
#export(Array, PackedScene) var current_processor
var current_processor
var processor_input
var processor_network
var processor_ai

func _ready():
	processor_input = get_node("Input")
	processor_network = get_node("Network")
	processor_ai = get_node("AI")

	if use_processor:
		set_processor(use_processor)
	else:
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
	elif processor == "Network" :
		current_processor = processor_network
	elif processor == "AI" :
		current_processor = processor_ai
	else:
		current_processor = null

	if current_processor :
		use_processor = processor
		add_child(current_processor)
		current_processor.set_parent(get_parent())

func set_processor_details(device_details):
	if current_processor:
		current_processor.set_processor_details(device_details)

func get_processor() :
	return current_processor

