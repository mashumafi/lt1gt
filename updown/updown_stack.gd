class_name UpDownStack
extends Position2D

onready var card := $Card as UpDownCard

var inside := false

func set_card_data(p_card_data: UpDownCardData) -> void:
	card.data = p_card_data

func get_card_data() -> UpDownCardData:
	return UpDownCardData.new(card.data.icon, card.data.color, card.is_negative())

func _mouse_entered():
	inside = true

func _mouse_exited():
	inside = false
