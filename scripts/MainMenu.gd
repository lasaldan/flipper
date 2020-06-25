extends Control

var Game = load("res://scripts/Game.gd")
var Piece = load("res://pieces/Piece.tscn")
var step = 0
var ticks = 0

var constants = {
	FOUR_WAY = 1,
	TEE = 2,
	STRAIGHT = 4,
	ELBOW = 8,
	END = 16,
	BLOCK = 32,
	POSITION_1 = 64,
	POSITION_2 = 128,
	POSITION_3 = 256,
	POSITION_4 = 512
}

var piecesNeedingOne = [1,2,3,4,5,6,8,9,10,11,12,13,14,16,17,18,19,20,21,22,23]
var piecesNeedingTwo = [1,2,3,4,5,6,10,14,18,19,20,22]
var piecesNeedingThree = [1,2,3,4,5,6,10]
var _timer = null

func _on_Levels_pressed():
	get_parent().change_state("LevelsMenu")

func _on_FreePlay_pressed():
	get_parent().change_state("FreePlayMenu")

func _ready():
	var pieces_container = get_node("Logo")
	var boardSize = get_tree().root.get_node("Main/Global").boardSize
	var pieceSize = get_tree().root.get_node("Main/Global").pieceSize
	Game.drawLogo(boardSize, pieceSize, pieces_container, Piece)

	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(0.1)
	_timer.set_one_shot(false)
	_timer.start()


func _on_Timer_timeout():
	if(piecesNeedingOne.size() > 0):
		var pieceIndex = piecesNeedingOne[randi()%piecesNeedingOne.size()]
		get_node("Logo").get_child(pieceIndex).get_node("Animation").play("rotateTo1")
		piecesNeedingOne.erase(pieceIndex)
	elif(piecesNeedingTwo.size() > 0):
		var pieceIndex = piecesNeedingTwo[randi()%piecesNeedingTwo.size()]
		get_node("Logo").get_child(pieceIndex).get_node("Animation").play("rotateTo2")
		piecesNeedingTwo.erase(pieceIndex)	
	elif(piecesNeedingThree.size() > 0):
		var pieceIndex = piecesNeedingThree[randi()%piecesNeedingThree.size()]
		get_node("Logo").get_child(pieceIndex).get_node("Animation").play("rotateTo3")
		piecesNeedingThree.erase(pieceIndex)
	else:
		ticks = ticks + 1
		if(ticks == 2):
			for i in range(0, 24):
				get_node("Logo").get_child(i).lineColor = Color.aqua
				get_node("Logo").get_child(i).update()
			_timer.stop()
	
