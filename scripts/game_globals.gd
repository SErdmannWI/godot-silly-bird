extends Node

# Group interactions
const GROUP_NAME_MANAGERS: String = "Managers"

const GROUP_METHOD_START_DAY: String = "start_new_day"
const GROUP_METHOD_END_DAY: String = "end_day"

# Code Enums
# Used to communicate from Director to UI on what to do with info
enum ResponseCode {NO_NEST = -1, NEST_FULL = -2}

enum StatusCode{EGG_HATCHED = 1, EGG_BROKEN = 2}

enum XpCodes{NEST_BUILT = 1, DISCOVERY_MADE = 2, EGG_HATCHED = 3}

# Day/ Night Cycle

enum DayNightCycle {NIGHT = 0, MORNING = 1, DAY = 2, EVENING = 3}
enum Weather {SUNNY = 0, CLOUDY = 1, RAINING = 2, STORM = 3}

const TIME_TEXT_MORNING: String = "Morning"
const TIME_TEXT_DAY: String = "Day"
const TIME_TEXT_EVENING: String = "Evening"
const TIME_TEXT_NIGHT: String = "Night"

const WEATHER_SUNNY: String = "Sunny"
const WEATHER_CLOUDY: String = "Cloudy"
const WEATHER_RAINING: String = "Raining"
const WEATHER_STORM: String = "Storm"

const TIME_CYCLE_INCREMENT: int = 1

# Leveling variables
# Level Thresholds
const XP_VALUES_LEVEL_0_XP_NEEDED: int = 0
const XP_VALUES_LEVEL_1_XP_NEEDED: int = 10
const XP_VALUES_LEVEL_2_XP_NEEDED: int = 20
const XP_VALUES_LEVEL_3_XP_NEEDED: int = 30
const XP_VALUES_LEVEL_4_XP_NEEDED: int = 40
const XP_VALUES_LEVEL_5_XP_NEEDED: int = 50
const XP_VALUES_LEVEL_6_XP_NEEDED: int = 60
const XP_VALUES_LEVEL_7_XP_NEEDED: int = 70
const XP_VALUES_LEVEL_8_XP_NEEDED: int = 80
const XP_VALUES_LEVEL_9_XP_NEEDED: int = 90
const XP_VALUES_LEVEL_10_XP_NEEDED: int = 100

# Key- desired level : Value- amount needed to attain desired level
const XP_LEVELING_THRESHOLDS: Dictionary = {
	0 : XP_VALUES_LEVEL_0_XP_NEEDED,
	1 : XP_VALUES_LEVEL_1_XP_NEEDED,
	2 : XP_VALUES_LEVEL_2_XP_NEEDED,
	3 : XP_VALUES_LEVEL_3_XP_NEEDED,
	4 : XP_VALUES_LEVEL_4_XP_NEEDED,
	5 : XP_VALUES_LEVEL_5_XP_NEEDED,
	6 : XP_VALUES_LEVEL_6_XP_NEEDED,
	7 : XP_VALUES_LEVEL_7_XP_NEEDED,
	8 : XP_VALUES_LEVEL_8_XP_NEEDED,
	9 : XP_VALUES_LEVEL_9_XP_NEEDED,
	10 : XP_VALUES_LEVEL_10_XP_NEEDED
}

# XP Amount gained
const XP_VALUES_NEST_BUILT: int = 10
const XP_VALUES_DISCOVERY_MADE: int = 5
const XP_VALUES_EGG_HATCHED: int = 8

const XP_AMOUNT_GAINED: Dictionary = {
	XpCodes.NEST_BUILT : XP_VALUES_NEST_BUILT,
	XpCodes.EGG_HATCHED : XP_VALUES_EGG_HATCHED,
	XpCodes.DISCOVERY_MADE : XP_VALUES_DISCOVERY_MADE
}

