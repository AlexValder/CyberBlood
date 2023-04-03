extends HBoxContainer

@onready var _total := $total as Label
@onready var _adding := $adding as Label
var _count := 0


func set_money(count: int) -> void:
    _count = count
    _total.text = "$ %d" % count
    _adding.text = ""
    _adding.self_modulate.a = 0


func add_money(count: int) -> void:
    _count += count
    _total.text = "$ %d" % _count
    _adding.text = "+ %d" % count
    _adding.self_modulate.a = 1
    var tween := get_tree().create_tween() as Tween
    tween.tween_property(_adding, "self_modulate:a", 0, 1.0)
    tween.play()


func remove_money(count: int) -> void:
    _count -= count
    _total.text = "$ %d" % _count
    _adding.text = "- %d" % count
    _adding.self_modulate.a = 1
    var tween := get_tree().create_tween() as Tween
    tween.tween_property(_adding, "self_modulate:a", 0, 1.0)
    tween.play()
