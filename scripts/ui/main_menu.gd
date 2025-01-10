extends Control

@onready var play_button : Button = $CenterContainer/VBoxContainer/Play
var debug_platform_override: String = "" #"console" for testing console play.

func _ready():
	set_focus_mode_by_platform()

#Play Button Handling
func _on_play_pressed() -> void:
	SoundManager.play_sfx_sound("click_1")
	Global.game_controller.change_gui_scene("res://scenes/towns/town_1.tscn", false, true)

func _on_play_focus_entered() -> void:
	SoundManager.play_sfx_sound("focus_1")

func _on_play_mouse_entered() -> void:
	SoundManager.play_sfx_sound("focus_1")

#Options Button Handling
func _on_options_pressed() -> void:
	SoundManager.play_sfx_sound("click_1")

func _on_options_focus_entered() -> void:
	SoundManager.play_sfx_sound("focus_1")

func _on_options_mouse_entered() -> void:
	SoundManager.play_sfx_sound("focus_1")


#Quit Button Handling
func _on_quit_pressed() -> void:
	SoundManager.play_sfx_sound("click_1")
	get_tree().quit()

func _on_quit_focus_entered() -> void:
	SoundManager.play_sfx_sound("focus_1")

func _on_quit_mouse_entered() -> void:
	SoundManager.play_sfx_sound("focus_1")

func set_focus_mode_by_platform() -> void:
	# Determine effective platform feature
	var is_console: bool = debug_platform_override == "console" or OS.has_feature("console")
	
	# Log debug information
	print("Current platform: ", OS.get_name())
	print("Debug platform override: ", debug_platform_override)
	print("Is console detected: ", is_console)
	
	# Apply focus mode logic based on platform
	if is_console:
		print("Feature 'console' detected (or simulated). Grabbing focus for play button.")
		play_button.call_deferred("grab_focus")
	else:
		print("Feature 'console' not detected (or simulated). No focus adjustment needed.")
