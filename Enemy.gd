extends KinematicBody2D

var velocity = Vector2()
export var gravity = 700


func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0,-1), false, 25)