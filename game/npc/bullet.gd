extends RigidBody2D

# owner/shooter of the bullet
var owner
# properties of the owner
var properties

func _ready():
	set_process(true)
	initialize()
	
func initialize():
	# add to group bullet
	add_to_group("bullet")
	
	connect("body_enter", self, "processCollision")

func set_owner(o) :
	owner = o
	if (o.has_method("get_properties")) :
		properties = o.get_properties();
	
	var starting_pos = o.get_node("weaponscope").get_global_pos()
	set_pos(starting_pos)
	var starting_rot = (o.get_node("weaponscope").get_global_rot()) + PI
	
	set_rot(starting_rot + PI)
	 
	var v2 = Vector2(  sin(starting_rot), cos(starting_rot)   ).normalized()
	set_linear_velocity(v2 * properties[global.properties.bullet_speed]);
	
	

func _process(delta):
	#if(owner.has_
	#speed = owner.get_property(globals.properties.bullet_speed)
	
	#translate( Vector2(0, properties[global.properties.bullet_speed] * delta) )
	pass


func _on_Bullet_area_enter( area ):
	print ("area enter bullet")
	
	print(area)
	if (area.has_method("can_destroy") and area.can_destroy()):
		print ("destroy able", area)
		pass
		#area.destroy()
		#queue_free()

func processCollision( object ):
	print ("body enter bullet")
	print(object)
	if (object.has_method("hit") and object.has_method("can_destroy") and object.can_destroy()):
		object.hit(properties[global.properties.bullet_strength])
		queue_free()

func _on_visibility_exit_screen():
	print ("out of screen bullet")
	queue_free()
