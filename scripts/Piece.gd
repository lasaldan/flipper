extends TextureRect

var type = "Block"
var size = 256

var currentPosition
var connected

var lineWidth = 30 
var positions

var lineColor
var endColor
var connectedColor

func _ready():
	var game = get_parent().get_parent()
	lineColor = game.lineColor
	endColor = game.endColor
	connectedColor = game.connectedColor
	
	if type == "Elbow":
		positions = [
			{north = false, east = false, south = true, west = true},
			{north = true, east = false, south = false, west = true},
			{north = true, east = true, south = false, west = false},
			{north = false, east = true, south = true, west = false},
		]
		
	elif type == "End":
		positions = [
			{north = false, east = false, south = false, west = true},
			{north = true, east = false, south = false, west = false},
			{north = false, east = true, south = false, west = false},
			{north = false, east = false, south = true, west = false},
		]
		
	elif type == "Straight":
		positions = [
			{north = false, east = true, south = false, west = true},
			{north = true, east = false, south = true, west = false},
			{north = false, east = true, south = false, west = true},
			{north = true, east = false, south = true, west = false},
		]
		
	elif type == "Tee":
		positions = [
			{north = false, east = true, south = true, west = true},
			{north = true, east = false, south = true, west = true},
			{north = true, east = true, south = false, west = true},
			{north = true, east = true, south = true, west = false},
		]
		
	elif type == "FourWay":
		positions = [
			{north = true, east = true, south = true, west = true},
			{north = true, east = true, south = true, west = true},
			{north = true, east = true, south = true, west = true},
			{north = true, east = true, south = true, west = true},
		]
		
	elif type == "Block":
		positions = [
			{north = true, east = true, south = true, west = true},
			{north = true, east = true, south = true, west = true},
			{north = true, east = true, south = true, west = true},
			{north = true, east = true, south = true, west = true},
		]

func _on_Piece_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed() and type != "Block" && !get_parent().get_parent().solved:
		currentPosition = (currentPosition + 1) % 4
		get_node("Animation").play("rotateTo" + str(currentPosition))
		get_parent().get_parent().validate()

func _draw():
	var color = lineColor

	if connected:
		color = connectedColor
		
	if type == "Elbow":
		draw_line(Vector2(size/2, size/2-lineWidth/2), Vector2(size/2, size), color, lineWidth)
		draw_line(Vector2(size/2-lineWidth/2, size/2), Vector2(0,size/2), color, lineWidth)

	elif type == "End":
		draw_line(Vector2(0, size/2), Vector2(size/2-lineWidth/2, size/2), color, lineWidth)
		draw_line(Vector2(size/2-lineWidth/2,size/2), Vector2(size/2+lineWidth/2,size/2), endColor, lineWidth)
		
	elif type == "Straight":
		draw_line(Vector2(0,size/2), Vector2(size,size/2), color, lineWidth)
		
	elif type == "Tee":
		draw_line(Vector2(0,size/2), Vector2(size,size/2), color, lineWidth)
		draw_line(Vector2(size/2, size/2 + lineWidth/2), Vector2(size/2,size), color, lineWidth)
	
	elif type == "FourWay":
		draw_line(Vector2(0,size/2), Vector2(size,size/2), color, lineWidth)
		#draw_line(Vector2(size/2,0), Vector2(size/2, size), color, lineWidth)
		draw_line(Vector2(size/2, size/2 + lineWidth/2), Vector2(size/2,size), color, lineWidth)
		draw_line(Vector2(size/2, size/2 - lineWidth/2), Vector2(size/2,0), color, lineWidth)
		
	elif type == "Block":
		var padding = 30
		draw_line(Vector2(padding, padding), Vector2(size-padding, padding), color, lineWidth)
		draw_line(Vector2(padding, padding), Vector2(padding, size-padding), color, lineWidth)
		draw_line(Vector2(padding, size-padding), Vector2(size-padding, size-padding), color, lineWidth)
		draw_line(Vector2(size-padding, padding), Vector2(size-padding, size-padding), color, lineWidth)