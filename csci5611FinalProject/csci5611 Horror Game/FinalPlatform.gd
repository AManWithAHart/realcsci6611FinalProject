extends Area3D


@onready var yPos = $FinalPlatform/MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

signal finish
func _on_body_entered(body):
	emit_signal("finish")
	get_tree().change_scene_to_file("res://win_level.tscn")
	


func _on_player_exit_open():
	position.y += 0.5
