extends Camera2D


@export var camera_name = "main"
@onready var change_phase_button = $UI/ChangePhaseButton
@onready var restart_button = $UI/RestartButton


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_change_phase_button_pressed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_change_phase_button_pressed():
	if GlobalSettings.current_phase == GlobalSettings.phases.MAP:
		GlobalSettings._phase_changed.emit(GlobalSettings.phases.ADVENTURE)
	elif GlobalSettings.current_phase == GlobalSettings.phases.ADVENTURE:
		GlobalSettings._phase_changed.emit(GlobalSettings.phases.MAP)
	

func activate():
	enabled = true


func deactivate():
	enabled = false


func _on_restart_button_pressed():
	SceneTransition.change_scene_to_file("res://Game/main.tscn")
