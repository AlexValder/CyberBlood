extends EnemyState

@export var _obstacle_area: Area2D
@export var _check_for_floor: RayCast2D

func _ready() -> void:
    assert(_obstacle_area != null)
    assert(_check_for_floor != null)


func on_entry() -> void:
    _enemy.play_anim("walk", 1.2)


func process(_delta: float) -> void:
    var enemy := owner.global_position.x as float
    var player := GameManager.player.global_position.x
    if (abs(enemy - player) >= 0.01):
        owner.flip = enemy > player


func physics_process(_delta: float) -> void:
    if GameManager.player == null:
        state_change.emit(self.name, "watch")
        return

    var eyes := _enemy.eyes.global_position
    var player := GameManager.player.global_position
    var distance := (eyes - player).length()

    if !_can_chase(distance, abs(eyes.x - player.x)):
        _enemy.velocity.x = 0
        state_change.emit(self.name, "watch")
    else:
        _enemy.velocity.x = _enemy.CHASE_SPEED * (-1 if _enemy.flip else 1)

    _enemy.move_and_slide()


func _can_chase(distance: float, distance_x: float) -> bool:
    return distance_x >= 2.0 && \
        distance > _enemy.ATTACK_DISTANCE && \
        distance <= _enemy.KEEPS_SEEING && \
        _check_for_floor.is_colliding() && \
        !_obstacle_area.has_overlapping_bodies()
