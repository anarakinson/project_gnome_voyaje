extends Camera2D


@export var camera_name = "main"
@onready var change_phase_button = $UI/ChangePhaseButton
@onready var restart_button = $UI/RestartButton
@onready var camera_ui = $UI
@onready var joystick = $UI/Joystick


var speed = 300
var direction = Vector2()
var start_position : Vector2
var is_moving = false
var is_joystic_active = false
var map_mode = true


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSettings.connect("_phase_changed", _on_phase_changed)
	_on_change_phase_button_pressed()
	start_position = global_position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_moving and map_mode:
		global_position += direction * speed * delta
		GlobalSettings._new_picked_down.emit()
	if is_joystic_active:
		var jdirection = joystick.posVector
		global_position += jdirection * speed * delta
		GlobalSettings._new_picked_down.emit()
	
	#print(camera_name, " ", visible)
	#print(camera_name, " ", is_joystic_active)
	#print(global_position)

func _on_change_phase_button_pressed():
	if GlobalSettings.current_phase == GlobalSettings.phases.MAP:
		GlobalSettings._phase_changed.emit(GlobalSettings.phases.ADVENTURE)
	elif GlobalSettings.current_phase == GlobalSettings.phases.ADVENTURE:
		GlobalSettings._phase_changed.emit(GlobalSettings.phases.MAP)
	

func activate():
	enabled = true
	camera_ui.visible = true


func deactivate():
	enabled = false
	camera_ui.visible = false


func _on_restart_button_pressed():
	SceneTransition.change_scene_to_file("res://Game/main.tscn")


func _input(event):
	direction = Input.get_vector("left", "right", "up", "down")
	if direction.x == 0 and direction.y == 0:
		is_moving = false
	else:
		is_moving = true

func _on_joystick__pressed():
	is_joystic_active = true

func _on_joystick__released():
	is_joystic_active = false


func _on_phase_changed(phase):
	if phase == GlobalSettings.phases.MAP:
		map_mode = true
		joystick.visible = true
	if phase == GlobalSettings.phases.ADVENTURE:
		map_mode = false
		position = Vector2()
		joystick.visible = false





#var mouse_start_pos
#var screen_start_position
#
#var dragging = false


#func _input(event):
	#if event.is_action("tap"):
		#if event.is_pressed():
			#mouse_start_pos = event.position
			#screen_start_position = position
			#dragging = true
		#else:
			#dragging = false
	#if event is InputEventMouseMotion and dragging:
		#position = zoom * (mouse_start_pos - event.position) + screen_start_position
#
#
#func _on_button_3_button_down():
	#mouse_start_pos = $UI/Button3.global_position
	#screen_start_position = position
	#dragging = true
#
#func _on_button_3_button_up():
	#dragging = false

