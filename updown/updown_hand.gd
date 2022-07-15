class_name UpDownHand
extends Area2D

signal dropped()

onready var tween := $Tween as Tween
onready var card := $Card as UpDownCard

var offset := Vector2.INF
var inside := false

func set_card_data(p_card_data: UpDownCardData) -> void:
	card.data = p_card_data

func get_card_data() -> UpDownCardData:
	return UpDownCardData.new(card.data.icon, card.data.color, card.is_negative())

func _mouse_entered() -> void:
	inside = true
	if offset != Vector2.INF:
		return

	z_index = 1

	tween.interpolate_property(card, "scale", card.scale, Vector2.ONE * 2, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()

func _mouse_exited() -> void:
	inside = false
	if offset != Vector2.INF:
		return

	z_index = 0

	tween.interpolate_property(card, "scale", card.scale, Vector2.ONE, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()

func _input_event(viewport: Object, event: InputEvent, shape_idx: int) -> void:
	var mouse_button := event as InputEventMouseButton
	if mouse_button:
		if mouse_button.pressed and mouse_button.button_mask & BUTTON_LEFT:
			offset = mouse_button.position - card.global_position

func _process(delta):
	if not Input.is_mouse_button_pressed(BUTTON_LEFT) and offset != Vector2.INF:
		offset = Vector2.INF
		tween.interpolate_property(card, "position", card.position, Vector2.ZERO, .5, Tween.TRANS_QUAD, Tween.EASE_OUT)
		if inside:
			tween.start()
		else:
			_mouse_exited()
		emit_signal("dropped")

	if offset != Vector2.INF:
		card.global_position = get_viewport().get_mouse_position() - offset

func animate(to: Vector2, delay := 1.0) -> void:
	var from := card.global_position
	position = to
	tween.interpolate_property(card, "global_position", from, global_position, 1.0 - delay, Tween.TRANS_QUAD, Tween.EASE_OUT, delay)
	tween.start()
