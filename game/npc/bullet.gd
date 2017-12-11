extends Area2D

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

func _process(delta):
	#if(owner.has_
	#speed = owner.get_property(globals.properties.bullet_speed)
	translate( Vector2(0, properties[global.properties.bullet_speed] * delta) )


func _on_Bullet_area_enter( area ):
	print ("area enter")
	
	print(area)
	if (area.has_method("can_destroy") and area.can_destroy()):
		print ("destroy able", area)
		pass
		#area.destroy()
		#queue_free()

func processCollision( object ):
	print ("body enter")
	print(object)
	if (object.has_method("hit") and object.has_method("can_destroy") and object.can_destroy()):
		object.hit(properties[global.properties.bullet_strength])

func _on_visibility_exit_screen():
	print ("out of screen")
	queue_free()
