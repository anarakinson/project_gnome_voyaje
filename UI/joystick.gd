extends Node2D

signal _pressed
signal _released
@onready var joystick = $"."
@onready var knob = $knob

@export var max_length = 50
@export var dead_zone = 5

var posVector : Vector2
var is_pressed = false


func _ready():
	max_length = 50 * joystick.scale.x

func _process(delta):
	if is_pressed:
		if get_global_mouse_position().distance_to(joystick.global_position) <= max_length:
			knob.global_position = get_global_mouse_position()
		else:
			var angle = joystick.global_position.angle_to_point(get_global_mouse_position())
			knob.global_position.x = joystick.global_position.x + cos(angle) * max_length
			knob.global_position.y = joystick.global_position.y + sin(angle) * max_length
		calculate_vector()
	else:
		knob.global_position = lerp(knob.global_position, joystick.global_position, 50 * delta)
		joystick.posVector = Vector2(0, 0)
	#print(posVector)

func calculate_vector():
	if abs(knob.global_position.x - joystick.global_position.x) >= dead_zone:
		joystick.posVector.x = (knob.global_position.x - joystick.global_position.x) / max_length
	if abs(knob.global_position.y - joystick.global_position.y) >= dead_zone:
		joystick.posVector.y = (knob.global_position.y - joystick.global_position.y) / max_length


func _on_button_button_down():
	is_pressed = true
	_pressed.emit()

func _on_button_button_up():
	is_pressed = false
	_released.emit()

