extends Node3D
class_name Vehicle

@export var speed: float = 2
@export var is_bouncing: bool = true

@onready var starting_point_marker: Marker3D = $"Starting Point"
@onready var ending_point_marker: Marker3D = $"Ending Point"

@onready var detection_area: Area3D = $"Detection Area"

var starting_point: Vector3
var ending_point: Vector3

# 1 = Right | -1 = Left
var direction: int = 1

func _ready() -> void:
	# Set starting and ending points to the position of Marker3D children
	starting_point = starting_point_marker.global_position
	ending_point = ending_point_marker.global_position
	
	# Set starting position to starting point position
	global_position = starting_point


func _process(delta: float) -> void:
	# Move vehicle in defined direction
	var new_position = global_position + Vector3(speed * direction * delta, 0, 0)
	
	# Check if vehicle has reached destination, if is_bouncing is true, switch directions
	# if is_bouncing is false, stop log movement.
	if direction == 1 and new_position.x >= ending_point.x:
		if is_bouncing == false:
			direction = 0
		else:
			direction = -1
	elif direction == -1 and new_position.x <= starting_point.x:
		direction = 1
	
	# Update vehicle position based on above data
	global_position = new_position


# Signals that handle global reference to current vehicle Frogger is riding
func _on_vehicle_entered(body: Node3D) -> void:
	if body is Player:
		Globals.current_vehicle = self

func _on_vehicle_exited(body: Node3D) -> void:
	if body is Player:
		Globals.current_vehicle = null
