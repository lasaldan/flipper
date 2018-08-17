extends Control

var current_scene = "MainMenu"
var next_scene = ""

func _ready():
	get_node("Animations").play("fadeIn"+current_scene)

func change_state(new_scene):
	next_scene = new_scene
	fade_out_current_scene()
	get_node("AnimationDelay").start()

func fade_out_current_scene():
	get_node("Animations").play_backwards("fadeIn"+current_scene)

func _on_AnimationDelay_timeout():
	get_node("Animations").play("fadeIn"+next_scene)
	current_scene = next_scene
	
