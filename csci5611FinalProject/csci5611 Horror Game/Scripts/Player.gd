extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 2.5
const SENSITIVITY = 0.003
const MAX_STAMINA = 1.

var stamina = MAX_STAMINA

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head = $Head
@onready var camera = $Head/Camera3D



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#update velocities
	if direction:
		
		#handle sprinting
		var is_sprinting = Input.is_action_pressed("sprint")
		if (stamina > 0 and is_sprinting):
			stamina -= delta
		elif (not is_sprinting):
			if (stamina < MAX_STAMINA): stamina += delta
			if (stamina > MAX_STAMINA): stamina = MAX_STAMINA
			is_sprinting = false
		else:
			is_sprinting = false
		
		velocity.x = direction.x * (SPEED * (float(is_sprinting) + 1))
		velocity.z = direction.z * (SPEED * (float(is_sprinting) + 1))
	else:
		velocity.x = 0.0 #move_toward(velocity.x, 0, SPEED)
		velocity.z = 0.0 #move_toward(velocity.z, 0, SPEED)

	move_and_slide()
