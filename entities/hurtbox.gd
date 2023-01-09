extends Area2D
class_name HurtBox

@onready var shape := $shape as CollisionShape2D
@onready var _timer := $timer as Timer

var _last_hitbox: HitBox = null


func _init() -> void:
    self.collision_layer = 0b0
    self.collision_mask = 0b10000

    var timer := Timer.new()
    timer.name = "timer"
    timer.one_shot = false
    timer.wait_time = 1.0
    timer.timeout.connect(_take_damage, CONNECT_PERSIST)
    self.add_child(timer)


func _ready() -> void:
    self.area_entered.connect(_on_area_entered, CONNECT_PERSIST)
    self.area_exited.connect(_on_area_exited, CONNECT_PERSIST)


func _on_area_entered(hitbox: HitBox) -> void:
    if hitbox == null:
        return

    _last_hitbox = hitbox
    _take_damage()
    _timer.start()


func _on_area_exited(hitbox: HitBox) -> void:
    if hitbox == null:
        return

    _last_hitbox = null
    _timer.stop()


func _take_damage() -> void:
    if _last_hitbox == null:
        push_warning("No last hitbox")
        return

    if self.owner.has_method("damage"):
        self.owner.damage(_last_hitbox.damage)
    else:
        push_warning("owner %s can't be damaged" % self.owner.name)
