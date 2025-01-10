extends Control

@export var load_scene : PackedScene
@export var in_time : float = 0.5
@export var fade_in_time : float = 1.5
@export var pause_time : float = 1.5
@export var fade_out_time : float = 1.5
@export var out_time : float = 0.5
@export var splash_sceen_container : Node

var splash_screens : Array
var current_tween : Tween

func _ready() -> void:
	get_screens()
	fade()

func fade() -> void:
	for screen in splash_screens:
		current_tween = create_tween()
		current_tween.tween_interval(in_time)
		current_tween.tween_property(screen, "modulate:a", 1.0, fade_in_time)
		current_tween.tween_interval(pause_time)
		current_tween.tween_property(screen, "modulate:a", 0.0, fade_out_time)
		current_tween.tween_interval(out_time)
		await current_tween.finished
	
	# Only change scene if we completed normally (not interrupted)
	if !current_tween.is_valid():
		return
	Global.game_controller.change_gui_scene("res://scenes/ui/main_menu.tscn")

func get_screens() -> void:
	splash_screens = splash_sceen_container.get_children()
	for screen in splash_screens:
		screen.modulate.a = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():
		if current_tween and current_tween.is_valid():
			current_tween.kill()
		
		for screen in splash_screens:
			screen.modulate.a = 0.0
		SoundManager.play_sfx_sound("skip_1")
		Global.game_controller.change_gui_scene("res://scenes/ui/main_menu.tscn")
