extends Pickup
class_name MoneyPickup

var count := 1
var tint := Color.WHITE


static func get_pickup(number: int) -> Array[MoneyPickup]:
    const path := "res://entities/items/money.tscn"

    if number <= 0:
        return []

    var scene := load(path) as PackedScene
    var arr: Array[MoneyPickup] = []

    while number > 0:
        var coin := scene.instantiate()
        arr.append(coin)

        if number >= 100:
            coin.tint = Color.WHITE
            coin.count = 100
            number -= 100
        elif number >= 50:
            coin.tint = Color.SILVER
            coin.count = 50
            number -= 50
        elif number >= 25:
            coin.tint = Color.SADDLE_BROWN
            coin.count = 25
            number -= 25
        elif number >= 10:
            coin.tint = Color.VIOLET
            coin.count = 10
            number -= 10
        elif number >= 5:
            coin.tint = Color.MEDIUM_SPRING_GREEN
            coin.count = 5
            number -= 5
        else:
            coin.tint = Color.DODGER_BLUE
            coin.count = 1
            number -= 1

    return arr


func action(params: Dictionary) -> void:
    Logger.debug("Player got $%d" % params.count)

    if params.body.has_method("add_money"):
        params.body.add_money(params.count)


func _ready() -> void:
    $anim.play("idle")
    self.modulate = tint


func _on_body_entered(body: Player) -> void:
    if !body: return

    action({"body": body, "count": count})
    self.queue_free()
