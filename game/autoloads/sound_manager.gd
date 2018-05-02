extends Node

var sounds = []

func _ready():
	sounds = []

func play(sound, position = null, parent = null):
	var player
	
	if position != null:
		player = AudioStreamPlayer2D.new()
		player.position = position
		parent = get_node(global.scene_tree_sounds)
	elif parent != null:
		player = AudioStreamPlayer2D.new()
	else:
		player = AudioStreamPlayer.new()
		parent = get_node(global.scene_tree_sounds)
		
	# add sound to game scene
	parent.add_child(player)
	# add finished handler
	player.connect("finished", self, "on_sound_finished", [player])
		
	if typeof(sound) == TYPE_STRING:
	# if sound is string:
		player.stream = load(sound)
	else:
		player.stream = sound
	# play the sound
	player.play()
	
	# add to list of sounds
	sounds.append(player)
	
	

func on_sound_finished(sound):
	print("sound finished", sound)
	# find sound ?
	sounds.find(sound)
	# if has sound, remove it	
	if sounds.has(sound):
		sounds.erase(sound)
		
	# remove from game scene
	sound.queue_free();
	