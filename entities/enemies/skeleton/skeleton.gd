extends CharacterBody2D
class_name BaseEnemy

signal enemy_died
signal enemy_hurt
signal enemy_damaged(old_value, new_value)

@export var enemy_name := "enemy"
@export var max_health := 20
## Chance of spawning random pickup upon death
@export_range(0, 100, 0.1) var spawn_pickup_chance := 10

@onready var sprite := $sprite as AnimatedSprite2D
@onready var _health_bar := $vbox/health as ValueBar
@onready var _player := GameManager.player
@onready var current_health := max_health

var GRAVITY := 240.0


func damage(value: int) -> void:
    if current_health <= 0:
        return

    if current_health > value:
        emit_signal("enemy_hurt")

    emit_signal("enemy_damaged", \
        current_health, max(0, current_health - value))
    current_health -= value

    if current_health <= 0:
        die()


func play_anim(anim_name: String) -> void:
    if sprite.frames.has_animation(anim_name):
        sprite.play(anim_name)


func die() -> void:
    _try_spawn_pickup()

    emit_signal("enemy_died")
    $hitbox/shape.queue_free()
    await sprite.animation_finished
    await get_tree().create_timer(1).timeout
    queue_free()


func _ready() -> void:
    _health_bar.max_value = max_health
    _health_bar.value = current_health

    $vbox/name.text = enemy_name


func _try_spawn_pickup() -> void:
    var chance = randi_range(0, 99)
    print("chance=%d, quota=%d" % [chance, spawn_pickup_chance])
    if chance <= spawn_pickup_chance:
        var pickup := FoodPickup.get_pickup()
        pickup.global_position = self.global_position
        call_deferred("add_sibling", pickup)
