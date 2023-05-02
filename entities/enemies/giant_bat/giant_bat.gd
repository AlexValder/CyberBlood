extends BaseEnemy
class_name GiantBat

const SEE_DISTANCE := 100.0
const ORBIT_DISTANCE := 50.0
const WATCH_DISTANCE := 200.0
const FOLLOW_DISTANCE := 10.0
const FOLLOW_SPEED := 140.0
const ACCEL := 0.8
const THRESHOLD := 0.7


func _draw() -> void:
    draw_arc(Vector2.ZERO, SEE_DISTANCE, 0, TAU, 48, Color.YELLOW)
    draw_arc(Vector2.ZERO, WATCH_DISTANCE, 0, TAU, 48, Color.RED)
    draw_arc(Vector2.ZERO, ORBIT_DISTANCE, 0, TAU, 48, Color.DARK_BLUE)


func play_anim(anim_name: String, speed := 1.0) -> void:
    var player_anim := "giant_bat/" + anim_name
    if _sprite.sprite_frames.has_animation(anim_name):
        anim_player.pause()
        _sprite.play(anim_name, speed)
    elif anim_player.has_animation(player_anim):
        _sprite.pause()
        anim_player.play(player_anim, -1, speed)
