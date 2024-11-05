extends CharacterBody3D
class_name Player

const GRID_SIZE: int = 1
const MOVE_SPEED: float = 10

var target_position: Vector3 = Vector3.ZERO

var is_moving: bool = false


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	#print("Current Position: " + str(global_position))
	
	match Globals.player_state:
		Globals.FroggerState.LAND:
			handle_land_movement()
		Globals.FroggerState.VEHICLE:
			handle_vehicle_movement(delta)
	
	if is_moving == false and Globals.player_state == Globals.FroggerState.LAND:
		validate_frogger_position()

# Handles player movement input on land and smooths movement between integer world coords.
func handle_land_movement() -> void:
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
	
	# Smooths player movement between integer world coordinates.
	# Prevents movement validation until tween is finished.
	if direction != Vector3.ZERO:
		var target_position = global_position + direction
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", target_position, 1 / MOVE_SPEED)
		await tween.finished
		is_moving = false

# Handles player movement input on vehicles and smooths movement.
func handle_vehicle_movement(delta: float) -> void:
	var direction: Vector3 = Vector3.ZERO
	
	global_position.x += (Globals.current_vehicle.speed * Globals.current_vehicle.direction * delta)
	
	if Input.is_action_just_pressed("up"):
		direction.z -= GRID_SIZE
	elif Input.is_action_just_pressed("down"):
		direction.z += GRID_SIZE
	elif Input.is_action_just_pressed("left"):
		direction.x -= GRID_SIZE
	elif Input.is_action_just_pressed("right"):
		direction.x += GRID_SIZE
	
	# Smooths player movement between integer world coordinates.
	# Prevents movement validation until tween is finished.
	if direction != Vector3.ZERO:
		var target_position = global_position + direction
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", target_position, 1 / MOVE_SPEED)

# Checks if (x, z) coordinates of player are integers, if so, return, if not move
# player to nearest integer position.
func validate_frogger_position() -> void:
	if is_equal_approx(global_position.x, roundf(global_position.x)) and is_equal_approx(global_position.z, roundf(global_position.z)):
		return
	else:
		#global_position = Vector3(snapped(global_position.x, GRID_SIZE), 0, snapped(global_position.z, GRID_SIZE))
		var target_position = Vector3(snapped(global_position.x, GRID_SIZE), 0, snapped(global_position.z, GRID_SIZE))
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", target_position, 1 / MOVE_SPEED)


func _on_vehicle_entered(body: Node3D) -> void:
	if body is Player:
		Globals.player_state = Globals.FroggerState.VEHICLE


func _on_vehicle_exited(body: Node3D) -> void:
	if body is Player:
		Globals.player_state = Globals.FroggerState.LAND
