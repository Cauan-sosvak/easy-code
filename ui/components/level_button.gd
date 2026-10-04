class_name LevelButton
extends Button
## Layout lives in level_button.tscn.

var definition: LevelDefinition

func setup(data: LevelDefinition, accent: Color) -> void:
	definition = data
	%Number.text = "%02d" % data.number
	%Number.add_theme_color_override("font_color", accent)
	accessibility_name = "Nível %d" % data.number
