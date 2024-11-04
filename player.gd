extends CharacterBody3D
class_name Player

const GRID_SIZE: int = 1
const MOVE_SPEED: float = 10

var target_position: Vector3 = Vector3.ZERO

var is_moving: bool = false


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	print("Current Position: " + str(global_position))
	handle_movement()
	
	if is_moving == false:
		validate_frogger_position()

func handle_movement() -> void:
	var direction: Vector3 = Vector3.ZERO
	
	if Input.is_action_just_pressed("up"):
		is_moving = true
		direction.z -= GRID_SIZE
	elif Input.is_action_just_pressed("down"):
		is_moving = true
		direction.z += GRID_SIZE
	elif Input.is_action_just_pressed("left"):
		is_moving = true
		direction.x -= GRID_SIZE
	elif Input.is_action_just_pressed("right"):
		is_moving = true
		direction.x += GRID_SIZE
	
	if direction != Vector3.ZERO:
		var target_position = global_position + direction
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", target_position, 1 / MOVE_SPEED)
		await tween.finished
		is_moving = false

func validate_frogger_position() -> void:
	# Checks if x,z coordinates of player are integers, if so, return, if not move player to nearest integer position
	if is_equal_approx(global_position.x, roundf(global_position.x)) and is_equal_approx(global_position.z, roundf(global_position.z)):
		return
	else:
		global_position = Vector3(snapped(global_position.x, GRID_SIZE), 0, snapped(global_position.z, GRID_SIZE))
