extends Node3D
class_name VehicleSeat

const PLAYER_IDENTIFIER: String = "Player"

signal player_seated(seat: VehicleSeat)
signal player_unseated(seat: VehicleSeat)

func _on_player_entered(body: Node3D) -> void:
	if body.name == PLAYER_IDENTIFIER:
		player_seated.emit(self)


func _on_player_exited(body: Node3D) -> void:
	if body.name == PLAYER_IDENTIFIER:
		player_unseated.emit(self)
