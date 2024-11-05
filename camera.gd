extends Camera3D

@onready var player: Player = $"../Player"
@export var player_offset: Vector3

func _ready() -> void:
	global_position = player.global_position + player_offset


func _process(delta: float) -> void:
	global_position = player.global_position + player_offset
