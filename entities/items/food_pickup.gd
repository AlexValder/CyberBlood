extends Pickup
class_name FoodPickup

## 0 for random, 1-30 for specific item
@export_range(0, 30, 1) var _index: int
@export_file("*.json") var file_data: String

var restores := 1


static func get_pickup() -> FoodPickup:
    const path := "res://entities/items/food_pickup.tscn"
    return (load(path) as PackedScene).instantiate() as FoodPickup


func action(values: Dictionary) -> void:
    if values.body.has_method("heal"):
        values.body.heal(values.restores)
    if values.body.has_method("give_manaw"):
        values.body.give_mana(values.restores)


func _ready() -> void:
    var file := FileAccess.open(file_data, FileAccess.READ)
    var json := file.get_as_text()
    var list = JSON.parse_string(json)
    assert(typeof(list) == TYPE_ARRAY)

    var item: Dictionary
    if _index == 0:
        var actual_index := randi_range(0, 29)
        item = list[actual_index]
        _setup_value(actual_index)
    else:
        item = list[_index - 1]
        _setup_value(_index - 1)

    assert(item.has("name"))
    assert(item.has("costs"))

    restores = item.costs


func _setup_value(index: int) -> void:
    var atlas := _sprite.texture as AtlasTexture
    atlas.region.position.x = (index % 5) * 16
    atlas.region.position.y = (index / 5) * 16


func _on_body_entered(body: Player) -> void:
    if !body: return

    action({"body": body, "restores": restores})
    self.queue_free()
