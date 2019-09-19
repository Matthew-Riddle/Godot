extends KinematicBody2D

#Jump 
export var fallMultiplier = 2 
export var lowJumpMultiplier = 10 
export var jumpVelocity = 400 #Jump height

var dashCount = 1
var dashFramesMax = 6
var velocity = Vector2()
export var gravity = 8

var didDashAdd = false

var dashFrames = 0

var dashAcceleration = 800

func _physics_process(delta):
	didDashAdd = false
	velocity.y += gravity
	# Gravity stuff
	if velocity.y > 0: #Player is falling
		velocity += Vector2.UP * (-9.81) * (fallMultiplier) #Falling action is faster than jumping action | Like in mario
		
	elif velocity.y < 0 && Input.is_action_just_released("ui_accept"): #Player is jumping 
		velocity += Vector2.UP * (-9.81) * (lowJumpMultiplier) #Jump Height depends on how long you will hold key
	
	# Walking logic
	if is_on_floor():
		if Input.is_action_pressed("ui_left"):
			velocity.x = -300
		elif Input.is_action_pressed("ui_right"):
			velocity.x = 300
		else:
			velocity.x = 0
	
	
	
	if dashFrames != 0:
		dashFrames -= 1
	# In the air
	if !is_on_floor():
		if dashFrames == 0:
			if Input.is_action_pressed("ui_left"):
				velocity.x = -300
			elif Input.is_action_pressed("ui_right"):
				velocity.x = 300
		else:
			if Input.is_action_pressed("ui_left"):
				velocity.x -= dashAcceleration
				didDashAdd = true
			elif Input.is_action_pressed("ui_right"):
				velocity.x += dashAcceleration
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
			if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
				dashFrames = dashFramesMax
			dashCount -= 1
	
	
	velocity = move_and_slide(velocity, Vector2(0,-1), false, 25)
	
	print(delta, delta, delta, delta)

	#print('velocityX: ', velocity.x, ' ', velocity.y, ' ', didDashAdd, ' ', delta)
	
	#velocityX: -1900 297.919983
	#1923.2150988
	#velocityX: -378.279785 -788.415588

