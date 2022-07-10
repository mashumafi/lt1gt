class_name Stack
extends Area2D

onready var card := $Card as Card

var inside := false

func set_card_data(p_card_data: CardData) -> void:
	card.data = p_card_data

func get_card_data() -> CardData:
	return card.data

func _mouse_entered():
	inside = true

func _mouse_exited():
	inside = false
