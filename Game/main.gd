extends Node2D


@onready var main_camera = $UserInterface
@onready var player_camera = $Character/UserInterface
@onready var character = $Character



# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSettings.connect("_phase_changed", _on_phase_changed)
	GlobalSettings.connect("_victory", _on_victory)
	GlobalSettings._phase_changed.emit(GlobalSettings.phases.MAP)
	$Character/UserInterface/Congrats.visible = false
	#main_camera.activate()
	#player_camera.deactivate()
	main_camera.global_position = $Sockets/SocketField/Sockets/Socket1.global_position
	character.global_position = GlobalSettings.start_zone.global_position


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_phase_changed(which):
	if which == GlobalSettings.phases.ADVENTURE:
		player_camera.activate()
		main_camera.deactivate()
	elif which == GlobalSettings.phases.MAP:
		player_camera.deactivate()
		main_camera.activate()
		

func _on_victory():
	$Character/UserInterface/Congrats.visible = true
	await get_tree().create_timer(1).timeout
	SceneTransition.change_scene_to_file("res://Game/main.tscn")


