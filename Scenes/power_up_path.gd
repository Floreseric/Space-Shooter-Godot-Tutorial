extends Node2D
var speed = 0
@export var points = 10

var slow_power_scene: PackedScene = load("res://Scenes/slow_power_up.tscn")
var rng := RandomNumberGenerator.new()
var curve := Curve2D.new()

@onready var max_bound = get_viewport().get_visible_rect().size

@onready var path := $Path2D/PathFollow2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_randomize_curve()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path.progress_ratio += delta * speed
	if path.progress_ratio == 1:
			_randomize_curve()
	

#pls don't touch future eric X_X
#receives path of node taht is meant to follow this path
func _set_follow_node(node_path):
	print(node_path)
	$Path2D/PathFollow2D/RemoteTransform2D.set_remote_node(node_path)
	await get_tree().create_timer(3).timeout
	
func _set_spawn_time(time):
	print("spawn time is",time)
	$Timer.wait_time = time
	$Timer.start()

func _randomize_curve():
	for i in points:
		var random_x = rng.randf_range(0,max_bound[0])
		var random_y = rng.randf_range(0,max_bound[1])
		curve.add_point(Vector2(random_x,random_y))
		if i > 0:
			var random_in = Vector2(rng.randf_range(0,max_bound[1]) * (-1 if randf()<0.5 else 1), rng.randf_range(0,max_bound[1]) * (-1 if randf()<0.5 else 1))
			curve.set_point_in(i, random_in)
		if i < points:
			var random_out = Vector2(rng.randf_range(0,max_bound[1]) * (-1 if randf()<0.5 else 1), rng.randf_range(0,max_bound[1]) * (-1 if randf()<0.5 else 1))
			curve.set_point_out(i, random_out)
	
	curve.set_point_position(points-1,curve.get_point_position(0))
	$Path2D.set_deferred("curve",curve)


func _on_timer_timeout() -> void:
	print("timer stopped")
	speed = 0.04
