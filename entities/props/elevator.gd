extends AnimatableBody2D
class_name Elevator

@export_group("Elevator Properties")
@export var speed := 50.0
@export var is_solid_on_start := false
@export_group("Elevator Points")
@export var points: Array[NodePath] = []

@onready var _timer := $timer as Timer

var index := -1
var current_point: Vector2


func _ready() -> void:
    if is_solid_on_start:
        self.set_collision_layer_value(1, true)
        self.set_collision_layer_value(9, false)

    if !points.is_empty():
        index = 0
        current_point = (get_node(points[0]) as Node2D).global_position
        self.global_position = current_point
    else:
        current_point = self.global_position
        push_warning("No points for elevator...")


func move_to_next() -> void:
    if index + 1 == points.size():
        index = 0
    else:
        index += 1

    var next_point := get_node(points[index]).global_position as Vector2
    var tween := create_tween()
    tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
    tween.tween_property(self, "global_position", next_point, 2.0)\
        .set_delay(0.1)\
        .set_trans(Tween.TRANS_LINEAR)\
        .set_ease(Tween.EASE_IN_OUT)
    tween.tween_callback(_timer.start)


func _on_elevator_started() -> void:
    self.set_collision_layer_value(1, false)
    self.set_collision_layer_value(9, true)
    move_to_next()


func _on_timer_timeout() -> void:
    move_to_next()
