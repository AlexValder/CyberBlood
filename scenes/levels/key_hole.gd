extends Interactable
class_name KeyHole

@export var key_id: String
var _label_settings := LabelSettings.new()
var _label_shown := false
var _disabled := false


func _init() -> void:
    _label_settings.font_size = 16
    _label_settings.font_color = Color.GOLD
    _label_settings.outline_color = Color.BLACK
    _label_settings.outline_size = 2


func interact() -> void:
    if _disabled:
        return

    if !GameManager.player.has_item_in_inv(key_id):
        show_notification()
        return

    interacted.emit()
    _disabled = true


func disable(_emit: bool) -> void:
    _disabled = true


func show_notification() -> void:
    if _label_shown:
        return
    _label_shown = true

    var label := Label.new()
    label.z_index = 10
    label.text = "Key required"
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    label.label_settings = _label_settings
    add_child(label)
    label.anchors_preset = Control.LayoutPreset.PRESET_CENTER_TOP
    label.position.y -= 50
    get_tree().create_timer(1.5).timeout.connect(hide_label.bind(label))


func hide_label(label: Label) -> void:
    var tween := create_tween()
    tween.set_parallel(true)
    tween.tween_property(label, "position:y", label.position.y - 30, 0.5)
    tween.tween_property(label, "modulate:a", 0.0, 0.5)
    tween.tween_callback(label.queue_free).set_delay(1.0)
    _label_shown = false
