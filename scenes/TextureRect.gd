extends TextureRect

var size = 0

func _ready():
	size = get_tree().root.get_node("Main/Global").pieceSize

func _draw():
	draw_line(Vector2(0,-15), Vector2(0,size/2), Color(255,255,255), 30)
	draw_line(Vector2(-15,0), Vector2(-size/2,0), Color(255,255,255), 30)