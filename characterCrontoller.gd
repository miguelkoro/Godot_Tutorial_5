extends CharacterBody2D
@export_category ("Movement Parameters")
@export var jump_peak_time: float = .5
@export var jump_fall_time: float = .5
@export var jump_height: float = 200.0 #px
@export var jump_distance: float = 400.0 #px
@export var coyote_time: float = .1
@export var jump_buffer_time: float = 0.2

@onready var coyote_timer: Timer = $Coyote_Timer


# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var jump_gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var speed: float = 5.0
var jump_velocity: float = 5.0
var jump_available: bool = true
var fall_gravity: float = 5.0
var jump_buffer: bool = false

func _ready() -> void:
	calculate_movement_parameters()
	
func calculate_movement_parameters()->void:
	jump_gravity = (2*jump_height)/(jump_peak_time*jump_peak_time)
	fall_gravity = (2*jump_height)/(jump_fall_time*jump_fall_time)
	jump_velocity = jump_gravity * jump_peak_time
	speed = jump_distance/(jump_peak_time + jump_fall_time)
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += jump_gravity * delta
		else:
			velocity.y += fall_gravity * delta
		
		if jump_available: #When we leave the ground without jumping...
			if coyote_timer.is_stopped():
				coyote_timer.start(coyote_time)
	else:	
		jump_available = true
		coyote_timer.stop() #We reached the ground without finishing the time.
		if jump_buffer: #This should be used in walljumps.
			jump_action()
			jump_buffer = false
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept"):
		if jump_available:
			jump_action()
		else:
			jump_buffer = true
			get_tree().create_timer(jump_buffer_time).timeout.connect(on_jump_buffer_timeout)
			#There is a small bug, because if we press jump too early, next jump buttons
			#could be cancelled by the old ones. This timer should be stopped and reset on the next
			#jump button is pressed. But is done in this way to show how to create a timer in code.
		
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := Vector2(input_dir.x, input_dir.y).normalized()
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()
	
func jump_action()->void:
	velocity.y = -jump_velocity
	jump_available = false
	
func on_jump_buffer_timeout()->void:
	jump_buffer = false #We remove the jump buffer
	
func _on_coyote_timer_timeout() -> void:
	jump_available = false
