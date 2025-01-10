extends Button

func _ready() -> void:
	set_focus_mode_by_platform()

func set_focus_mode_by_platform() -> void:
	if OS.has_feature("console"):
		focus_mode = FOCUS_ALL
	else:
		focus_mode = FOCUS_NONE
