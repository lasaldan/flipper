extends Control

func _on_Easy_pressed():
	randomize()
	var game = get_parent().get_node("Game")
	game.width = 3
	game.height = 4
	game.difficulty = 0
	game.mode = game.MODE_FREEPLAY
	game.prepare_maze()
	get_parent().change_state("Game")
	
func _on_Medium_pressed():
	randomize()
	var game = get_parent().get_node("Game")
	game.width = 6
	game.height = 6
	game.difficulty = 1
	game.mode = game.MODE_FREEPLAY
	game.algorithm = "Kruskals"
	game.prepare_maze()
	get_parent().change_state("Game")
	
func _on_Hard_pressed():
	randomize()
	var game = get_parent().get_node("Game")
	game.width = 8
	game.height = 12
	game.difficulty = 2
	game.mode = game.MODE_FREEPLAY
	game.algorithm = "Kruskals"
	game.prepare_maze()
	get_parent().change_state("Game")

func _on_BackButton_pressed():
	get_parent().change_state("MainMenu")
