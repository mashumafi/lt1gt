class_name CardData
extends Reference

var icon : int setget set_icon, get_icon
var color : int setget set_color, get_color

func set_icon(p_icon: int) -> void:
	icon = p_icon

func get_icon() -> int:
	return icon

func set_color(p_color: int) -> void:
	color = p_color

func get_color() -> int:
	return color

func _init(icon: int, color: int) -> void:
	self.icon = icon
	self.color = color
