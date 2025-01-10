class_name SceneTransitionController extends Control

@export var background : ColorRect
@export var animation_player : AnimationPlayer

func transition(animation: String, seconds: float) -> void:
	self.show()
	animation_player.play(animation, -1.0, 1 / seconds)
	await animation_player.animation_finished
	self.hide()
