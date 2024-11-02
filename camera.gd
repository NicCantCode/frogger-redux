extends Camera3D

@onready var player: CharacterBody3D = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Vector3(player.global_position.x + 0.5, global_position.y, player.global_position.z + 3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = Vector3(player.global_position.x + 0.5, global_position.y, player.global_position.z + 3)


func _on_vehicle_exited(body: Node3D) -> void:
	pass # Replace with function body.
