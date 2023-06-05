extends BaseEnemy
class_name GiantBat

const SEE_DISTANCE := 130.0
const ORBIT_DISTANCE := 50.0
const WATCH_DISTANCE := 250.0
const FOLLOW_DISTANCE := 10.0
const FOLLOW_SPEED := 150.0
const ACCEL := 0.8
const THRESHOLD := 0.7

@onready var _firepoint := $navigation/fire as Marker2D
@export var awake := false


func change_scale(flip_sprite: bool) -> void:
    $navigation.scale.x = -1 if flip_sprite else 1


func play_anim(anim_name: String, speed := 1.0) -> void:
    var player_anim := "giant_bat/" + anim_name
    if anim_player.has_animation(player_anim):
        _sprite.pause()
        anim_player.play(player_anim, -1, speed)
    elif _sprite.sprite_frames.has_animation(anim_name):
        anim_player.pause()
        _sprite.play(anim_name, speed)


func fire_fireball() -> void:
    var fireball := FireBall.spawn_fireball()
    fireball.direction_movement = Vector2.LEFT if flip else Vector2.RIGHT
    add_sibling(fireball)
    fireball.global_position = _firepoint.global_position
    fireball.make_enemy()
