extends VisibleOnScreenNotifier3D

func _process(delta):
	if is_on_screen():
		print("los")
	else:
		print("")
	
