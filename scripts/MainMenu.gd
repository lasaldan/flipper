extends Control

func _on_Levels_pressed():
	get_parent().change_state("LevelsMenu")

func _on_FreePlay_pressed():
	get_parent().change_state("FreePlayMenu")
