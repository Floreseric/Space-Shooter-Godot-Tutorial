extends Control

var score = '0'
var screen_ready := false

@export var level_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_tree().call_group('ui', 'get_score', score )
	$MarginContainer/CenterContainer/VBoxContainer/Label2.text = $MarginContainer/CenterContainer/VBoxContainer/Label2.text + ' ' + str(Global.score)
	$SfxShieldDown.play() 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Shoot") and screen_ready:
		get_tree().change_scene_to_packed(level_scene)

func _on_timer_timeout() -> void:
	screen_ready = true
