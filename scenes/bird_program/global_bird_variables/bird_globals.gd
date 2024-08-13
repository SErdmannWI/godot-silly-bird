extends Node


# Info Keys
const BIRD_AGE_KEY: String = "Bird Age"
const BIRD_IMAGE_KEY: String = "Bird Image"
const BIRD_NAME_KEY: String = "Bird Name"
const BIRD_LEVEL_KEY: String = "Bird Level"
const BIRD_FOOD_TYPE_KEY: String = "Bird Food Type"
const BIRD_STATUS_KEY: String = "Bird Status"
const BIRD_MOOD_KEY: String = "Bird Mood"
const BIRD_DAILY_EXPERIENCE_KEY: String = "Daily Exeperience"
const BIRD_TOTAL_EXPERIENCE_KEY: String = "Total Exerpience"


# Bird Types
const BIRD_TYPE_MOURNING_DOVE = "Mourning Dove"
const BIRD_TYPE_CARDINAL = "Cardinal"


# Mood Strings
const MOOD_HAPPY: String = "Happy"
const MOOD_ANGRY: String = "Angry"
const MOOD_HUNGRY: String = "Hungry"
const MOOD_FULFILLED: String = "Fulfilled"
const MOOD_LONELY: String = "Lonely"
const MOOD_RAVENOUS: String = "Ravenous"
const MOOD_ANNOYED: String = "Annoyed"
const MOOD_SLEEPY: String = "Sleepy"
const MOOD_BORED: String = "Bored"


# Behaviors
const BEHAVIOR_PLAYFUL: BirdBehavior = preload("res://scenes/bird_program/global_bird_variables/behaviors/playful.tres")
const BEHAVIOR_SOLITARY: BirdBehavior = preload("res://scenes/bird_program/global_bird_variables/behaviors/solitary.tres")
const BEHAVIOR_AGGRESSIVE: BirdBehavior = preload("res://scenes/bird_program/global_bird_variables/behaviors/aggressive.tres")
const BEHAVIOR_RAVENOUS: BirdBehavior = preload("res://scenes/bird_program/global_bird_variables/behaviors/ravenous.tres")


# Food Types
const FOOD_TYPE_SEEDS: FoodType = preload("res://scenes/bird_program/global_bird_variables/food_types/seeds.tres")
const FOOD_TYPE_INSECTS: FoodType = preload("res://scenes/bird_program/global_bird_variables/food_types/insects.tres")
const FOOD_TYPE_FRUITS: FoodType = preload("res://scenes/bird_program/global_bird_variables/food_types/fruits.tres")
const FOOD_TYPE_NECTAR: FoodType = preload("res://scenes/bird_program/global_bird_variables/food_types/nectar.tres")
const FOOD_TYPE_FISH: FoodType = preload("res://scenes/bird_program/global_bird_variables/food_types/fish.tres")


# Timer wait times
const HUNGER_TIME: int = 2
const ENERGY_TIME: int = 5
const SOCIAL_TIME: int = 3


# Behavior-specific times
const RAVENOUS_HUNGER_TIME: int = 1
const PLAYFUL_ENERGY_TIME: int = 4
const SOLITARY_SOCIAL_TIME: int = 5


# Bird status
const STATUS_AWAKE: String = "Awake"
const STATUS_SLEEPING: String = "Sleeping"
