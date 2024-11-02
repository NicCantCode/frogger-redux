extends CharacterBody3D
class_name Player

const GRID_SIZE: int = 1
const MOVE_SPEED: float = 10

var target_position: Vector3 = Vector3.ZERO

var can_move: bool = true
var is_in_vehicle: bool = false
var current_vehicle: VehicleSeat = null

# TODO: Rethink how movement is handled so it can more easily integrate with moving grid vehicles

func _ready() -> void:
	target_position = global_position.snapped(Vector3(GRID_SIZE, 0, GRID_SIZE))
	global_position = target_position

func _process(delta: float) -> void:
	if is_in_vehicle:
		global_position = global_position.move_toward(target_position + Vector3(current_vehicle.global_position.x,0,0), (MOVE_SPEED + 2) * delta)
	else:
		global_position = global_position.move_toward(target_position, MOVE_SPEED * delta)
	
	if can_move and global_position.distance_to(target_position) < 0.01:
		handle_movement()

func handle_movement() -> void:
	var direction: Vector3 = Vector3.ZERO
	
	if Input.is_action_just_pressed("up"):
		direction.z -= GRID_SIZE
	elif Input.is_action_just_pressed("down"):
		direction.z += GRID_SIZE
	elif Input.is_action_just_pressed("left"):
		direction.x -= GRID_SIZE
	elif Input.is_action_just_pressed("right"):
		direction.x += GRID_SIZE
	
	if direction != Vector3.ZERO:
		target_position = global_position + direction
		can_move = false


func _physics_process(delta: float) -> void:
	if global_position.distance_to(target_position) < 0.01:
		can_move = true


func _on_player_seated(seat: VehicleSeat) -> void:
	is_in_vehicle = true
	current_vehicle = seat
	print("In Vehicle" + str(seat.name))


func _on_player_unseated(seat: VehicleSeat) -> void:
	is_in_vehicle = false
	current_vehicle = null
	print("Out of Vehicle!")
