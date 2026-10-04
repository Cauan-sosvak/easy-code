extends Node3D
## Level metadata is exposed for editing and verification; layout lives in .tscn.

@export var floor_bounds := Rect2(-16, -14, 32, 28)
@export var walk_bounds := Rect2(-9, -7, 18, 14)

func _ready() -> void:
	$CameraRig.map_bounds = floor_bounds
