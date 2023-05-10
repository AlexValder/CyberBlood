extends Area2D
class_name Ladder

signal off_ladder

@export var facing_left := false

@onready var _node := $shape as CollisionShape2D
@onready var _shape := _node.shape as RectangleShape2D

var _player: Player
var _top: float
var _bottom: float


func get_center() -> float:
    return _node.global_position.x

func get_ladder_length() -> float:
    return _shape.size.x

func get_player_center() -> float:
    if facing_left:
        return _node.global_position.x + _shape.size.x
    else:
        return _node.global_position.x - _shape.size.x


func _init() -> void:
    set_physics_process(false)


func _ready() -> void:
    _top = _node.global_position.y - _shape.size.y / 2
    _bottom = _top + _shape.size.y


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
