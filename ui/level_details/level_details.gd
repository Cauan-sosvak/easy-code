extends Control

signal close_requested

func open_details(map: MapDefinition, level: LevelDefinition) -> void:
	%MapName.text = map.display_name.to_upper()
	%MapName.add_theme_color_override("font_color", map.accent)
	%LevelTitle.text = "Nível %02d" % level.number
	%Illustration.texture = map.illustration
	show()
	%Close.grab_focus()

func _on_close_pressed() -> void:
	close_requested.emit()
