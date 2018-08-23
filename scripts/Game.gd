extends Control

var Piece = load("res://pieces/piece.tscn")

#var Elbow = load("res://pieces/Elbow.tscn")
#var Tee = load("res://pieces/Tee.tscn")
#var Straight = load("res://pieces/Straight.tscn")
#var FourWay = load("res://pieces/FourWay.tscn")
#var End = load("res://pieces/End.tscn")

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
var pieces = []
var pieceCount = 0
var numberConnected = 0
var secondsElapsed = -1

var startNode

var highScores = {}
		
func _ready():
	
	boardSize = get_tree().root.get_node("Main/Global").boardSize
	pieceSize = get_tree().root.get_node("Main/Global").pieceSize
	#retrieve_high_scores()

	#get_node("WinMessage").hide()
	#get_node("GUI").position = Vector2(0, boardSize / -2 - 150)
	#secondsElapsed = -1
	pass

func _on_BackButton_pressed():
	get_parent().change_state("FreePlayMenu")

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
	startNode = Vector2(randi()%width,randi()%height)
	self.grid = algorithms.get_node(algorithm).generate(width, height)
	
	for x in range(height):
	    pieces.append([])
	    for y in range(width):
	        pieces[x].append(null)
		
	pieceCount = 0
	place_pieces()
	pieces[startNode.y][startNode.x].connected = true
	validate()
	
func updateBestTime():
	if(highScores[difficulty].score == -1):
		get_node("GUI/BestTime").text = "Best Time: --:--"
	else:
		get_node("GUI/BestTime").text = "Best Time: " + intToTimeString(highScores[difficulty].score)
	
func validate():
	for child in pieces_container.get_children():
		child.connected = false
		child.update()
	numberConnected = 0
		
	colorCorrectFrom(startNode.x, startNode.y, 'origin')
	
	var solved = true
	for child in pieces_container.get_children():
		if !child.connected:
			solved = false
			
	print(float(numberConnected) / pieceCount * 100.0)
	
	
func opposite(dir):
	if dir == "north":
		return "south"
	elif dir == "south":
		return "north"
	elif dir == "east":
		return "west"
	elif dir == "west":
		return "east"
		
func colorCorrectFrom(col, row, dir):

	var piece = pieces[row][col]
	var directions = piece.positions[piece.currentPosition]
	
	if piece.connected || (dir != 'origin' && !directions[opposite(dir)]):
		return
		
	piece.connected = true
	piece.update()
	
	numberConnected += 1

	if row > 0 && directions['north']:
		colorCorrectFrom(col, row-1, 'north')
		
	if row < height-1 && directions['south']:
		colorCorrectFrom(col, row+1, 'south')
		
	if col > 0 && directions['west']:
		colorCorrectFrom(col-1, row, 'west')
		
	if col < width - 1 && directions['east']:
		colorCorrectFrom(col+1, row, 'east')
		
	
	
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
	var boardOffset = (1080 - boardSize)/2

	#horizontal grid rows
	var rowIndex = 0
	for row in grid:
		draw_line(Vector2(boardOffset,size * rowIndex + boardOffset), Vector2(boardSize + boardOffset, size*rowIndex + boardOffset), color, stroke)
		rowIndex += 1

	var colIndex = 0
	for col in grid[0]:
		draw_line(Vector2(size * colIndex + boardOffset, boardOffset), Vector2(size * colIndex + boardOffset, boardSize + boardOffset), color, stroke)
		colIndex += 1
	
	#bottom
	draw_line(Vector2(boardOffset,size * rowIndex + boardOffset), Vector2(boardSize + boardOffset, size*rowIndex + boardOffset), color, stroke*8)
	
	#right
	draw_line(Vector2(size * colIndex + boardOffset, boardOffset), Vector2(size * colIndex + boardOffset, boardSize + boardOffset), color, stroke*8)
	
	#top
	draw_line(Vector2(boardOffset, boardOffset), Vector2(boardSize + boardOffset, boardOffset), color, stroke*8)
	
	#left
	draw_line(Vector2(boardOffset, boardOffset), Vector2(boardOffset, boardSize + boardOffset), color, stroke*8)
	
func place_pieces():
	for child in pieces_container.get_children():
		child.queue_free()
	var size = boardSize / width
	var boardOffset = (1080.0 - boardSize)/2.0
	var ratio = size/float(pieceSize)
	#boardOffset = 0


	var rowIndex = 0

	for row in grid:
		var colIndex = 0
		
		for val in row:

			var piece = Piece.instance()
			
			# Four Way
			if(val & NORTH && val & SOUTH && val & EAST && val & WEST):
				piece.type = "FourWay"
			
			# Tees
			elif(val & NORTH && val & EAST && val & WEST):
				piece.type = "Tee"
				
			elif(val & NORTH && val & EAST && val & SOUTH):
				piece.type = "Tee"
				
			elif(val & SOUTH && val & EAST && val & WEST):
				piece.type = "Tee"
				
			elif(val & NORTH && val & SOUTH && val & WEST):
				piece.type = "Tee"
				
			# Straights
			elif(val & NORTH && val & SOUTH):
				piece.type = "Straight"
				
			elif(val & EAST && val & WEST):
				piece.type = "Straight"
				
			# Elbows
			elif(val & NORTH && val & EAST):
				piece.type = "Elbow"
				
			elif(val & NORTH && val & WEST):
				piece.type = "Elbow"
				
			elif(val & SOUTH && val & EAST):
				piece.type = "Elbow"
				
			elif(val & SOUTH && val & WEST):
				piece.type = "Elbow"
			
			# Ends
			elif(val & NORTH):
				piece.type = "End"
				
			elif(val & EAST):
				piece.type = "End"
				
			elif(val & SOUTH):
				piece.type = "End"
				
			elif(val & WEST):
				piece.type = "End"
			
			var scale = Vector2(ratio, ratio)
			piece.set_scale(scale)
			
			var pieceOffset = (pieceSize - size) / 2
			piece.set_position(Vector2(colIndex * size + boardOffset - pieceOffset, rowIndex * size + boardOffset - pieceOffset))
			

			var rot = randi()%4
			piece.currentPosition = rot
			piece.set_rotation(PI * (rot / 2.0))
			pieces_container.set_position(Vector2(0,0))
			pieces_container.add_child(piece)
			
			pieces[rowIndex][colIndex] = piece
			pieceCount += 1
			
			colIndex += 1
			
		rowIndex += 1
