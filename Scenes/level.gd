extends Node2D

# 1. Load the scene
var meteor_scene: PackedScene = load("res://Scenes/meteor.tscn")
var laser_scene: PackedScene = load("res://Scenes/laser.tscn")
var slow_power_scene: PackedScene = load("res://Scenes/slow_power_up.tscn")
var power_up_path_scene: PackedScene = load("res://Scenes/power_up_path.tscn")

var slow_speed := 0.4
var slow_active := false

var speed : int
var rotSpeed : float
var direction := Vector2(0,0)
var rng := RandomNumberGenerator.new()

var random_spawn_time := randi_range(1,5)

#@onready var slow_timer := $SlowPowerUp/SlowTimer

func _on_meteor_timer_timeout() -> void:
	# 2. create an instance
	var meteor = meteor_scene.instantiate()
	
	#3. attach the node to the scene tree
	$Meteors.add_child(meteor)
	#connect the signal
	meteor.connect('collision', _on_meteor_collision)
	

func _on_meteor_collision():
	if Global.player_is_not_invuln:
		Global.health -= 1
		get_tree().call_group("ui", 'set_health', Global.health)
		get_tree().call_group("player", "on_damage_taken")
		if Global.health <= 0:
			get_tree().call_deferred('change_scene_to_file', 'res://Scenes/game_over_screen.tscn')
	
func _on_player_laser(pos) -> void:
	var laser = laser_scene.instantiate()
	$Lasers.add_child(laser)
	laser.position = pos

func _ready() -> void:
	

	Global.health = 3
	get_tree().call_group("player", 'set_max_health', Global.health)
	get_tree().call_group("ui", 'set_health', Global.health)
	
	
	var size := get_viewport().get_visible_rect().size
	
	#powerup spawn
	
	#star randomizer
	for this_star in $Stars.get_children():
		
		#position
		var random_x = rng.randf_range(size.x*0.1,size.x*0.9)
		var random_y = rng.randf_range(size.y*0.1,size.y*0.9)
		this_star.position = Vector2(random_x,random_y)
		
		#scale
		var random_scale = rng.randf_range(0.1,1.4)
		this_star.scale = Vector2(random_scale,random_scale)

		#speed
		var random_speed = rng.randf_range(0.1,1.2)		
		this_star.speed_scale = random_speed

func _slow_power():
	$MeteorTimer.set_paused(true)
	for meteor in $Meteors.get_children():
		meteor.speed *= slow_speed
		
func _meteor_spawn():
	$MeteorTimer.set_paused(false)


func _on_power_up_spawn_timer_timeout() -> void:
	$SlowPowerUp.set_deferred("visible", false)
	var slow_powerup = slow_power_scene.instantiate()
	random_spawn_time = rng.randi_range(1,5)
	
	slow_powerup.connect('collision', _slow_power)
	slow_powerup.connect('slow_time_up', _meteor_spawn)

	$PowerUpSpawnTimer.set_deferred("wait_time", random_spawn_time)
	$SlowPowerUp.add_child(slow_powerup)
	_create_path(slow_powerup)
	
	
	


func _on_slow_power_up_child_exiting_tree(_node: Node) -> void:
	$PowerUpSpawnTimer.start()

func _create_path(node):
	var node_path = node.get_path()
	var spawn_time = node.get("blink_time")
	print(spawn_time)
	var power_up_path = power_up_path_scene.instantiate()
	
	$SlowPowerUp.add_child(power_up_path)
	power_up_path._set_follow_node(node_path)
	power_up_path._set_spawn_time(spawn_time)
	$SlowPowerUp.set_deferred("visible", true)
