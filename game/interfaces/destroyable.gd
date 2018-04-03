# interface extends parent with healthbar, hit and destroy methods
extends "res://game/interfaces/isable.gd"

var health_node = null

signal been_destroyed(by_whom)
signal been_hit(power, by_whom)

func is_destroyable():
	if activated:
		return self
	else:
		return null

func _ready():
	required_properties = [
		global.properties.health,
		global.properties.health_max
	]
	call_deferred("initialize")
	set_process(true)

func initialize():
	# Health bar
	if not is_destroyable():
		return

	if parent.has_method("destroy"):
		self.connect("been_destroyed", parent, "destroy")
	if parent.has_method("hit"):
		self.connect("been_hit", parent, "hit")

func _process(delta):
	#if target != "" and get_node(target) != null:
	#	set_pos(get_node(target).get_pos());
	if parent != null:
		# to prevent error when ship is destroyed
		var wr = weakref(parent);
		if wr.get_ref():

			set_rotation(parent.get_global_rotation() * -1)

			if not parent.has_method("get_property"):
				# BUG - bei vielen gegner tritt hier immer wieder ein fehler auf
				# owner ist eine bullet (?) oder eine Progressbar (?)
				# Invalid call. Nonexistent function 'get_property' in base 'RigidBody2D (bullet.gd)'.
				#get_tree().set_pause(true)
				queue_free()
			else :
				var health_max = parent.get_property(global.properties.health_max)
				var health = parent.get_property(global.properties.health)

				if health < 0:
					health = 0
				if health > health_max:
					health = health_max

				if has_node("progress_health"):
					var progressbar = get_node("progress_health")
					progressbar.set_max(health_max)
					progressbar.set_value(health)

remote func destroy(by_whom, force = false):
	print("destroy called..")
	if network_manager.is_offline() or network_manager.is_server() or force:
		print(".. forced or server")
		emit_signal("been_destroyed", by_whom)
		parent.queue_free()
	else:
		print(".. ignored ..")

	if network_manager.is_server():
		print(".. and forwarded")
		rpc("destroy", by_whom, true)

func heal(power, healer):
	if parent.has_method("heal") :
		parent.heal(power, healer)

	var health
	health = parent.get_property(global.properties.health) + power
	health = min(health, parent.get_property(global.properties.health_max))
	parent.set_property(global.properties.health, health)

func life_up(power):
	if parent.has_method("life_up") :
		parent.life_up(power)

	var health_max
	health_max = parent.get_property(global.properties.health_max) + power
	#health = min(health, parent.get_property(global.properties.health_max))
	parent.set_property(global.properties.health_max, health_max)


func hit(power, by_whom):

	emit_signal("been_hit", power, by_whom)

	#if parent.has_method("hit") :
	#	parent.hit(power, by_whom)

	var health
	health = parent.get_property(global.properties.health) - power
	parent.set_property(global.properties.health, health)

	if (health <= 0):
		destroy(by_whom)
		#get_node("anim").play("explode")
		#destroyed=true