extends PanelContainer


const max_timer = 3
var cur_timer = 0
var displaytext = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		queue_free()
	if(displaytext):
		if cur_timer >= max_timer:
			queue_free()
		else:
			cur_timer += delta
