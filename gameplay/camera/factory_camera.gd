extends Node3D
## Phantom Camera supplies damping. This rig confines the entire ground footprint,
## including after a resize, instead of just clamping the camera's center.

@export var target: Node3D
@export var map_bounds := Rect2(-16.0, -14.0, 32.0, 28.0):
	set(value):
		map_bounds = value
		if is_node_ready():
			_update_projection()
@export var floor_height: float = 0.0
@export_range(4.0, 14.0) var view_height: float = 9.0
@export var maximum_view_width: float = 16.0
@export var edge_margin: float = 0.2

@onready var camera: Camera3D = $Camera3D
@onready var phantom: PhantomCamera3D = $PhantomCamera3D
@onready var bounded_target: Node3D = $BoundedTarget
var _half_footprint := Vector2.ZERO
var _offset := Vector3.ZERO

func _ready() -> void:
	_offset = phantom.basis.z * 32.0
	phantom.follow_offset = _offset
	_update_projection()
	_update_target()
	phantom.position = bounded_target.position + _offset
	camera.position = phantom.position
	phantom.teleport_position()
	get_viewport().size_changed.connect(_update_projection)

func _process(_delta: float) -> void:
	_update_target()
	# Runs after PhantomCameraHost (priority 300). In normal movement the host
	# is already inside these bounds; this guard handles sudden viewport changes.
	var center := camera.global_position - _offset
	camera.global_position = _confine(center) + _offset

func _update_projection() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	var aspect := viewport_size.x / maxf(viewport_size.y, 1.0)
	var height := minf(view_height, maximum_view_width / aspect)
	var sine := sin(absf(phantom.rotation.x))
	var right := Vector2(phantom.basis.x.x, phantom.basis.x.z).abs()
	var forward := Vector2(phantom.basis.z.x, phantom.basis.z.z).normalized().abs()
	var footprint_per_unit := right * aspect * 0.5 + forward * 0.5 / sine
	var available := map_bounds.size * 0.5 - Vector2.ONE * edge_margin
	height = minf(height, minf(available.x / footprint_per_unit.x, available.y / footprint_per_unit.y))
	_half_footprint = footprint_per_unit * height
	phantom.camera_3d_resource.size = height
	camera.size = height

func _update_target() -> void:
	if not is_instance_valid(target):
		return
	var position := target.get_global_transform_interpolated().origin
	position.y = floor_height
	bounded_target.global_position = _confine(position)

func _confine(position: Vector3) -> Vector3:
	var low := map_bounds.position + _half_footprint + Vector2.ONE * edge_margin
	var high := map_bounds.end - _half_footprint - Vector2.ONE * edge_margin
	return Vector3(clampf(position.x, low.x, high.x), floor_height, clampf(position.z, low.y, high.y))
