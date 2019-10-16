extends KinematicBody2D

#Jump
export var fallMultiplier = 2
export var lowJumpMultiplier = 20
export var jumpVelocity = 400 #Jump height

var velocity = Vector2()
var pos = Vector2()
export var gravity = 700
var timer

func init(vel, pos, spriteH, size):
	velocity = vel
	position = pos
	timer = 100
	scale.x = size
	scale.y = size
	if spriteH == -1:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	print('initialized boi')

func _physics_process(delta):
	velocity.y += gravity * delta
	timer -= 1
	# Gravity stuff
	if velocity.y > 0: #Player is falling
		velocity += Vector2.UP * (-9.81) * (fallMultiplier) #Falling action is faster than jumping action | Like in mario
		
	if timer <= 0:
		queue_free()
		print('Freed')
	
	$Sprite.play('Idle')



	velocity = move_and_slide(velocity, Vector2(0,-1), false, 25)