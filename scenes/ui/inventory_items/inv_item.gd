extends Button

var item_id := ""
var _item := {}


func _ready() -> void:
    var arr := Database.get_item_by_name(item_id)
    if arr.size() > 0:
        _item = arr[0]


func get_title() -> String:
    return _item.TITLE


func get_desc() -> String:
    return _item.DESC
