class_name Cards
extends Reference

enum Icons {Zero, One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Skip, Reverse, Plus2, Plus4, Wild, Max}
enum Colors {Red, Green, Blue, Yellow, Max}

static func get_border_texture() -> AtlasTexture:
	var border_texture := AtlasTexture.new()
	border_texture.atlas = preload("cards.png")
	border_texture.region = Rect2(4, 4, 16, 24)
	return border_texture

static func get_card_front_texture() -> AtlasTexture:
	var card_front_texture := AtlasTexture.new()
	card_front_texture.atlas = preload("cards.png")
	card_front_texture.region = Rect2(25, 2, 20, 28)
	return card_front_texture

static func get_card_back_texture() -> AtlasTexture:
	var card_back_texture := AtlasTexture.new()
	card_back_texture.atlas = preload("cards.png")
	card_back_texture.region = Rect2(48, 2, 20, 28)
	return card_back_texture

static func get_icon_texture(icon: int) -> AtlasTexture:
	var icon_texture := AtlasTexture.new()
	icon_texture.atlas = preload("icons.png")
	icon_texture.region = Rect2(1 + icon * 11, 1, 11, 7)
	return icon_texture

static func are_neighbors(left: CardData, right: CardData) -> bool:
	if left.icon <= Icons.Nine and right.icon <= Icons.Nine:
		return left.icon == right.icon or left.color == right.color
	else:
		return left.color == right.color

static func get_color_ids(count: int) -> Array:
	var colors := []
	for color in Colors.Max:
		for i in count:
			colors.append(color)
	return colors

static func get_icon_ids(count: int, max_icon : int) -> Array:
	var icons := []
	for icon in max_icon:
		for i in count:
			icons.append(icon)
	return icons

static func get_color(color: int) -> Color:
	match color:
		Colors.Red: return Color.darkred
		Colors.Green: return Color.darkgreen
		Colors.Blue: return Color.darkblue
		Colors.Yellow: return Color.darkgoldenrod
	return Color.white

static func create_random() -> CardData:
	var color : int = randi() % Colors.Max
	var icon := randi() % 10
	return CardData.new(icon, color)

static func create_neighbor(card: CardData, bias: Array) -> CardData:
	var color := card.color
	var icon := card.icon
	while color == card.color and icon == card.icon:
		if randi() % 2 == 0:
			color = randi() % Colors.Max
		else:
			icon = randi() % 10
	return CardData.new(icon, color)
