extends Area2D
class_name Ladder

signal off_ladder

var _player: Player
var _top: float
var _bottom: float


func _init() -> void:
    set_physics_process(false)


func _ready() -> void:
    var node := $shape as CollisionShape2D
    var shape := node.shape as RectangleShape2D

    _top = node.global_position.y - shape.size.y / 2
    _bottom = _top + shape.size.y


func _physics_process(_delta: float) -> void:
    if _player == null:
        return

    if _player.velocity.y < 0 &&\
        _player.ladder_point.global_position.y < _top:
        off_ladder.emit()
    elif _player.velocity.y > 0 && \
        _player.ladder_point.global_position.y > _bottom:
        off_ladder.emit()


func _on_body_entered(player: Player) -> void:
    if player == null:
        return

    _player = player
    set_physics_process(true)


func _on_body_exited(player: Player) -> void:
    if player == null:
        return

    _player = null
    set_physics_process(false)
    off_ladder.emit()
