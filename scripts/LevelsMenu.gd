extends Control

var button = load("res://UIComponents/Button.tscn")

onready var buttons = get_node("Buttons")

func _ready():
	var index = 0
	for level in get_node("Levels").levels:
		var b = button.instance()
		b.text = level.name
		b.set_position(Vector2(0, index * 200))
		buttons.add_child(b)
		b.connect("pressed", self, "_level_selected", [index])
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
	
	if(level.type == "seeded"):
		seed(level.randomSeed)
		game.algorithm = level.algorithm
		game.prepare_maze(level.startx, level.starty)
		
	get_parent().change_state("Game")
