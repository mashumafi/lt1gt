extends Node

const CardNode := preload("res://core/card.tscn")

const WIDTH := 5
const HEIGHT := 5

onready var tween : Tween = $Tween

class ValidChoices:
	const MATCH_LIMIT := 2

	var valid_icons := []
	var valid_colors := []

	var invalid_icons := []
	var invalid_colors := []

	func _init() -> void:
		for i in MATCH_LIMIT:
			for j in Cards.Icons.Five:
				valid_icons.append(j)
			for j in Cards.Colors.Max:
				valid_colors.append(j)

	func remove_choice(data: CardData) -> void:
		valid_colors.erase(data.color)
		invalid_colors.append(data.color)
		if invalid_colors.size() > MATCH_LIMIT:
			var front = invalid_colors.pop_front()
			valid_colors.push_back(front)

		valid_icons.erase(data.icon)
		invalid_icons.append(data.icon)
		if invalid_icons.size() > MATCH_LIMIT:
			var front = invalid_icons.pop_front()
			valid_icons.push_back(front)

	func union(left: Array, right: Array) -> Array:
		var result := []
		for item in left:
			if right.has(item):
				right.erase(item)
				result.append(item)
		return result

	func make_card(data: ValidChoices) -> CardData:
		var icons := union(valid_icons.duplicate(), data.valid_icons.duplicate())
		var icon = Random.copy_item(icons)
		var colors := union(valid_colors.duplicate(), data.valid_colors.duplicate())
		var color = Random.copy_item(colors)
		var card_data := CardData.new(icon, color)
		return card_data

	static func take_card(row: ValidChoices, col: ValidChoices) -> CardData:
		var card_data := row.make_card(col)
		row.remove_choice(card_data)
		col.remove_choice(card_data)
		return card_data

func _ready() -> void:
	randomize()

	var cards := []

	var column_choice := []
	for column in WIDTH:
		column_choice.append(ValidChoices.new())

	for y in HEIGHT:
		var row_choice := ValidChoices.new()
		
		for x in WIDTH:
			var data := ValidChoices.take_card(row_choice, column_choice[x])
			var card : Card = CardNode.instance()
			card.connect("input_event", self, "_card_input_event", [card])
			add_child(card)
			card.data = data
			card.position = Vector2(x, y) * 32 + Vector2(64, 32)


func check_for_matches(dirty: PoolVector2Array) -> bool:
	return false

var selected_card : Card
var can_select := true

func _card_input_event(viewport: Node, event: InputEvent, shape_idx: int, card: Card) -> void:
	if not can_select:
		return

	var mouse_button := event as InputEventMouseButton
	if mouse_button and mouse_button.pressed:
		if selected_card:
			if selected_card == card:
				# Remove selection from card
				selected_card.set_highlight(Color.transparent)
				selected_card = null
			elif card.position.distance_squared_to(selected_card.position) <= 32*32:
				can_select = false
				tween.interpolate_property(card, "position", card.position, selected_card.position, 1.0, Tween.TRANS_LINEAR)
				tween.interpolate_property(selected_card, "position", selected_card.position, card.position, 1.0, Tween.TRANS_LINEAR)
				tween.start()
				selected_card.set_highlight(Color.transparent)
				yield(tween, "tween_all_completed")
				if not check_for_matches(PoolVector2Array([card.position, selected_card.position])):
					tween.interpolate_property(card, "position", card.position, selected_card.position, 1.0, Tween.TRANS_LINEAR)
					tween.interpolate_property(selected_card, "position", selected_card.position, card.position, 1.0, Tween.TRANS_LINEAR)
					tween.start()
				selected_card = null
				can_select = true
			else:
				# Select a new card, too far
				selected_card.set_highlight(Color.transparent)
				selected_card = card
				selected_card.set_highlight(Color.white)
		else:
			# Select the card
			selected_card = card
			selected_card.set_highlight(Color.white)
