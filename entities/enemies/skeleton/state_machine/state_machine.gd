extends EnemyStateMachine

## using vector for range, X is minimum, Y is maximum
@export var idle_range := Vector2(1.5, 3.5)
## using vector for range, X is minimum, Y is maximum
@export var walk_range := Vector2(2.5, 5.1)

@onready var _owner := self.owner as BaseEnemy
@onready var _patrol_timer := $patrolling_timer as Timer

var _rng := RandomNumberGenerator.new()
var _patrol_states := ["idle", "walk", "fall"]


func _on_owner_ready() -> void:
    super._on_owner_ready()

    _rng.randomize()
    _patrol_timer.start(_rng.randf_range(idle_range[0], idle_range[1]))


func _on_state_change(old_state: String, new_state: String) -> void:
    if old_state in _patrol_states && !(new_state in _patrol_states):
        # exit patrolling
        _patrol_timer.stop()

    if new_state == "idle":
        _patrol_timer.start(_rng.randf_range(idle_range[0], idle_range[1]))
    elif new_state == "walk":
        _patrol_timer.start(_rng.randf_range(walk_range[0], walk_range[1]))

    super._on_state_change(old_state, new_state)


func _on_obstacle_detected(_body) -> void:
    if !_current_state.has_meta("no_turn_on_obstacle"):
        _owner.flip = !_owner.flip


func _on_patrolling_timer_timeout() -> void:
    if _rng.randi() % 2 == 0:
        _owner.flip = !_owner.flip

    match _current_state.name:
        "idle":
            change_state("walk")
        "walk":
            change_state("idle")
