extends CharacterBody2D

@onready var anim = $AnimatedSprite2D


@export var speed = 100
var current_direction = "none"

var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var health = 100
var is_player_alive = true
var is_attack_in_progress = false

func _ready():
	anim.play("side_idle")

	

func _physics_process(delta):
	
	player_movement(delta)
	enemy_attack()
	update_health()
	attack()
	
	if health <= 0:
		is_player_alive = false
		health = 0
	
	
func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_direction = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_direction = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_direction = "down"
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_direction = "up"
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()
	
func play_anim(movement):
	var dir = current_direction
	
	if dir == "right":
		anim.flip_h = false
		if is_attack_in_progress != true:
			if movement == 1:
				anim.play("side_walk")
			
			elif movement == 0:
				anim.play("side_idle")
				
			
	if dir == "left":
		anim.flip_h = true
		if is_attack_in_progress != true:
			if movement == 1:
				anim.play("side_walk")
			elif movement == 0:
				anim.play("side_idle")
			
	if dir == "up":
		if is_attack_in_progress != true:
			if movement == 1:
				anim.play("back_walk")
			elif movement == 0:
				anim.play("back_idle")
	
	if dir == "down":
		if is_attack_in_progress != true:
			if movement == 1:
				anim.play("front_walk")
			elif movement == 0:
				anim.play("front_idle")


func _on_player_hitbox_body_entered(body):
	if body.name == "Enemy":
		enemy_in_attack_range = true


func _on_player_hitbox_body_exited(body):
	if body.name == "Enemy":
		enemy_in_attack_range = false
		
func enemy_attack():
	if enemy_in_attack_range == true and enemy_attack_cooldown == true:
		health -= 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		$regen_timer.start()
		print(health)



func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
	
func attack():
	var dir = current_direction
	
	if Input.is_action_just_pressed("attack"):
		Global.player_current_attack = true
		is_attack_in_progress = true
		if dir == "right":
			anim.flip_h = false
			anim.play("side_attack")
			$attack_timer.start()
		if dir == "left":
			anim.flip_h = true
			anim.play("side_attack")
			$attack_timer.start()
		if dir == "down":
			anim.play("front_attack")
			$attack_timer.start()
		if dir == "up":
			anim.play("back_attack")
			$attack_timer.start()


func _on_attack_timer_timeout():
	$attack_timer.stop()
	Global.player_current_attack = false
	is_attack_in_progress = false


func update_health():
	var health_bar = $health_bar
	health_bar.value = health
	
	if health >= 100:
		health_bar.visible = false
	else:
		health_bar.visible = true


func _on_regen_timer_timeout():
	if health < 100:
		health = health + 20
	if health > 100:
		health = 100
	
	
	
	
	
	
	
	
	
	
	
	
