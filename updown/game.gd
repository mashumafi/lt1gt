extends Node

const HandNode := preload("updown_hand.tscn")
const STARTING_HAND_SIZE := 5

onready var stack := $Stack as UpDownStack
onready var hand := $Hand as Position2D

var hand_size := STARTING_HAND_SIZE

func _ready() -> void:
	randomize()

	stack.set_card_data(UpDownCards.create_random())
	deal()

func deal() -> void:
	for child in hand.get_children():
		child.free()

	var first := [stack.card]

	var cards := [UpDownCards.create_neighbor(stack.get_card_data())]
	for i in range(1, hand_size):
		cards.append(UpDownCards.create_neighbor(cards[i - 1]))
	cards.shuffle()
	hand_size += 1

	for card in cards:
		var hand_card := HandNode.instance()
		hand_card.connect("dropped", self, "_card_dropped", [hand_card])
		hand.add_child(hand_card)
		hand_card.card.position = Vector2(180 + cards.size() / 2 * 20, 0)
		hand_card.set_card_data(card)
	space_out_cards(1.25)

func space_out_cards(decay := 1.0) -> void:
	var delay := 1.0
	for i in hand.get_child_count():
		delay /= decay
		var offset = -9.0 * hand.get_child_count() + 5 + 20.0 * i
		hand.get_child(i).animate(Vector2.RIGHT * offset, 1.0 - delay)
		var card : UpDownCard = hand.get_child(i).card
		var card_data : UpDownCardData = card.data
		if UpDownCards.are_neighbors(stack.card.data, card_data):
			card.set_highlight(Color.white)
		else:
			card.set_highlight(Color.transparent)

func _card_dropped(hand_card: UpDownHand) -> void:
	if stack.inside and UpDownCards.are_neighbors(stack.get_card_data(), hand_card.get_card_data()):
		stack.set_card_data(hand_card.get_card_data())
		hand_card.visible = false # prevent card from flickering back to hand
		yield(get_tree(), "idle_frame")
		hand_card.free()
		space_out_cards(1.0)
		if hand.get_child_count() == 0:
			deal()
		for hand_card in hand.get_children():
			if UpDownCards.are_neighbors(stack.get_card_data(), hand_card.get_card_data()):
				return

		hand_size = STARTING_HAND_SIZE
		deal()
