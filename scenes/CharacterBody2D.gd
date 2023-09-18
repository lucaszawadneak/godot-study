extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var isJumping = false
var knockback = Vector2.ZERO

@export var PLAYER_LIFE = 5

@onready var animatedSprite := $anim as AnimatedSprite2D
@onready var remoteTransform := $RemoteTransform2D as RemoteTransform2D
@onready var collisionDetectorRight := $RayRight as RayCast2D
@onready var collisionDetectorLeft := $RayLeft as RayCast2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		# if falling from scene
		if position.y > 100:
			queue_free()

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		isJumping = true
	elif is_on_floor():
		isJumping = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animatedSprite.scale.x = direction
		
		if not isJumping:
			animatedSprite.play("run")
	elif isJumping:
		animatedSprite.play("jump")
	else:
		animatedSprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if knockback != Vector2.ZERO:
		velocity = knockback

	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.is_in_group("enemies"):
		if PLAYER_LIFE < 0:
			queue_free()
		else:
			print(PLAYER_LIFE)
			print(collisionDetectorLeft.is_colliding())
			print(collisionDetectorRight.is_colliding())
			if collisionDetectorRight.is_colliding():
				take_damage(Vector2(-200,200))
			elif collisionDetectorLeft.is_colliding():
				take_damage(Vector2(-200,200))

func take_damage(knockback_vector = Vector2.ZERO,duration = 0.25):
	PLAYER_LIFE -=1
	
	if knockback_vector != Vector2.ZERO:
		knockback = knockback_vector
		
		var knockback_tween = get_tree().create_tween()
		knockback_tween.tween_property(self,"knockback_vector",Vector2.ZERO,duration)
		
		animatedSprite.modulate = Color(1,0,0,1)
		knockback_tween.parallel().tween_property(animatedSprite,"modulate",Color(1,1,1,1),duration)

	
func follow_camera(camera):
	var camera_path = camera.get_path()
	remoteTransform.remote_path = camera_path
