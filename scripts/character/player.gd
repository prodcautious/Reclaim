extends CharacterBody2D

enum PlayerState { 
	NORMAL,
	IN_DIALOGUE,
	HEALING,
	HURT
}

var current_state = PlayerState.NORMAL
var last_direction = Vector2.DOWN

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	play_idle_animation()

func _process(delta):
	match current_state:
		PlayerState.NORMAL:
			handle_movement()
		PlayerState.IN_DIALOGUE:
			velocity = Vector2.ZERO
			move_and_slide()
			play_idle_animation()

func handle_movement():
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	
	direction = direction.normalized()
	velocity = direction * 100  # Fixed movement speed of 100
	move_and_slide()
	
	if direction != Vector2.ZERO:
		last_direction = direction
		handle_walking_animations(direction)
	else:
		play_idle_animation()

func handle_walking_animations(direction: Vector2):
	if abs(direction.x) > abs(direction.y):
		animation_player.play("walk_Right" if direction.x > 0 else "walk_Left")
	else:
		animation_player.play("walk_Down" if direction.y > 0 else "walk_Up")

func play_idle_animation():
	if abs(last_direction.x) > abs(last_direction.y):
		animation_player.play("idle_Right" if last_direction.x > 0 else "idle_Left")
	else:
		animation_player.play("idle_Down" if last_direction.y > 0 else "idle_Up")
