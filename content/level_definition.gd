class_name LevelDefinition
extends Resource
## Stable content identity, independent of labels and scene paths.

@export var id: StringName
@export_range(1, 999) var number: int = 1

@export_file("*.tscn") var scene_path: String = ""
