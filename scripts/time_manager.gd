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

#we need a signal to tell the game that time is indeed passing
signal min_signal
func min_ahead():
	minute += 1
	if minute >= 60:
		minute = 0
		hour_ahead()
	min_signal.emit()

func hour_ahead():
	hour += 1
	if hour >= 24:
		hour = 0
		day_ahead()
	if hour == hour_end:
		hour = hour_start
		day_ends()

func day_ahead():
	numday += 1
	#for readability, I number the days 1-7. but of course we need 0-6 for the array
	var arrday = numday-1
	if arrday >= weekday_array.size():
		arrday = 0
	weekday = weekday_array[arrday]

func day_ends():
	if numday > daylimit:
		game_manager.game_over()
	else:
		game_manager.new_day()

#returns the current time as a string
func time_to_str():
	var minutestr = "%02d" % minute
	var hourstr = "%02d" % hour
	var timestr = weekday + " , " + hourstr + ":" + minutestr
	return timestr

func debug_time():
	var newstring = time_to_str()
	print(newstring)

func _on_speed_manager_speedsignal():
	min_ahead()
