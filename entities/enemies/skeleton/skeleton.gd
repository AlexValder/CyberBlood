extends BaseEnemy
class_name Skeleton


func change_scale(flip_sprite: bool) -> void:
    $navigation.scale.x = -1 if flip_sprite else 1
    $attack_hitboxes.scale.x = -1 if flip_sprite else 1


func play_anim(anim_name: String, speed := 1.0) -> void:
    anim_player.play("skeleton/" + anim_name, -1, speed)
