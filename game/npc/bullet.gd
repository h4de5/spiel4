extends RigidBody2D

# owner/shooter of the bullet
var owner
# properties of the owner
var properties

var starting_pos

func _ready():
	set_fixed_process(true)
	initialize()
	
func initialize():
	# add to group bullet
	add_to_group(global.groups.bullet)
	
	connect("body_enter", self, "processCollision")

func set_owner(o) :
	owner = o
	if (o.has_method("get_property")) :
		properties = o.get_property(null)
		
	add_collision_exception_with(o)
	
	starting_pos = o.get_node("weapon").get_global_pos()
	set_pos(starting_pos)
	var starting_rot = (o.get_node("weapon").get_global_rot()) + PI
	set_rot(starting_rot + PI)
	 
	var v2 = Vector2(  sin(starting_rot), cos(starting_rot)   ).normalized()
	set_linear_velocity(v2 * properties[global.properties.bullet_speed]);

#func _process(delta):
	#if(owner.has_
	#speed = owner.get_property(globals.properties.bullet_speed)
	
	#translate( Vector2(0, properties[global.properties.bullet_speed] * delta) )
#	pass

func _fixed_process(delta):
	if(get_pos().distance_to(starting_pos) > properties[global.properties.bullet_range]) : 
		destroy("range_over")

func processCollision( object ):
	#print ("body enter bullet")
	#print(object)
	if (object.has_method("hit") and 
		object.has_method("is_destroyable") and 
		object.is_destroyable()) :
		object.hit(properties[global.properties.bullet_strength], owner)
		destroy(object)


func _on_visibility_exit_screen():
	#print ("out of screen bullet")
	destroy("range_out")
	
func destroy(destroyer) :
	# TODO add cool animation - 
	queue_free()
