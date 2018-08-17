extends Node2D
var correctPositions
var currentPosition
var rotatable

onready var anim = get_node("Area2D/anim")

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		self.on_click()
	self.update()
		
func on_click():
	if( ! get_parent().get_parent().maze_is_valid() ):
		currentPosition = (currentPosition + 1) % 4
		anim.play("rotateTo"+str(currentPosition))
		get_parent().get_parent().maze_is_valid()

func valid():
	if(correctPositions.find(currentPosition) >= 0):
		return true
	return false