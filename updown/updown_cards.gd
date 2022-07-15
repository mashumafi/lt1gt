class_name UpDownCards
extends Reference

static func are_neighbors(stack: UpDownCardData, hand: UpDownCardData) -> bool:
	if stack.icon <= Cards.Icons.Nine and hand.icon <= Cards.Icons.Nine:
		if stack.color == hand.color:
			if stack.negative:
				return stack.icon > hand.icon
			else:
				return stack.icon < hand.icon
		return stack.icon == hand.icon
	return stack.color == hand.color

static func get_negative(icon: int) -> bool:
	if icon == Cards.Icons.Zero:
		return false
	elif icon == Cards.Icons.Nine:
		return true
	else:
		return bool(randi() % 2)

static func create_random() -> UpDownCardData:
	var color : int = randi() % Cards.Colors.Max
	var icon := randi() % 10
	var negative := get_negative(icon)
	return UpDownCardData.new(icon, color, negative)

static func create_neighbor(card: UpDownCardData) -> UpDownCardData:
	var color := card.color
	var icon := card.icon
	while color == card.color and icon == card.icon:
		if randi() % 2 == 0:
			color = randi() % Cards.Colors.Max
		else:
			if card.negative:
				icon = randi() % card.icon
			else:
				icon = card.icon + 1 + randi() % (Cards.Icons.Nine - card.icon)

	var negative := get_negative(icon)
	return UpDownCardData.new(icon, color, negative)
