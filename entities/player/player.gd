extends CharacterBody2D
class_name Player

enum PlayerForms {
    HUMAN,
    BAT,
}

signal player_dead
signal player_hurt
signal player_damaged(old_value, new_value)
signal mana_spent(new_value)

const GRAVITY := 350.0
const WALK_SPEED := 120.0
const FLY_SPEED := 200.0
const JUMP := 210.0
const ACCEL := 0.1
const HUMAN_SHAPE_SIZE := {
    radius = 12 / 2,
    height = 44 / 2,
}
const BAT_SHAPE_SIZE := {
    radius = 6 / 2,
    height = 12 / 2,
}
const HUMAN_HURTBOX_SIZE := {
    radius = 7,
    height = 44,
}
const BAT_HURTBOX_SIZE := {
    radius = 6,
    height = 12,
}

@onready var sprite := $sprite as AnimatedSprite2D
@onready var player_anim := $player_anim as AnimationPlayer
@onready var _player_effects := $player_effects as AnimationPlayer
@onready var _shape := $shape as CollisionShape2D
@onready var _hurtbox := $hurtbox as HurtBox
@onready var _camera := $camera as Camera2D
@onready var _timer := $timers/damage_timer as Timer

@export var max_health: int = 50
@export var max_mana: float = 100.0

var current_health := max_health
var current_mana := max_mana
var mana_recovery_rate := 1.0
var invincible := false
var flip := false:
    set(value):
        flip = value
        sprite.flip_h = value
        $attack_hitboxes.scale.x = -1 if value else 1


func damage(value: int) -> void:
    if invincible or current_health <= 0:
        return

    if current_health > value:
        emit_signal("player_hurt")

    emit_signal("player_damaged", \
        current_health, max(0, current_health - value))
    current_health -= value

    if current_health <= 0:
        player_dies()
    else:
        _on_start_invicibility()


func player_dies() -> void:
    emit_signal("player_dead")


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


func play_anim(anim_name: String) -> void:
    print("PLAYER ANIM: %s" % anim_name)
    player_anim.play("player/" + anim_name)


func ensure_collision(form: PlayerForms) -> void:
    match (form):
        PlayerForms.HUMAN:
            _shape.shape.radius = HUMAN_SHAPE_SIZE.radius * 2
            _shape.shape.height = HUMAN_SHAPE_SIZE.height * 2
            _hurtbox.shape.shape.radius = HUMAN_HURTBOX_SIZE.radius
            _hurtbox.shape.shape.height = HUMAN_HURTBOX_SIZE.height
        PlayerForms.BAT:
            _shape.shape.radius = BAT_SHAPE_SIZE.radius * 2
            _shape.shape.height = BAT_SHAPE_SIZE.height * 2
            _hurtbox.shape.shape.radius = BAT_HURTBOX_SIZE.radius
            _hurtbox.shape.shape.height = BAT_HURTBOX_SIZE.height
        _:
            push_error("Unknown form: %s" % form)

    velocity.y += 1
    move_and_slide()


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

    _camera.current = true


func _on_start_invicibility() -> void:
    self.invincible = true
    await player_anim.animation_finished
    _timer.start(1)
    _player_effects.play("player_effects/damage_invincibility")


func _on_stop_invincibility() -> void:
    self.invincible = false
    _player_effects.seek(0)
    _player_effects.stop()


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
