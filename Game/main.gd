extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSettings.connect("_lock_screen", _on_lock_screen)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_lock_screen(state):
	if state == "lock":
		$ScreenLocker.visible = true
	elif state == "unlock":
		$ScreenLocker.visible = false
