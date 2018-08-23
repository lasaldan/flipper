extends TextureRect

var type = "Elbow"
var size = 256
var correctPositions
var currentPosition
var rotatable
var lineWidth = 30

func _ready():
	#size = get_tree().root.get_node("Main/Global").pieceSize
	pass

func _on_Piece_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		currentPosition = (currentPosition + 1) % 4
		get_node("Animation").play("rotateTo" + str(currentPosition))

func _draw():
	if type == "Elbow":
		draw_line(Vector2(size/2, size/2+lineWidth/2), Vector2(size/2, 0), Color(255,255,255), lineWidth)
		draw_line(Vector2(size/2, size/2), Vector2(0,size/2), Color(255,255,255), lineWidth)

	elif type == "End":
		draw_line(Vector2(0, size/2), Vector2(size/2-lineWidth/2, size/2), Color(255,255,255), lineWidth)
		draw_line(Vector2(size/2-lineWidth/2,size/2), Vector2(size/2+lineWidth/2,size/2), Color(255,0,0), lineWidth)
		
	elif type == "Straight":
		draw_line(Vector2(0,size/2), Vector2(size,size/2), Color(255,255,255), lineWidth)
		
	elif type == "Tee":
		draw_line(Vector2(0,size/2), Vector2(size,size/2), Color(255,255,255), lineWidth)
		draw_line(Vector2(size/2, size/2), Vector2(size/2,0), Color(255,255,255), lineWidth)
	
	elif type == "FourWay":
		draw_line(Vector2(0,size/2), Vector2(size,size/2), Color(255,255,255), lineWidth)
		draw_line(Vector2(size/2,0), Vector2(size/2, size), Color(255,255,255), lineWidth)