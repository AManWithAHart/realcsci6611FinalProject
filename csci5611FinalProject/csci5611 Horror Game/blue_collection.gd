extends Area3D

signal blue_collected


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(0.01)

#@onready var player = $Player

func _on_body_entered(body):
	emit_signal("blue_collected")
	queue_free()
