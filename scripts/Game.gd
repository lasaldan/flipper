extends Control

var Elbow = load("res://pieces/Elbow.tscn")
var Tee = load("res://pieces/Tee.tscn")
var Straight = load("res://pieces/Straight.tscn")
var FourWay = load("res://pieces/FourWay.tscn")
var End = load("res://pieces/End.tscn")

onready var pieces_container = get_node("PiecesContainer")
onready var algorithms = get_node("Algorithms")

var width = 10
var height = 10

var NORTH = 1
var EAST = 2
var SOUTH = 4
var WEST = 8

var EASY = 0
var MEDIUM = 1
var HARD = 2

var algorithm = "Recursive"
var difficulty = 0

var boardSize
var pieceSize

var solved = false

var grid = []
var secondsElapsed = -1

var highScores = {}
		
func _ready():
	
	boardSize = get_tree().root.get_node("Main/Global").boardSize
	pieceSize = get_tree().root.get_node("Main/Global").pieceSize
	#retrieve_high_scores()

	#get_node("WinMessage").hide()
	#get_node("GUI").position = Vector2(0, boardSize / -2 - 150)
	#secondsElapsed = -1
	pass

func retrieve_high_scores():
	var file = File.new()
	if not file.file_exists("user://flip_high_scores1.sav"):
		highScores = [
			{ type = "Easy", holder = "Daniel", score = -1 },
			{ type = "Medium", holder = "Daniel", score = -1 },
			{ type = "Hard", holder = "Daniel", score = -1 },
		]
		return
	
	# Open existing file
	if file.open("user://flip_high_scores1.sav", File.READ) != 0:
		highScores = [
			{ type = "Easy", holder = "Daniel", score = -1 },
			{ type = "Medium", holder = "Daniel", score = -1 },
			{ type = "Hard", holder = "Daniel", score = -1 },
		]
		return
	
	highScores = JSON.parse(file.get_line()).result
	file.close()
	
func save_high_scores():
	var file = File.new()
	if file.open("user://flip_high_scores1.sav", File.WRITE) != 0:
	    print("Error opening file")
	    return
	
	file.store_line(JSON.print(highScores))
	file.close()

func _on_SecondTicker_timeout():
	if(solved):
		return
	secondsElapsed += 1
	get_node("GUI/SecondOutput").set_text(str(intToTimeString(secondsElapsed)))
	
func intToTimeString(s):
	var secondsElapsed = int(s)
	var seconds = secondsElapsed % 60
	var minutes = secondsElapsed % 3600 / 60
	var elapsed = "%02d : %02d" % [minutes, seconds]
	return elapsed
	
func prepare_maze():
	secondsElapsed = -1
	#get_node("WinMessage").hide()
	#updateBestTime()
	solved = false
	randomize()
	self.grid = algorithms.get_node(algorithm).generate(width, height)

	place_pieces()
	
func updateBestTime():
	if(highScores[difficulty].score == -1):
		get_node("GUI/BestTime").text = "Best Time: --:--"
	else:
		get_node("GUI/BestTime").text = "Best Time: " + intToTimeString(highScores[difficulty].score)
	
func maze_is_valid():
	var correctCount = 0
	var wrongCount = 0
	var pieces = get_node("PiecesContainer").get_children()
	for piece in pieces:
		if( ! piece.valid()):
			wrongCount += 1
		else:
			correctCount += 1

	if(wrongCount == 0):
		solved = true
		#get_node("WinMessage").show()
		
		#if(secondsElapsed < highScores[difficulty].score || highScores[difficulty].score == -1):
		#	highScores[difficulty].score = secondsElapsed
		#	save_high_scores()
		
		

		
	return solved
	
func _draw():
	if(!grid):
		return
		
	var size = boardSize / width
	var color = Color(255,255,255,.4)
	var stroke = 1
	var boardOffset = boardSize/-2
	
	#horizontal grid rows
	var rowIndex = 0
	for row in grid:
		draw_line(Vector2(boardOffset,size * rowIndex + boardOffset), Vector2(boardSize + boardOffset, size*rowIndex + boardOffset), color, stroke)
		rowIndex += 1

	var colIndex = 0
	for col in grid[0]:
		draw_line(Vector2(size * colIndex + boardOffset, boardOffset), Vector2(size * colIndex + boardOffset, boardSize + boardOffset), color, stroke)
		colIndex += 1
	
	draw_line(Vector2(boardOffset,size * rowIndex + boardOffset), Vector2(boardSize + boardOffset, size*rowIndex + boardOffset), color, stroke*8)
	draw_line(Vector2(size * colIndex + boardOffset, boardOffset), Vector2(size * colIndex + boardOffset, boardSize + boardOffset), color, stroke*8)
	draw_line(Vector2(boardOffset, boardOffset), Vector2(-boardOffset, boardOffset), color, stroke*8)
	draw_line(Vector2(boardOffset, boardOffset), Vector2(boardOffset, boardSize + boardOffset), color, stroke*8)
	
func place_pieces():
	for child in pieces_container.get_children():
		child.queue_free()
	var size = boardSize / width
	var boardOffset = boardSize/-2
	var rowIndex = 0

	for row in grid:
		var colIndex = 0
		
		for val in row:

			var piece
			
			# Four Way
			if(val & NORTH && val & SOUTH && val & EAST && val & WEST):
				piece = FourWay.instance()
				piece.correctPositions = [0,1,2,3]
			
			# Tees
			elif(val & NORTH && val & EAST && val & WEST):
				piece = Tee.instance()
				piece.correctPositions = [2]
				
			elif(val & NORTH && val & EAST && val & SOUTH):
				piece = Tee.instance()
				piece.correctPositions = [3]
				
			elif(val & SOUTH && val & EAST && val & WEST):
				piece = Tee.instance()
				piece.correctPositions = [0]
				
			elif(val & NORTH && val & SOUTH && val & WEST):
				piece = Tee.instance()
				piece.correctPositions = [1]
				
			# Straights
			elif(val & NORTH && val & SOUTH):
				piece = Straight.instance()
				piece.correctPositions = [1,3]
				
			elif(val & EAST && val & WEST):
				piece = Straight.instance()
				piece.correctPositions = [0,2]
				
			# Elbows
			elif(val & NORTH && val & EAST):
				piece = Elbow.instance()
				piece.correctPositions = [2]
				
			elif(val & NORTH && val & WEST):
				piece = Elbow.instance()
				piece.correctPositions = [1]
				
			elif(val & SOUTH && val & EAST):
				piece = Elbow.instance()
				piece.correctPositions = [3]
				
			elif(val & SOUTH && val & WEST):
				piece = Elbow.instance()
				piece.correctPositions = [0]
			
			# Ends
			elif(val & NORTH):
				piece = End.instance()
				piece.correctPositions = [1]
				
			elif(val & EAST):
				piece = End.instance()
				piece.correctPositions = [2]
				
			elif(val & SOUTH):
				piece = End.instance()
				piece.correctPositions = [3]
				
			elif(val & WEST):
				piece = End.instance()
				piece.correctPositions = [0]
				
			piece.position = Vector2(colIndex * size + size/2 + boardOffset, rowIndex * size + size/2 + boardOffset)
			piece.scale = Vector2(size/float(pieceSize), size/float(pieceSize))

			var rot = randi()%4

			piece.currentPosition = 0
			piece.currentPosition = rot
			piece.get_node("Area2D/Sprite").rotation = PI * (rot / 2.0)
			pieces_container.add_child(piece)
			
			colIndex += 1
			
		rowIndex += 1
