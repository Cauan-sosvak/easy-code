class_name MapDefinition
extends Resource

@export var id: StringName
@export var display_name: String
@export_multiline var description: String
@export var illustration: Texture2D
@export var accent: Color
@export var levels: Array[LevelDefinition] = []
