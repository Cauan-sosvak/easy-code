extends Control

signal map_selected(map_id: StringName)

const CARD_SCENE := preload("res://ui/components/map_card.tscn")
var cards: Dictionary[StringName, MapCard] = {}

func populate(maps: Array[MapDefinition]) -> void:
	for child in %Cards.get_children():
		%Cards.remove_child(child)
		child.queue_free()
	cards.clear()
	for data in maps:
		var card := CARD_SCENE.instantiate() as MapCard
		%Cards.add_child(card)
		card.setup(data)
		card.pressed.connect(func() -> void: map_selected.emit(data.id))
		cards[data.id] = card
	_update_columns()

func focus_map(map_id: StringName = &"") -> void:
	if cards.has(map_id):
		cards[map_id].grab_focus()
	elif not cards.is_empty():
		cards.values()[0].grab_focus()

func _update_columns() -> void:
	if not is_node_ready():
		return
	%Cards.columns = 3 if size.x >= 960 else (2 if size.x >= 650 else 1)
