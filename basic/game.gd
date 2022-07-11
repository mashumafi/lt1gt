extends Node

const Hand := preload("hand.tscn")
const STARTING_HAND_SIZE := 8

onready var stack := $Stack as Stack
onready var hand := $Hand as Position2D

var hand_size := STARTING_HAND_SIZE

func _ready() -> void:
	stack.set_card_data(Cards.create_random())
	deal()

func deal() -> void:
	for child in hand.get_children():
		child.free()

	var first := [stack.card]

	var cards := [Cards.create_neighbor(stack.get_card_data(), first)]
	for i in range(1, hand_size):
		cards.append(Cards.create_neighbor(cards[i - 1], first + cards))
	cards.shuffle()
	hand_size += 1

	for card in cards:
		var hand_card := Hand.instance()
		hand_card.connect("dropped", self, "_card_dropped", [hand_card])
		hand.add_child(hand_card)
		hand_card.card.position = Vector2(180 + 64, -14)
		hand_card.set_card_data(card)
	space_out_cards(1.25)

func space_out_cards(decay := 1.0) -> void:
	var delay := 1.0
	for i in hand.get_child_count():
		delay /= decay
		var offset = -9.0 * hand.get_child_count() + 4.5 + 18.0 * i
		hand.get_child(i).animate(Vector2.RIGHT * offset, 1.0 - delay)

func _card_dropped(hand_card: Hand) -> void:
	if stack.inside and Cards.are_neighbors(stack.get_card_data(), hand_card.get_card_data()):
		stack.set_card_data(hand_card.get_card_data())
		hand_card.visible = false # prevent card from flickering back to hand
		yield(get_tree(), "idle_frame")
		hand_card.free()
		space_out_cards(1.0)
		if hand.get_child_count() == 0:
			deal()
		for hand_card in hand.get_children():
			if Cards.are_neighbors(hand_card.get_card_data(), stack.get_card_data()):
				return

		hand_size = STARTING_HAND_SIZE
		deal()
