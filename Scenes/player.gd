extends CharacterBody2D

@export var speed := 500
@export var invuln_timer := 2
var can_shoot:= true
@onready var healthbar := $"Hbox Container/ProgressBar"

signal laser(pos)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(100,500)
	Global.player_is_not_invuln = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed
	move_and_slide()
	
	
	#shoot input
	if Input.is_action_pressed("Shoot") and can_shoot:
		can_shoot = false
		laser.emit($LaserStartPos.global_position)
		$LaserStartPos/coolDownTimer.start()
		
		var LaserSound = [$LaserSound1,$LaserSound2]
		var rng := RandomNumberGenerator.new()
		var random_laser_sound = rng.randi_range(0,1)
		LaserSound[random_laser_sound].play()
	elif Input.is_action_just_pressed("Shoot"):
		pass
		
		
func on_damage_taken():
	get_tree().call_group("ui", "_reset_combo")
	$PlayerImage.visible = false
	$DamageSound.play()
	Global.player_is_not_invuln = false
	$AnimatedSprite2D.play("default")
	healthbar.value = Global.health
	await get_tree().create_timer(invuln_timer).timeout
	$AnimatedSprite2D.stop()
	$PlayerImage.visible = true
	Global.player_is_not_invuln = true
	
func set_max_health(amount):
	healthbar.max_value = amount
	healthbar.value = amount


func _on_cool_down_timer_timeout() -> void:
	can_shoot = true
