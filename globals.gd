extends Node

enum FroggerState { LAND, VEHICLE }

var player_state: FroggerState = FroggerState.LAND
var current_vehicle: Vehicle = null
