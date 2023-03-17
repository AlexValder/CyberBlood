extends InventoryTab

@onready var _table := $hbox/hbox/items as GridContainer
@onready var _title := $hbox/panel/vbox/title as Label
@onready var _desc := $hbox/panel/vbox/desc as Label

const _PATHS := {
    "key_generic": "res://scenes/ui/inventory_items/key_generic.tscn",
    "empty": "res://scenes/ui/inventory_items/empty_item.tscn",
}


func grab_gamepad_focus() -> void:
    if _table.get_child_count() == 0:
        return

    var child := _table.get_child(0) as Button
    child.grab_click_focus()


func _on_visibility_changed() -> void:
    if _table == null || !self.visible:
        return

    for child in _table.get_children():
        child.queue_free()

    for item in GameManager.player.inventory:
        # TODO: determine actual types
        var button = load(_PATHS["key_generic"]).instantiate() as Button
        button.item_id = item
        button.set_meta("db_entry", item)
        connect_signals(button)
        _table.add_child(button, true)

    var left_empty := _table.columns * 5  - GameManager.player.inventory.size()
    for i in left_empty:
        var empty = load(_PATHS["empty"]).instantiate() as Button
        empty.disabled = true
        _table.add_child(empty)

    var child := _table.get_child(0) as Button
    child.grab_click_focus()


func connect_signals(item: Button) -> void:
    item.focus_entered.connect(show_desc.bind(item))
    item.focus_exited.connect(hide_desc)


func show_desc(item: Button) -> void:
    _title.text = item.get_title()
    _desc.text = item.get_desc()


func hide_desc() -> void:
    _title.text = ""
    _desc.text = ""
