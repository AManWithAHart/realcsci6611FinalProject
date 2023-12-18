extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_quit_pressed():
	get_tree().quit()


func _on_retry_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
