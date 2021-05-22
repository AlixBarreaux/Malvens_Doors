class_name Player
extends KinematicBody2D


# Class containing all the player's information.
# Player controller is directly put there, might need decoupling.

############################### DECLARE VARIABLES ##############################

export var current_speed: int = 150 setget set_current_speed, get_current_speed
export var normal_speed: int = 150
export var max_speed = 300

export var current_health: int = 0
export var max_health: int = 0

export var current_melee_attack_damage: int = 1
export var max_melee_attack_damage: int = 2

enum ABILITIES {
					NONE = 0,
					BANDANA,
					TORSO,
					TURBAN
				}

export (ABILITIES) var current_ability = ABILITIES.BANDANA


var direction: Vector2 = Vector2(0.0, 0.0) setget set_direction, get_direction
var velocity: Vector2 = Vector2(0.0, 0.0) setget set_velocity

var can_move: bool = false
var can_melee_attack = true

################################# RUN THE CODE #################################

func _ready() -> void:
	self._initialize_asserts()


func _physics_process(_delta: float) -> void:
	self.calculate_velocity()
	velocity = move_and_slide(velocity)


func _unhandled_input(_event: InputEvent) -> void:
	self.set_direction(Vector2(0.0, 0.0))
	
	if Input.get_action_strength("move_left"):
		self.direction.x = -1
		
	if Input.get_action_strength("move_right"):
		self.direction.x = 1
	
	if Input.get_action_strength("move_up"):
		self.direction.y = -1
	
	if Input.get_action_strength("move_down"):
		self.direction.y = 1
	

	
#	if Input.is_action_just_pressed("ability_one"):
#		current_
#
#	if Input.is_action_just_pressed("ability_two"):
#
#
#	if Input.is_action_just_pressed("ability_three"):
		
	
	if Input.is_action_just_pressed("interact"):
		if targeted_interactable != null:
			targeted_interactable.receive_interaction()
			targeted_interactable = null
	
	
	self.direction = self.direction.normalized()
	

func set_current_ability() -> void:
	match current_ability:
		ABILITIES.NONE:
			pass
			
		ABILITIES.BANDANA:
			self.set_current_speed(max_speed)
			self.set_current_damage(max_melee_attack_damage)
			
		ABILITIES.TORSO:
			pass
			
		ABILITIES.TURBAN:
			pass

############################### DECLARE FUNCTIONS ##############################

func _initialize_asserts() -> void:
	# Must be more than 0!
	assert(self.current_health > 0)
	assert(self.max_health > 0)
	# Current Health mus be less or equal to max health!
	assert(self.current_health <= self.max_health)


func set_direction(new_direction: Vector2) -> void:
	direction = new_direction


func get_direction() -> Vector2:
	return direction


func set_velocity(new_velocity: Vector2) -> void:
	velocity = new_velocity


func set_current_speed(new_speed: int) -> void:
	current_speed = new_speed


func get_current_speed() -> int:
	return current_speed


func calculate_velocity() -> void:
	self.velocity = self.direction * self.current_speed


func melee_attack_animation_finished() -> void:
	can_melee_attack = true





func take_damage(amount: int) -> void:
	self.current_health -= amount
	print(self.name + ": I took " + str(amount) + " damage!")
	
	self.check_if_dead()
	
	

func check_if_dead() -> void:
	if self.current_health <= 0:
			self.current_health = 0
			self.die()
	print(self.name + ": Health status: " + str(current_health) + " / " + str(max_health))


func die() -> void:
	print(self.name + str(": I died!"))


func _on_HurtBox_body_entered(body: PhysicsBody2D) -> void:
	print(self.name, ": I was entered by: ", body.name)
	body.take_damage(self.get_current_damage())
	


func set_current_damage(amount: int) -> void:
	current_melee_attack_damage = amount


func get_current_damage() -> int:
	return current_melee_attack_damage


var targeted_interactable: PhysicsBody2D = null

func _on_InteractZone_body_entered(body: PhysicsBody2D) -> void:
	self.targeted_interactable = body
	print(self.name + ": Interact target set to: " + body.name)
