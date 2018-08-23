extends Control

func _on_Easy_pressed():
	var game = get_parent().get_node("Game")
	game.width = 4
	game.height = 4
	game.prepare_maze()
	get_parent().change_state("Game")
	
func _on_Medium_pressed():
	var game = get_parent().get_node("Game")
	game.width = 6
	game.height = 6
	game.prepare_maze()
	get_parent().change_state("Game")
	
func _on_Hard_pressed():
	var game = get_parent().get_node("Game")
	game.width = 9
	game.height = 9
	game.prepare_maze()
	get_parent().change_state("Game")

func _on_BackButton_pressed():
	get_parent().change_state("MainMenu")