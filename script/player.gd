extends CharacterBody2D

@onready var movement: MovementSystem = $MovementSystem
@onready var jump: JumpSystem = $JumpSystem
@onready var anim: AnimationSystem = $AnimationSystem

func _physics_process(delta):
	# 运动控制
	var direction = Input.get_axis("left", "right")
	velocity.x = movement.calculate_velocity(direction, delta)
	
	# 跳跃控制
	jump.try_jump(Input.is_action_just_pressed("jump"))
	
	# 动画更新
	anim.update(direction, !is_on_floor())
	
	move_and_slide()
