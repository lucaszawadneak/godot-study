extends CharacterBody2D


const SPEED = 700.0
const JUMP_VELOCITY = -400.0

var direction = -1;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var wall_detector = $RayCast2D as RayCast2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if wall_detector.is_colliding():
		direction *=-1
		$Sprite2D.scale.x *= -1
		wall_detector.scale.x *= -1

	velocity.x = direction * SPEED * delta 

	move_and_slide()
