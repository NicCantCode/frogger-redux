extends Camera3D

@onready var player: Player = $"../Player"

func _ready() -> void:
	global_position = Vector3(player.global_position.x + 0.5, global_position.y, player.global_position.z + 3)


func _process(delta: float) -> void:
	global_position = Vector3(player.global_position.x + 0.5, global_position.y, player.global_position.z + 3)
