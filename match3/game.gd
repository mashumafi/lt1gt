extends Node

const Card := preload("res://core/card.tscn")

func _ready() -> void:
	randomize()
	var card := Card.instance()
	add_child(card)
	var colors := Cards.get_color_ids(2)
	var icons := Cards.get_icon_ids(2, Cards.Icons.Four + 1)

	card.card = CardData.new(Random.take_item(icons), Random.take_item(colors))
	card.position = Vector2.ONE * 25
