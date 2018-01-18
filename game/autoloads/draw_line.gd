extends Node

var drawn_lines = {
}

func update_line(parent, ownpos, targetpos):
	drawn_lines[parent] = [ownpos, targetpos]
	update()

func _draw():
	for lines in drawn_lines:
		draw_line(drawn_lines[lines][0], drawn_lines[lines][1], Color(1,1,1))
