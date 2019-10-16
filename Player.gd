extends KinematicBody2D

#Jump
export var fallMultiplier = 2
export var lowJumpMultiplier = 20
export var jumpVelocity = 400 #Jump height

var dashCount = 1
var dashFramesMax = 6
var velocity = Vector2()
export var gravity = 700

var didDashAdd = false

var dashFrames = 0

var dashAcceleration = 800 * 60
var cloney = preload("res://Clone.tscn")
var spriteH
var direction = Vector2(1, 1)
func _physics_process(delta):
	didDashAdd = false
	velocity.y += gravity * delta
	# Gravity stuff
	if velocity.y > 0: #Player is falling
		velocity += Vector2.UP * (-9.81) * (fallMultiplier) #Falling action is faster than jumping action | Like in mario

	elif velocity.y < 0 && Input.is_action_just_released("ui_accept"): #Player is jumping
		velocity += Vector2.UP * (-9.81) * (lowJumpMultiplier) #Jump Height depends on how long you will hold key

	# Walking logic
	if is_on_floor():
		if Input.is_action_pressed("ui_left"):
			velocity.x = -300
			$Sprite.flip_h = true
			
			if direction.x == 1:
				direction.x = -1
				$CollisionShape2D/Position2D.position.x = -$CollisionShape2D/Position2D.position.x
				
			spriteH = -1
			$Sprite.play("Run", false) # Run anim
		elif Input.is_action_pressed("ui_right"):
			$Sprite.flip_h = false
			
			if direction.x == -1:
				direction.x = 1
				$CollisionShape2D/Position2D.position.x = -$CollisionShape2D/Position2D.position.x
				
			spriteH = 1
			$Sprite.play("Run", false) # Run anim
			velocity.x = 300
		else:
			velocity.x = 0
			$Sprite.play("Idle");
		
#	print($CollisionShape2D/Position2D.position)
#	print(direction.x)
	# In the air
	if !is_on_floor():
		$Sprite.play("Idle") #Jump anim
		if dashFrames == 0:
			if Input.is_action_pressed("ui_left"):
				$Sprite.flip_h = true
				
				if direction.x == 1:
					direction.x = -1
					$CollisionShape2D/Position2D.position.x = -$CollisionShape2D/Position2D.position.x
				
				spriteH = -1
				velocity.x = -300
			elif Input.is_action_pressed("ui_right"):
				$Sprite.flip_h = false
				
				if direction.x == -1:
					direction.x = 1
					$CollisionShape2D/Position2D.position.x = -$CollisionShape2D/Position2D.position.x
				
				spriteH = 1
				velocity.x = 300
		else:
			if Input.is_action_pressed("ui_left"):
				velocity.x -= dashAcceleration * delta
				didDashAdd = true
			elif Input.is_action_pressed("ui_right"):
				velocity.x += dashAcceleration * delta
				didDashAdd = true
		if !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right"):
			velocity.x = 0

	# Jump logic
	if is_on_floor():
		dashCount = 3

	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity = Vector2.UP * jumpVelocity
	else:
		if Input.is_action_just_pressed("ui_accept") and dashCount > 0:
			if Input.is_action_pressed("ui_left"):
				dashFrames = dashFramesMax
			if Input.is_action_pressed("ui_right"):
				dashFrames = dashFramesMax
			dashCount -= 1

#	if dashFrames > 0:
#		if Input.is_action_pressed("ui_left"):
#			# Do dash animation
#		if Input.is_action_pressed("ui_right"):
#			# Do dash animation


#	if dashFrames == 0:
#		# Maybe useful for dash animation
	if dashFrames != 0:
		dashFrames -= 1
	
	if Input.is_action_pressed("ui_clone"):
		var number = randf()*3
		print(number)
		clone(velocity, $CollisionShape2D/Position2D.global_position, spriteH, number)
	velocity = move_and_slide(velocity, Vector2(0,-1), false, 25)
	
	update()

func clone(vel, pos, horizontal, size):
	var boi = cloney.instance()
	boi.init(vel, pos, spriteH, size)
	get_parent().add_child(boi)
	
func _draw():
	draw_circle($CollisionShape2D/Position2D.position, 3, Color(122,122,122))