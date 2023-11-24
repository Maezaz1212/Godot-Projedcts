extends CharacterBody3D

@export var speed = 14
@export var fall_accel = 75
@export var jump_height = 30
@export var jumps = 2; 
@export var peer_id = 1;
var target_vel = Vector3.ZERO
var jumps_remaining = 2;
var isLocalPlayer = true;

signal player_moved;
func _init():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	
		
func set_peer_id(new_peer_id):
	peer_id = new_peer_id
	$MultiplayerSynchronizer.set_visibility_for(peer_id,false)
	local_player_check.rpc(peer_id)
	
		
@rpc("call_local", "reliable")
func local_player_check(new_peer_id):
	if(new_peer_id != multiplayer.multiplayer_peer.get_unique_id()):
		$Pivot/Camera3D.queue_free();
		isLocalPlayer = false
		return
	

	
		
func _input(event):
	if(!isLocalPlayer):
		return
		
	if event is InputEventMouseMotion:

		$Pivot.rotate_x(event.relative.y/1000)
		rotate_y(-event.relative.x/1000)
	
func _physics_process(delta):
	if(!isLocalPlayer):
		return
		
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
	
	target_vel = (global_transform.basis.x * dir.x + global_transform.basis.z * dir.z) * speed + (Vector3.UP * target_vel.y); 
	
	if is_on_floor():
		target_vel.y = 0;
		jumps_remaining = jumps;
		
	if Input.is_action_just_pressed("jump") and (is_on_floor() or jumps_remaining):
		target_vel.y = jump_height
		jumps_remaining -= 1;
	
	
	if not is_on_floor():
		target_vel.y = target_vel.y - (fall_accel*delta)
	
	
	velocity = target_vel
	move_and_slide()
	player_moved.emit()
	

