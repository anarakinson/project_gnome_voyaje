extends Camera2D


@export var camera_name = "main"
@onready var change_phase_button = $Control/ChangePhaseButton
@onready var change_phase_button_small = $Control/ChangePhaseButtonSmall
@onready var restart_button = $Control/RestartButton
@onready var restart_button_small = $Control/RestartButtonSmall


# Called when the node enters the scene tree for the first time.
func _ready():
	change_phase_button.visible = false
	_on_change_phase_button_pressed()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_change_phase_button_pressed():
	if GlobalSettings.current_phase == GlobalSettings.phases.MAP:
		GlobalSettings._phase_changed.emit(GlobalSettings.phases.ADVENTURE)
	elif GlobalSettings.current_phase == GlobalSettings.phases.ADVENTURE:
		GlobalSettings._phase_changed.emit(GlobalSettings.phases.MAP)
	

func activate():
	change_phase_button.visible = true 
	enabled = true
	
	if camera_name == "player":
		change_phase_button_small.visible = true
		change_phase_button.visible = false
		restart_button_small.visible = true
		restart_button.visible = false
	elif camera_name == "main":
		change_phase_button_small.visible = false
		change_phase_button.visible = true
		restart_button_small.visible = false
		restart_button.visible = true



func deactivate():
	enabled = false
	
	change_phase_button.visible = false
	change_phase_button_small.visible = false
	restart_button.visible = false
	restart_button_small.visible = false


func _on_change_phase_button_small_pressed():
	_on_change_phase_button_pressed()


func _on_restart_button_small_pressed():
	_on_restart_button_pressed()

func _on_restart_button_pressed():
	SceneTransition.change_scene_to_file("res://Game/main.tscn")
