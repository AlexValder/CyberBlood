extends CharacterBody2D
class_name Player

signal player_dead
signal player_damaged(old_value, new_value)

const GRAVITY := 320.0
const WALK_SPEED := 120.0
const FLY_SPEED := 200.0
const JUMP := 210.0
const ACCEL := 0.1

@onready var _sprite := $sprite as AnimatedSprite2D
@onready var _status := $GUI/HUD/status as Label
@onready var _timer := $damage_timer as Timer
@onready var _player_anim := $player_effects as AnimationPlayer

var max_health: int = 50
var current_health := max_health
var invincible := false


func damage(value: int) -> void:
    if invincible:
        return

    emit_signal("player_damaged", \
        current_health, max(0, current_health - value))

    current_health -= value
    if current_health <= 0:
        emit_signal("player_dead")

    _on_start_invicibility()


func play_anim(name: String, use_assert: bool = false) -> void:
    if use_assert:
        assert(_sprite.frames.has_animation(name), \
            "animation not found: %s" % name)

    _sprite.play(name)


func ensure_collision(form: String) -> void:
    match (form):
        "human":
            $shape_human.set_deferred("disabled", false)
            $shape_bat.set_deferred("disabled", true)
        "bat":
            $shape_human.set_deferred("disabled", true)
            $shape_bat.set_deferred("disabled", false)
        _:
            push_error("Unknown form: %s" % form)


func update_status(status: String) -> void:
    _status.text = status


func _ready() -> void:
    _timer.timeout.connect(_on_stop_invincibility, Object.CONNECT_PERSIST)
    self.player_dead.connect(GameManager.reload_level, Object.CONNECT_ONE_SHOT)

    var bar := $"%health_bar" as HealthBar
    bar.set_max_value(max_health)
    bar.set_current_value(current_health)


func _on_start_invicibility() -> void:
    self.invincible = true
    _timer.start(1)
    _player_anim.play("damage_invincibility")


func _on_stop_invincibility() -> void:
    self.invincible = false
    _player_anim.seek(0)
    _player_anim.stop()


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey:
        var e := event as InputEventKey
        if e.keycode == KEY_Q && e.is_pressed():
            damage(5)
