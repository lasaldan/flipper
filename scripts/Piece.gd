extends TextureRect

var type = "Elbow"
var size = 256

var currentPosition
var connected

var lineWidth = 30
var positions

func _ready():
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

func _on_Piece_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		currentPosition = (currentPosition + 1) % 4
		get_node("Animation").play("rotateTo" + str(currentPosition))
		get_parent().get_parent().validate()

func _draw():
	var lineColor = Color(255,255,255)
	var endColor = Color(0,0,100)
	if connected:
		lineColor = Color(0,160,255)
		
	if type == "Elbow":
		draw_line(Vector2(size/2, size/2-lineWidth/2), Vector2(size/2, size), lineColor, lineWidth)
		draw_line(Vector2(size/2, size/2), Vector2(0,size/2), lineColor, lineWidth)

	elif type == "End":
		draw_line(Vector2(0, size/2), Vector2(size/2-lineWidth/2, size/2), lineColor, lineWidth)
		draw_line(Vector2(size/2-lineWidth/2,size/2), Vector2(size/2+lineWidth/2,size/2), endColor, lineWidth)
		
	elif type == "Straight":
		draw_line(Vector2(0,size/2), Vector2(size,size/2), lineColor, lineWidth)
		
	elif type == "Tee":
		draw_line(Vector2(0,size/2), Vector2(size,size/2), lineColor, lineWidth)
		draw_line(Vector2(size/2, size/2), Vector2(size/2,size), lineColor, lineWidth)
	
	elif type == "FourWay":
		draw_line(Vector2(0,size/2), Vector2(size,size/2), lineColor, lineWidth)
		draw_line(Vector2(size/2,0), Vector2(size/2, size), lineColor, lineWidth)