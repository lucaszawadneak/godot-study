extends Node2D

const WAIT_DURATION = 1.0;

@onready var platform = $AnimatableBody2D as AnimatableBody2D
@export var move_speed = 5.0;
# 192 = 12 * 16 = 12 * block height in pixels
@export var distance = 192;
@export var weight = 0.5;
@export var move_horizontal = true


var follow = Vector2.ZERO
# sprite has 32px length
var platform_center = 16
# Called when the node enters the scene tree for the first time.
func _ready():
	move_platform()

func _physics_process(delta):
	platform.position = platform.position.lerp(follow,weight)
	
func move_platform():
	# if move_horizontal => block will go up
	# else => block will go vertically
	var move_direction = Vector2.RIGHT * distance if move_horizontal else Vector2.UP * distance
	var duration = move_direction.length() / float(move_speed * platform_center)
	
	var platform_tween = create_tween().set_loops().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	platform_tween.tween_property(self,"follow", move_direction,duration).set_delay(WAIT_DURATION)
	# more delay for play to jump
	platform_tween.tween_property(self,"follow", Vector2.ZERO,duration).set_delay(duration +  WAIT_DURATION * 1.5)
