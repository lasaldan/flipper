extends Control

var Piece = load("res://pieces/piece.tscn")

onready var pieces_container = get_node("PiecesContainer")
onready var algorithms = get_node("Algorithms")
onready var gameTimer = get_node("GameTime")
onready var progress = get_node("GUI/Progress")
onready var bestProgress = get_node("GUI/BestProgress")
onready var bestTime = get_node("GUI/BestTime")

export (Color, RGBA) var lineColor
export (Color, RGBA) var endColor
export (Color, RGBA) var connectedColor

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
var progressWidth

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
	progressWidth = get_tree().root.get_node("Main/Global").progressWidth
	progress.color = connectedColor
	bestProgress.color = endColor
	bestProgress.rect_size = Vector2(0, 10)
	retrieve_high_scores()

	#get_node("WinMessage").hide()
	#get_node("GUI").position = Vector2(0, boardSize / -2 - 150)
	secondsElapsed = -1


func _on_BackButton_pressed():
	get_parent().change_state("FreePlayMenu")

func retrieve_high_scores():
	var file = File.new()
	
	highScores = [
		{ score = 22 },
		{ score = 55 },
		{ score = 202 },
	]
	
	if not file.file_exists("user://flip_high_scores.sav"):
		return
	
	# Open existing file
	if file.open("user://flip_high_scores1.sav", File.READ) != 0:
		return
	
	highScores = JSON.parse(file.get_line()).result
	file.close()
	print(highScores)
	
func save_high_scores():
	var file = File.new()
	if file.open("user://flip_high_scores1.sav", File.WRITE) != 0:
	    print("Error opening file")
	    return
	
	file.store_line(JSON.print(highScores))
	file.close()

func _on_GameTime_timeout():
	secondsElapsed += 1
	get_node("GUI/SecondOutput").set_text(str(intToTimeString(secondsElapsed)))
	updateBestProgress()
	
func intToTimeString(s):
	var secondsElapsed = int(s)
	var seconds = secondsElapsed % 60
	var minutes = secondsElapsed % 3600 / 60
	var elapsed = "%02d : %02d" % [minutes, seconds]
	return elapsed
	
func prepare_maze():
	secondsElapsed = -1
	#get_node("WinMessage").hide()
	updateBestTime()
	updateBestProgress()
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
	gameTimer.start()
	
func updateBestTime():

	if(highScores[difficulty].score == -1):
		bestTime.text = "--:--"
	else:
		bestTime.text = intToTimeString(highScores[difficulty].score)
	
func validate():
	for child in pieces_container.get_children():
		child.connected = false
		child.update()
	numberConnected = 0
		
	colorCorrectFrom(startNode.x, startNode.y, 'origin')
	
	var isSolved = true
	for child in pieces_container.get_children():
		if !child.connected && child.type != "Block":
			isSolved = false
			
	solved = isSolved
	
	var ratioComplete = float(numberConnected) / pieceCount
	var percentComplete = ratioComplete * 100.0
	
	if(ratioComplete == 1):
		gameTimer.stop()

	progress.rect_size = Vector2(progressWidth * ratioComplete , 40)


func updateBestProgress():
	bestProgress.rect_size = Vector2(min(progressWidth * (float(secondsElapsed) / highScores[difficulty].score), progressWidth), 10)
	
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
	
	if piece.connected || piece.type == "Block" || (dir != 'origin' && !directions[opposite(dir)]):
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
	print("SDKFLJSDKLFJDSFKL")
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
	var color = Color(1,1,1,1)
	var stroke = 1
	var boardOffsetX = (1080 - boardSize)/2
	var boardOffsetY = 200
	var mainBorderWidth = 8

	#horizontal grid rows
	var rowIndex = 0
	for row in grid:
		draw_line(Vector2(boardOffsetX,size * rowIndex + boardOffsetY), Vector2(boardSize + boardOffsetX, size*rowIndex + boardOffsetY), color, stroke)
		rowIndex += 1

	var colIndex = 0
	for col in grid[0]:
		draw_line(Vector2(size * colIndex + boardOffsetX, boardOffsetY), Vector2(size * colIndex + boardOffsetX, boardSize + boardOffsetY), color, stroke)
		colIndex += 1
	
	#bottom
	draw_line(Vector2(boardOffsetX - mainBorderWidth,size * rowIndex + boardOffsetY + mainBorderWidth/2), Vector2(boardSize + boardOffsetX + mainBorderWidth, size*rowIndex + boardOffsetY + mainBorderWidth/2), color, mainBorderWidth)
	
	#right
	draw_line(Vector2(size * colIndex + boardOffsetX + mainBorderWidth/2, boardOffsetY), Vector2(size * colIndex + boardOffsetX + mainBorderWidth/2, boardSize + boardOffsetY), color, stroke*8)
	
	#top
	draw_line(Vector2(boardOffsetX - mainBorderWidth, boardOffsetY - mainBorderWidth/2), Vector2(boardSize + boardOffsetX + mainBorderWidth, boardOffsetY - mainBorderWidth/2), color, stroke*8)
	
	#left
	draw_line(Vector2(boardOffsetX - mainBorderWidth/2, boardOffsetY), Vector2(boardOffsetX - mainBorderWidth/2, boardSize + boardOffsetY), color, stroke*8)

		
func place_pieces():
	for child in pieces_container.get_children():
		child.queue_free()
	var size = boardSize / width
	var boardOffsetX = (1080 - boardSize)/2
	var boardOffsetY = 200
	var ratio = size/float(pieceSize)

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
			piece.set_position(Vector2(colIndex * size + boardOffsetX - pieceOffset, rowIndex * size + boardOffsetY - pieceOffset))
			

			var rot = randi()%4
			piece.currentPosition = rot
			piece.set_rotation(PI * (rot / 2.0))
			pieces_container.set_position(Vector2(0,0))
			pieces_container.add_child(piece)
			
			pieces[rowIndex][colIndex] = piece
			if(piece.type != "Block"):
				pieceCount += 1
			
			colIndex += 1
			
		rowIndex += 1
