extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var delta_count = 0;
var delta_max = 0.3
var speed = 1;
export (NodePath) var health_label;

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	randomize();
	speed = rand_range(2,5)
	
	#print ("lerp", lerp(2, 5, speed))
	#get_node("Sprite").set_modulate(Color(lerp(2, 5, speed), 0, 0))

func _fixed_process(delta):
	processInput(delta)

func processInput(delta):
	
	delta_count += delta
	if delta_count > delta_max :
		var tree = get_tree()
		var scene = tree.get_current_scene()
		var player = scene.get_node("/root/Game/Player")
		var playerpos = player.get_pos()
		var obstaclepos = get_pos();
		var obstaclerot = get_rot();
		
		#get_transform().rotated()
		#print ("drehung: ", get_rot(), "cos: ", cos(get_rot()), "sin: ", sin(get_rot()))
		
		var forwardvec = Vector2(sin(get_rot()), cos(get_rot()))*-1
		var playervec = (playerpos - obstaclepos).normalized()
		
		var angle = playervec.angle_to(forwardvec)
		set_angular_velocity(angle);
		#apply_impulse(Vector2(0,0),(playerpos - obstaclepos).normalized()*
		
		#set_angular_velocity(
		apply_impulse(Vector2(0,0), forwardvec);
		
		
		#delta_count -= delta_max
	
	#add_force( get_pos(), movevector )
	#apply_impulse(Vector2(0,0), movevector)