extends Control

func _ready():
	for button in get_node("Buttons").get_children():
    	button.connect("pressed", self, "_level_selected", [button])

func _on_BackButton_pressed():
	get_parent().change_state("MainMenu")

func _level_selected(button):
	var level = get_node("Levels").get_node(button.text)
	var game = get_parent().get_node("Game")
	game.width = level.width
	game.height = level.height
	seed(level.randomSeed)
	game.difficulty = 0
	game.prepare_maze()
	get_parent().change_state("Game")
