class_name Card
extends Area2D

onready var front := $Front as Sprite
onready var border := $Border as Sprite
onready var icon := $Icon as Sprite
onready var wild := $Wild as Position2D
onready var highlight := $Highlight as Sprite
onready var tween := $Tween as Tween

var data : CardData setget set_data, get_data

func set_data(p_data: CardData) -> void:
	data = p_data
	var color := Cards.get_color(data.color)
	if data.icon < Cards.Icons.Wild:
		wild.visible = false
		front.texture = Cards.get_card_front_texture()
		border.texture = Cards.get_border_texture()
		border.self_modulate = color
		icon.texture = Cards.get_icon_texture(data.icon)
		icon.self_modulate = color
	else:
		wild.visible = true

func get_data() -> CardData:
	return data

func set_highlight(color: Color) -> void:
	tween.interpolate_property(highlight, "self_modulate", highlight.self_modulate, color, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()
