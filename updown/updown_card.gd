class_name UpDownCard
extends Card

onready var arrow := $Arrow as Sprite

func is_negative() -> bool:
	return is_equal_approx(arrow.rotation, PI)

func set_data(p_data: CardData) -> void:
	.set_data(p_data)

	arrow.self_modulate = Cards.get_color(p_data.color)
	if p_data is UpDownCardData:
		arrow.rotation = PI if p_data.negative else 0 
