extends Node
#For managing the internal clock, the day-night cycle and the calendar

@export var game_manager : Node

@export var weekday := "Monday"
@export var numday := 1
var weekday_array = [
	"Monday",
	"Tuesday",
	"Wednesday",
	"Thursday",
	"Friday",
	"Saturday",
	"Sunday" ]
#how many days are we playing?
@export var daylimit := 7

@export var hour = 18
@export var minute = 00

#to determine when a day starts and ends
@export var hour_start = 18
@export var hour_end = 6

#how many clock minutes pass per tick, so the night fits the candle
@export var minutes_per_tick := 10
#how many clock minutes of grace after sunrise before the heat wins
@export var grace_minutes := 60
#from this hour the hud starts nagging the rancher to go home
@export var warn_hour := 5

#true once the sun is up and the rancher is on borrowed time
var overtime := false
var grace_left := 0.0

func _ready():
	grace_left = grace_minutes

#we need a signal to tell the game that time is indeed passing
signal min_signal
func min_ahead():
	minute += minutes_per_tick
	while minute >= 60:
		minute -= 60
		hour_ahead()
	if overtime:
		grace_left -= minutes_per_tick
		if grace_left <= 0:
			game_manager.game_over()
			return
	min_signal.emit()

func hour_ahead():
	hour += 1
	if hour >= 24:
		hour = 0
		day_ahead()
	if hour == hour_end:
		#sunrise! the night no longer rolls over by itself, going home is the only way forward
		overtime = true

signal daysignal
func day_ahead():
	numday += 1
	#for readability, I number the days 1-7. but of course we need 0-6 for the array
	var arrday = numday-1
	if arrday >= weekday_array.size():
		arrday = 0
	weekday = weekday_array[arrday]

#called by the game manager when the rancher goes to sleep; rolls the world to the next 18:00
func new_night():
	if hour >= hour_start:
		#went home before midnight, so the calendar hasn't flipped yet
		day_ahead()
	if numday > daylimit:
		game_manager.game_won()
		return
	hour = hour_start
	minute = 0
	overtime = false
	grace_left = grace_minutes
	game_manager.new_day()
	daysignal.emit()
	min_signal.emit()

#tells the hud to nag the rancher when the sun is close; empty when all is well
func warn_str():
	if overtime:
		return "SUNRISE! GET HOME! (" + str(int(grace_left)) + ")"
	elif hour >= warn_hour and hour < hour_end:
		return "The sun rises soon - get home!"
	return ""

#the number of the night currently being played
#the calendar flips at midnight, but the rancher's night doesn't
func night_number():
	if hour < hour_start:
		return numday - 1
	return numday

#returns the current time as a string
#i changed the format of the clock to 12-hour.
func time_to_str():
	var minutestr = "%02d" % minute
	var ampm = "AM"
	if hour >= 12:
		ampm = "PM"
	var hour12 = hour % 12
	if hour12 == 0:
		hour12 = 12
	var daystr = "Day " + str(mini(night_number(), daylimit)) + "/" + str(daylimit)
	var timestr = daystr + " - " + weekday + " , " + str(hour12) + ":" + minutestr + " " + ampm
	return timestr

func debug_time():
	var newstring = time_to_str()
	print(newstring)

func _on_speed_manager_speedsignal():
	min_ahead()
