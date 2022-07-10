class_name Random
extends Reference

static func index(items: Array) -> int:
	return randi() % items.size()

static func copy_item(items: Array):
	return items[index(items)]

static func take_item(items: Array):
	var position := index(items)
	var item = items[position]
	items.remove(position)
	return item
