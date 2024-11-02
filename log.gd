@tool
extends StaticBody3D

@export var speed: float = 2.0
@export var start_position: Vector3 = Vector3(-3, -1, -5)
@export var end_position: Vector3 = Vector3(43, -1, -5)

var seat_scene: PackedScene = load("res://vehicle_seat.tscn")
@export_range(0, 10, 1) var number_of_seats: int = 0:
	set (new_number_of_seats):
		number_of_seats = new_number_of_seats
		resize_seats()
@export var seats: Array[VehicleSeat]

var direction: int = 1 # 1 = Forward / -1 = Backward

func _ready() -> void:
	if not Engine.is_editor_hint():
		global_position = start_position
		
		for instance in seats:
			instance.player_seated.connect(get_parent().get_node("Player")._on_player_seated)
			instance.player_unseated.connect(get_parent().get_node("Player")._on_player_unseated)


func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		var new_position = global_position + Vector3(speed * direction * delta, 0, 0)
		
		if direction == 1 and new_position.x >= end_position.x:
			direction = -1
		elif direction == -1 and new_position.x <= start_position.x:
			direction = 1
		
		global_position = new_position

func resize_seats() -> void:
	if Engine.is_editor_hint():
		seats.clear()
		for child in get_children():
			if child is VehicleSeat:
				child.free()
		var counter: int = 0
		for seat in number_of_seats:
			var instance: VehicleSeat = seat_scene.instantiate()
			instance.name = "Seat " + str(counter + 1)
			instance.position.x = counter
			add_child(instance)
			instance.owner = self.get_parent()
			seats.append(instance)
			counter += 1
		notify_property_list_changed()
