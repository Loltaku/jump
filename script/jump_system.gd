class_name JumpSystem
extends Node

# 节点引用
@onready var coyote_timer: Timer = $"../CoyoteTimer"

# 配置参数
@export var jump_velocity := -350.0
@export var coyote_time := 0.15
@export var jump_buffer_time := 0.1

# 状态变量
var can_jump := true
var jump_buffer_timer := 0.0

func _ready():
	coyote_timer.wait_time = coyote_time

func process_jump():
	_handle_jump_input()
	_apply_jump_logic()

func update_floor_state(current_floor: bool, prev_floor: bool):
	if prev_floor and !current_floor:
		coyote_timer.start()
	elif current_floor:
		coyote_timer.stop()
		can_jump = true

func _handle_jump_input():
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer = max(jump_buffer_timer - get_physics_process_delta_time(), 0.0)

func _apply_jump_logic():
	var should_jump = (
		jump_buffer_timer > 0 
		and (can_jump or not coyote_timer.is_stopped())
	)
	
	if should_jump:
		_perform_jump()

func _perform_jump():
	get_parent().velocity.y = jump_velocity
	can_jump = false
	jump_buffer_timer = 0.0
	coyote_timer.stop()

func _on_coyote_timer_timeout():
	can_jump = false
