extends CharacterBody2D
class_name BaseEnemy

signal enemy_died
signal enemy_hurt
signal enemy_damaged(old_value, new_value)

@export var enemy_name := "enemy"
@export var max_health := 20
## Chance of spawning random pickup upon death
@export_range(0, 100, 0.1) var spawn_food_chance := 10
@export_range(0, 100, 0.1) var spawn_money_chance := 90
@export var cost := 5

@onready var anim_player := $anim_player as AnimationPlayer
@onready var current_health := max_health
@onready var _sprite := $sprite as AnimatedSprite2D
@onready var _health_bar := $vbox/health as ValueBar
@onready var eyes := $navigation/eyes as Marker2D
@onready var flip := false:
    set(value):
        if value == flip:
            return
        flip = value
        _sprite.flip_h = value
        change_scale(value)


func change_scale(_flip: bool) -> void:
    pass


func damage(value: int) -> void:
    if current_health <= 0:
        return

    if current_health > value:
        enemy_hurt.emit()

    enemy_damaged.emit(current_health, max(0, current_health - value))
    current_health -= value

    if current_health <= 0:
        die()


func play_anim(_anim_name: String, _speed := 1.0) -> void:
    pass


func die() -> void:
    _try_spawn_pickup()

    enemy_died.emit()
    await anim_player.animation_finished
    anim_player.pause()
    await get_tree().create_timer(1).timeout
    queue_free()


func _ready() -> void:
    _health_bar.max_value = max_health
    _health_bar.value = current_health

    $vbox/name.text = enemy_name


func _try_spawn_pickup() -> void:
    var chance = randi_range(0, 99)
    if chance <= min(spawn_food_chance, spawn_money_chance):
        var pickup := FoodPickup.get_pickup()
        pickup.global_position = self.global_position
        call_deferred("add_sibling", pickup)
    elif chance <= max(spawn_food_chance, spawn_money_chance):
        var pickups := MoneyPickup.get_pickup(cost)
        for pickup in pickups:
            pickup.global_position = self.global_position
            call_deferred("add_sibling", pickup)
