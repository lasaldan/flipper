extends Control

var Game = load("res://scripts/Game.gd")
var Piece = load("res://pieces/Piece.tscn")

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

func _on_Levels_pressed():
	get_parent().change_state("LevelsMenu")

func _on_FreePlay_pressed():
	get_parent().change_state("FreePlayMenu")

func _ready():
	var pieces_container = .get_node("Logo")
	var boardSize = get_tree().root.get_node("Main/Global").boardSize
	var pieceSize = get_tree().root.get_node("Main/Global").pieceSize
	Game.drawLogo(boardSize, pieceSize, pieces_container, Piece)
	
