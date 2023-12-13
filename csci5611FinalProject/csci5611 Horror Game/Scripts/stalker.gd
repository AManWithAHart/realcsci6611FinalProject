extends CharacterBody3D

#Basic Navigation implementation by DevLogLogan https://www.youtube.com/watch?v=-juhGgA076E


#The stalker enemy follows the player closely, avoiding direction line of sight.
#The stalker is non-hostile, and will drain the player's flashlight when close
#stalkers always know where the player is

const SPEED = 8.0
enum State {STALKING, FLEEING}

var current_state = State.STALKING
var in_los = false


@onready var nav_agent = $NavigationAgent3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func get_visible_by_player():
	if in_los:
		var cam_pos = get_viewport().get_camera_3d().get_global_position()
		print(cam_pos)
		var visibility_ray = $Visibility_Ray
		visibility_ray.target_position = cam_pos - position
		print(visibility_ray.is_colliding())
		if ((cam_pos - position).length() > 18) or visibility_ray.is_colliding():
			current_state = State.STALKING
		else:
			current_state = State.FLEEING
	else:
		current_state = State.STALKING

func update_target_location(target):
	nav_agent.target_position = target

func _physics_process(delta):
	var cur_location = global_transform.origin
	
	get_visible_by_player()
	
	match current_state:
		State.STALKING:
			var next_location = nav_agent.get_next_path_position()
			var new_vel = next_location - cur_location
			new_vel = new_vel.normalized() * SPEED
			
			velocity = velocity.move_toward(new_vel, 0.25)
		State.FLEEING:
			velocity = Vector3.ZERO
			
	
	if not is_on_floor():
		velocity.y -= gravity
	move_and_slide()


func _on_detection_area_area_entered(area):
	current_state = State.FLEEING
	print("spotted")


func _on_detection_area_area_exited(area):
	current_state = State.STALKING
	print("lost")


func _on_visible_on_screen_notifier_3d_screen_entered():
	in_los = true


func _on_visible_on_screen_notifier_3d_screen_exited():
	in_los = false
