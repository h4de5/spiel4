# interface extends parent with explode particles/animation, area of destruction
extends "res://game/interfaces/isable.gd"

func is_explodeable():
	if activated:
		return self
	else:
		return null
		
func _ready():
	call_deferred("initialize")

func initialize():
	if not is_explodeable():
		return
	
	var destroy_able = interface.is_destroyable(parent)
	
	if destroy_able: 
		destroy_able.connect("been_destroyed", self, "explode")
	else:
		print("somethings wrong")
	
func explode(by_whom):
	print ("exploding...")
	var particles = get_node("Particles2D2")
	
	remove_child(particles)
	parent.get_parent().add_child(particles)
	particles.position = parent.position
	
	#particles.process_material.emission_sphere_radius = parent.width
	particles.emitting = 1
	particles.restart()