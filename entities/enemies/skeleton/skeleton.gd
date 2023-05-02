extends BaseEnemy
class_name Skeleton

const GRAVITY := 240.0
const WALK_SPEED := 70.0
const CHASE_SPEED := 100.0
const SEES_PLAYER_AT := 200.0
const KEEPS_SEEING := 400.0
const ATTACK_DISTANCE := 70.0
const ACCEL := 5.0


func change_scale(flip_sprite: bool) -> void:
    $navigation.scale.x = -1 if flip_sprite else 1
    $attack_hitboxes.scale.x = -1 if flip_sprite else 1


func play_anim(anim_name: String, speed := 1.0) -> void:
    anim_player.play("skeleton/" + anim_name, -1, speed)
