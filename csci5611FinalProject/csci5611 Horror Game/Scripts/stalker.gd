extends CharacterBody3D

#Basic Navigation implementation by DevLogLogan https://www.youtube.com/watch?v=-juhGgA076E


#The stalker enemy follows the player closely, avoiding direction line of sight.
#The stalker is non-hostile, and will drain the player's flashlight when close
#stalkers always know where the player is

const SPEED = 8.0
enum State {STALKING, FLEEING, APPRAISE}

var current_state = State.STALKING
var in_los = false
var fleeing = false


@onready var nav_agent = $NavigationAgent3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func get_visible_by_player():
	if in_los:
		var cam_pos = get_viewport().get_camera_3d().get_global_position()
		#print(cam_pos)
		var visibility_ray = $Visibility_Ray
		visibility_ray.target_position = cam_pos - position
		#print(visibility_ray.is_colliding())
		if ((cam_pos - position).length() > 18) or visibility_ray.is_colliding():
			current_state = State.STALKING
		else:
			current_state = State.APPRAISE
	else:
		current_state = State.STALKING

func update_target_location(target):
	if current_state == State.STALKING:
		nav_agent.target_position = target

func _physics_process(delta):
	var cur_location = global_transform.origin
	
	match current_state:
		State.STALKING:
			get_visible_by_player()
			var next_location = nav_agent.get_next_path_position()
			var new_vel = next_location - cur_location
			new_vel = new_vel.normalized() * SPEED
			
			velocity = velocity.move_toward(new_vel, 0.25)
		State.FLEEING:
			var next_location = nav_agent.get_next_path_position()
			var new_vel = next_location - cur_location
			new_vel = new_vel.normalized() * SPEED * 2
			
			velocity = velocity.move_toward(new_vel, 0.25)
			
			if nav_agent.distance_to_target() < 1:
				current_state = State.STALKING
				print("Reached!")
			
		State.APPRAISE:
			velocity = Vector3.ZERO
			var next_location
			var player_location = nav_agent.target_position
			
			for i in range(20):
				var space_state = get_world_3d().direct_space_state
				#get a random position to move to
				var test_position = position + Vector3(randi_range(10, 15), position.y, randi_range(5, 15)).rotated(Vector3(0, 1, 0), randf_range(0, 6.28))
				
				#fit the position inside the nav mesh
				nav_agent.target_position = test_position
				test_position = nav_agent.get_final_position()
				
				#make a raycast query
				var query = PhysicsRayQueryParameters3D.create(player_location, test_position, 1)
				query.collide_with_areas = true
	
				var result = space_state.intersect_ray(query)
				
				#check if the random position is in LOS
				if result:
					if not next_location:
						next_location = test_position
					else:
						if next_location.distance_to(player_location) < test_position.distance_to(player_location):
							next_location = test_position
			
			nav_agent.target_position = next_location

			print(nav_agent.target_position)
			current_state = State.FLEEING
			
	
	if not is_on_floor():
		velocity.y -= gravity
	move_and_slide()


func _on_visible_on_screen_notifier_3d_screen_entered():
	in_los = true


func _on_visible_on_screen_notifier_3d_screen_exited():
	in_los = false
