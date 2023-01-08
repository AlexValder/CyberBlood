extends CharacterBody2D
class_name Player

enum PlayerForms {
    HUMAN,
    BAT,
}

signal player_dead
signal player_damaged(old_value, new_value)
signal mana_spent(new_value)

const GRAVITY := 350.0
const WALK_SPEED := 120.0
const FLY_SPEED := 200.0
const JUMP := 210.0
const ACCEL := 0.1
const HUMAN_SHAPE_SIZE := {
    radius = 11 / 2,
    height = 42 / 2,
}
const BAT_SHAPE_SIZE := {
    radius = 6 / 2,
    height = 12 / 2,
}

@onready var _sprite := $sprite as AnimatedSprite2D
@onready var _shape := $shape as CollisionShape2D
@onready var _camera := $camera as Camera2D
@onready var _status := $sprite/status as Label
@onready var _timer := $timers/damage_timer as Timer
@onready var _player_anim := $player_effects as AnimationPlayer

@export var max_health: int = 50
@export var max_mana: float = 100.0

var current_health := max_health
var current_mana := max_mana
var mana_recovery_rate := 1.0
var invincible := false


func damage(value: int) -> void:
    if invincible:
        return

    emit_signal("player_damaged", \
        current_health, max(0, current_health - value))

    current_health -= value
    if current_health <= 0:
        play_anim("death")
        _sprite.animation_finished.connect(
            func(): emit_signal("player_dead"), Object.CONNECT_ONE_SHOT
        )

    _on_start_invicibility()


func can_transform(form: PlayerForms) -> bool:
    match(form):
        PlayerForms.HUMAN:
            return _check_space(
                HUMAN_SHAPE_SIZE.radius,
                HUMAN_SHAPE_SIZE.height
            )
        PlayerForms.BAT:
            # the smallest form, no need to check for space
            return true

    return false


func has_mana(value: int) -> bool:
    if current_mana > value:
        emit_signal("mana_spent", current_mana - value)
        current_mana -= value
        return true
    else:
        return false


func play_anim(anim_name: String, use_assert: bool = false) -> void:
    if use_assert:
        assert(_sprite.frames.has_animation(anim_name), \
            "animation not found: %s" % anim_name)

    _sprite.play(anim_name)


func ensure_collision(form: PlayerForms) -> void:
    match (form):
        PlayerForms.HUMAN:
            _shape.shape.radius = HUMAN_SHAPE_SIZE.radius * 2
            _shape.shape.height = HUMAN_SHAPE_SIZE.height * 2
        PlayerForms.BAT:
            _shape.shape.radius = BAT_SHAPE_SIZE.radius * 2
            _shape.shape.height = BAT_SHAPE_SIZE.height * 2
        _:
            push_error("Unknown form: %s" % form)

    velocity.y += 1
    move_and_slide()


func reset() -> void:
    var health_bar := $"%health_bar" as HealthBar
    current_health = max_health
    health_bar.value = max_health
    health_bar.update()

    var mana_bar := $"%mana_bar" as ManaBar
    current_mana = max_mana
    mana_bar.value = max_mana
    mana_bar.update()

    $state_machine.reset()
    self.velocity = Vector2.ZERO
    self._sprite.flip_h = false


func update_status(status: String) -> void:
    _status.text = status


func set_limits(vec: Vector4i) -> void:
    _camera.limit_left = vec[0]
    _camera.limit_top = vec[1]
    _camera.limit_right = vec[2]
    _camera.limit_bottom = vec[3]


func _ready() -> void:
    var health_bar := $"%health_bar" as HealthBar
    health_bar.max_value = max_health
    health_bar.value = current_health
    health_bar.update()

    var mana_bar := $"%mana_bar" as ManaBar
    mana_bar.max_value = max_mana
    mana_bar.value = current_mana
    mana_bar.update()


func _on_start_invicibility() -> void:
    self.invincible = true
    _timer.start(1)
    _player_anim.play("damage_invincibility")


func _on_stop_invincibility() -> void:
    self.invincible = false
    _player_anim.seek(0)
    _player_anim.stop()


func _on_recovery_value_timeout(rate: float) -> void:
    current_mana = min(max_mana, current_mana + rate)


func _check_space(h_space: float, v_space: float) -> bool:
    var horizontal: float
    var vertical: float

    # 1. Horizontal:
    # first check if we have twice the required size to the left
    # if not, remember how much we have and check the same to the right
    # sum of both has to be no less than required

    var space_state := get_world_2d().get_direct_space_state()
    var params: = PhysicsRayQueryParameters2D.new()
    params.from = self.global_position
    params.to = self.global_position + Vector2(2 * h_space, 0)
    params.hit_from_inside = true
    params.exclude = [self.get_rid()]
    params.collision_mask = 0b10

    var result := space_state.intersect_ray(params)

    if result:
        horizontal = abs(self.global_position.x - result.position.x)
        params.to = self.global_position + Vector2(-2 * h_space, 0)
        result = space_state.intersect_ray(params)

        if result:
            horizontal += 1.0 * abs(result.position.x - self.global_position.x)
        else:
            horizontal += h_space * 2

        if horizontal < h_space * 2:
            # too narrow
            return false
    else:
        horizontal = h_space * 2

    # 2. Vertical:
    # first check if we have twice the required size upwards
    # if not, remember how much we have and check the same downwards
    # sum of both has to be no less than required

    params.to = self.global_position + Vector2(0, -2 * v_space)
    result = space_state.intersect_ray(params)

    if result:
        vertical = abs(self.global_position.y - result.position.y)
        params.to = self.global_position + Vector2(0, 2 * v_space)
        result = space_state.intersect_ray(params)

        if result:
            vertical += 1.0 * abs(result.position.y - self.global_position.y)
        else:
            vertical += v_space * 2

        if vertical < v_space * 2:
            # too short
            return false
    else:
        vertical = v_space * 2

    return vertical >= v_space * 2 && horizontal >= h_space * 2
