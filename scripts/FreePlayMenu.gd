extends Control

func _on_Easy_pressed():
	get_parent().get_node("Game").prepare_maze()
	get_parent().change_state("Game")
	
func _on_Medium_pressed():
	print("Medium")
	
func _on_Hard_pressed():
	print("Hard")

func _on_BackButton_pressed():
	get_parent().change_state("MainMenu")
