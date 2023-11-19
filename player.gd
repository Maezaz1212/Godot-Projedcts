extends CharacterBody3D

@export var speed = 14
@export var fall_accel = 75
@export var jump_height = 20
var target_vel = Vector3.ZERO


func _physics_process(delta):
	var dir = Vector3.ZERO
	var rotate_dir = Vector2.ZERO;
	
	if(Input.is_action_pressed("camera_right")):
		rotate_dir.x += 1
	if(Input.is_action_pressed("camera_left")):
		rotate_dir.x -= 1
			
	if(Input.is_action_pressed("camera_up")):
		rotate_dir.y += 1
	if(Input.is_action_pressed("camera_down")):
		rotate_dir.y -= 1
	
	
	if rotate_dir.y < 0:
		$Pivot.rotate_x(0.1)
	if rotate_dir.y > 0:
		$Pivot.rotate_x(-0.1)
		
	if rotate_dir.x < 0:
		rotate_y(0.1)
	if rotate_dir.x > 0:
		rotate_y(-0.1)
		
	if(Input.is_action_pressed("move_right")):
		dir.x -= 1
	if(Input.is_action_pressed("move_left")):
		dir.x += 1
			
	if(Input.is_action_pressed("move_forward")):
		dir.z += 1
	if(Input.is_action_pressed("move_back")):
		dir.z -= 1
	
	target_vel = ((global_transform.basis.z * dir.z) + (global_transform.basis.x * dir.x)) * speed;
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		target_vel.y = jump_height
		
	if not is_on_floor():
		target_vel.y = target_vel.y - (fall_accel*delta)
	
	velocity = target_vel
	move_and_slide()
