extends Control

var button = load("res://UIComponents/Button.tscn")

onready var buttons = get_node("Buttons/ButtonsWrapper")

func _ready():
	var index = 0
	var columns = 4
	var gutter = 30
	var buttonSize = (880 - ((columns-1) * gutter))/float(columns)
	print(str(buttonSize))
	var row = 0
	var col = 0
	for level in get_node("Levels").levels:
		var b = button.instance()
		b.text = level.name
		var horizontalGutterOffset = col*gutter
		if(col == 0):
			horizontalGutterOffset = 0		
		var verticalGutterOffset = row*gutter
		if(row == 0):
			verticalGutterOffset = 0
		b.set_position(Vector2(col * buttonSize + horizontalGutterOffset, row * buttonSize + verticalGutterOffset ))

		buttons.add_child(b)
		b.connect("pressed", self, "_level_selected", [index])
		col = (col + 1) % columns
		if(col == 0):
			row = row + 1
		index = index + 1
		
	#for button in get_node("Buttons").get_children():
	#	button.connect("pressed", self, "_level_selected", [button])

func _on_BackButton_pressed():
	get_parent().change_state("MainMenu")

func _level_selected(levelIndex):
	var level = get_node("Levels").levels[levelIndex]
	var game = get_parent().get_node("Game")
	
	game.width = level.width
	game.height = level.height
	game.mode = game.MODE_LEVEL
	game.levelIndex = levelIndex
	
	# make sure highScores -> levels array is big enough to hold this level (presaved scores may be from previous level packs)
	for i in range(levelIndex + 1):
		if(len(game.highScores.levels) == i):
			game.highScores.levels.append( {score = -1} )
	
	if(level.type == "seeded"):
		seed(level.randomSeed)
		game.algorithm = level.algorithm
		game.prepare_maze(level.startx, level.starty)
		
	elif(level.type == "prefab"):
		game.load_prefab_maze( level.data, level.startx, level.starty )
		

		
	get_parent().change_state("Game")
