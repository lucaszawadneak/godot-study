
extends Area2D


func _on_body_entered(body):
	if body.name == "player":
		body.velocity.y = body.JUMP_VELOCITY / 2
		owner.anim.play("hurt")
		owner.sprite.modulate = Color(1,0,0,1)
		
