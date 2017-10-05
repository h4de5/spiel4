extends RigidBody2D

var lifetime = 3

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	var timer = Timer.new()
	timer.set_wait_time(lifetime)
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	
	# explode();
	var player = get_node("AnimationPlayer")
	player.play("Explosion")
	
	yield(player, "finished")
	queue_free()
	
	pass

func explode(): 
	get_node("Sprite").set_module(Color(1,0,0))