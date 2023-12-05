extends CharacterBody3D

#Basic Navigation implementation by DevLogLogan https://www.youtube.com/watch?v=-juhGgA076E

const SPEED = 6.0

@onready var nav_agent = $NavigationAgent3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func update_target_location(target):
	nav_agent.target_position = target

func _physics_process(delta):
	var cur_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_vel = next_location - cur_location
	new_vel = new_vel.normalized() * SPEED
	
	velocity = velocity.move_toward(new_vel, 0.25)
	
	if not is_on_floor():
		velocity.y -= gravity
	move_and_slide()
