extends Area2D

signal collision
signal slow_time_up

@onready var slow_timer :=$SlowTimer
@onready var collision_shape := $CollisionShape2D
@onready var viewport_range = get_viewport().get_visible_rect().size
@onready var rng := RandomNumberGenerator.new()

@export var blink_time := 3
 

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#var random_x = rng.randi_range(30,viewport_range[0])
	#var random_y = rng.randi_range(30,viewport_range[1])
	


	#star position
	
	#position = Vector2(random_x,random_y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_body_entered(_body: Node2D) -> void:
	slow_timer.start()
	print("collided")
	print(collision_shape.is_disabled())
	_hide()
	collision.emit()


func _on_slow_timer_timeout() -> void:
	slow_time_up.emit()
	queue_free()

func _hide() -> void:
	collision_shape.set_deferred("disabled", true)
	$AnimatedSprite2D.set_deferred("visible", false)
	$SlowPowerUpSprite.set_deferred("visible", false)


#func _on_move_timeout() -> void:
	#
	#var random_x = rng.randi_range(30,viewport_range[0])
	#var random_y = rng.randi_range(30,viewport_range[1]) 
	#
	#var tween = get_tree().create_tween()
	#tween.tween_property($".",'position' ,Vector2(random_x,random_y), 5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	#print("MOVE!", random_x,random_y)


func _on_draw() -> void:
	$AnimatedSprite2D.play()
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(blink_time).timeout
	$AnimatedSprite2D.pause()
	$AnimatedSprite2D.set_frame_and_progress(0,0)
	$CollisionShape2D.set_deferred("disabled", false)
