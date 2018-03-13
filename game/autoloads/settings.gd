extends Node

var game = {}

func _ready():

	load_config_file("res://game.cfg")
	load_config_file("res://game-override.cfg")
	load_config_file("user://game-override.cfg")

func load_config_file(file):

	var doFileExists = File.new().file_exists(file)

	if doFileExists:
		var config = ConfigFile.new()
		var err = config.load(file)
		if err == OK: # if not, something went wrong with the file loading
			# Look for the display/width pair, and default to 1024 if missing
			game['display_width'] = config.get_value("display", "width", 1024)
			game['display_height'] = config.get_value("display", "height", 700)

			game['server_default_port'] = config.get_value("server", "default_port", 8910)
			game['client_lobby_url'] = config.get_value("client", "lobby_url")
	#
	#		# Store a variable if and only if it hasn't been defined yet
	#		if not config.has_section_key("audio", "mute"):
	#		    config.set_value("audio", "mute", false)
	#		# Save the changes by overwriting the previous file
	#		config.save("user://settings.cfg")
		else:
			printerr("Please check your settings in ", file ," - it seems to be malformed or missing")


