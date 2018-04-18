set apiURL to "https://api.darksky.net/forecast/FAKEURL"

setSpeakers()

set fullBriefing to getDateAndTime() & ";"

set fullBriefing to fullBriefing & getWeather(apiURL) & ";"

set fullBriefing to fullBriefing & getTodayEvents() & ";"

set fullBriefing to fullBriefing & getTodayBirthdays() & ";"

set fullBriefing to fullBriefing & getWeeklyOverview() & ";"

set fullBriefing to fullBriefing & getUpcomingBirthdays() & ";"

say fullBriefing

getNews()

on strSplit(theString, theDelimiter)
	-- save delimiters to restore old settings
	set oldDelimiters to AppleScript's text item delimiters
	-- set delimiters to delimiter to be used
	set AppleScript's text item delimiters to theDelimiter
	-- create the array
	set theArray to every text item of theString
	-- restore the old setting
	set AppleScript's text item delimiters to oldDelimiters
	-- return the result
	return theArray
end strSplit

on getTodayBirthdays()
	set todaysBirthdays to (do shell script "/usr/local/bin/icalBuddy -ic \"Birthdays\" -b \"***\" -npn -nc -ps \"| ::: |\" -po \"datetime,title\"  -eed eventsToday")
	
	set myArray to my strSplit(todaysBirthdays, return)
	
	set listSize to count of myArray
	
	set endResult to ""
	
	if listSize is greater than 0 then
		set endResult to "Today is "
		repeat with theItem in myArray
			set endResult to endResult & trim_line(theItem, "Birthday", 1) & " and "
		end repeat
		set endResult to trim_line(endResult, " and ", 1) & "Birthday... Happy birthday!"
	end if
	
	return endResult
	
end getTodayBirthdays

on getUpcomingBirthdays()
	set startDate to do shell script "date -v+1d +%m/%d/%Y"
	set endDate to do shell script "date -v+7d +%m/%d/%Y"
	
	set birthdays to (do shell script "/usr/local/bin/icalBuddy -df %A -ic \"Birthdays\" -b \"\" -npn -nrd -nc -ps \"| ::: |\" -po \"datetime,title\"  -eed eventsFrom:" & startDate & " to:" & endDate)
	
	set myArray to my strSplit(birthdays, return)
	
	set listSize to count of myArray
	
	set endResult to ""
	
	if listSize is greater than 0 then
		set endResult to "Birthdays this week include "
		repeat with theItem in myArray
			set thisBirthday to my strSplit(theItem, " ::: ")
			set thisDay to item 1 of thisBirthday
			set thisName to item 2 of thisBirthday
			set endResult to endResult & trim_line(thisName, "'s Birthday", 1) & " on " & thisDay & "; "
		end repeat
	end if
	return endResult
end getUpcomingBirthdays

on getUpcomingHolidays()
	set startDate to do shell script "date -v+1d +%m/%d/%Y"
	set endDate to do shell script "date -v+7d +%m/%d/%Y"
	
	set holidays to (do shell script "/usr/local/bin/icalBuddy -df %A -ic \"US Holidays\" -b \"\" -npn -nrd -nc -ps \"| ::: |\" -po \"datetime,title\"  -eed eventsFrom:" & startDate & " to:" & endDate)
	
	set myArray to my strSplit(holidays, return)
	
	set listSize to count of myArray
	
	set endResult to ""
	
	if listSize is greater than 0 then
		repeat with theItem in myArray
			set thisHoliday to my strSplit(theItem, " ::: ")
			set thisDay to item 1 of thisHoliday
			set thisName to item 2 of thisHoliday
			set endResult to endResult & thisName & " is on " & thisDay & "; "
		end repeat
	end if
	return endResult
end getUpcomingHolidays

on getWeeklyOverview()
	set startDate to do shell script "date -v+1d +%m/%d/%Y"
	set endDate to do shell script "date -v+7d +%m/%d/%Y"
	
	set weeklyEvents to (do shell script "/usr/local/bin/icalBuddy -df %A -ic \"Home, Work, US Holidays\" -npn -nrd -nc -ps \"| ::: |\" -po \"datetime,title\"  -eed eventsFrom:" & startDate & " to:" & endDate)
	
	set weeklyEvents to ((characters 2 thru -1 of weeklyEvents) as string)
	set myArray to my strSplit(weeklyEvents, "¥")
	
	set listSize to count of myArray
	
	set endResult to ""
	
	if listSize is greater than 0 then
		set endResult to "Coming up this week: "
		repeat with theItem in myArray
			set thisEvent to my strSplit(theItem, " ::: ")
			set thisDay to item 1 of thisEvent
			set thisName to item 2 of thisEvent
			set endResult to endResult & thisName & " is on " & thisDay & "; "
		end repeat
	end if
	return endResult
end getWeeklyOverview

on getTodayEvents()
	set todaysEvents to (do shell script "/usr/local/bin/icalBuddy -ic \"Home, Work,US Holidays\" -b \"***\" -npn -nc -ps \"| ::: |\" -po \"datetime,title\"  -eed eventsToday")

	set myArray to my strSplit(todaysEvents, "***")
	
	set listSize to count of myArray
	
	set endResult to ""
	
	if listSize is equal to 1 then
		set theEvent to item 1 of myArray
		set endResult to endResult & "You have one event on your calendar for today, " & theEvent
	else if listSize is greater than 0 then
		
		set loopResult to ""
		
		repeat with theItem in myArray
			set thisEvent to my strSplit(theItem, " ::: ")
			set eventSize to count of thisEvent
			if eventSize is equal to 2 then
				set thisEventTime to item 1 of thisEvent
				set thisEventName to item 2 of thisEvent
				set loopResult to loopResult & " at " & thisEventTime & " you have " & thisEventName & "; "
			else if eventSize is equal to 3 then
				set thisEventTime to item 1 of thisEvent
				set thisEventName to item 2 of thisEvent
				set thisEventLocation to item 3 of thisEvent
				
				set thisEventLocationArray to my strSplit(thisEventLocation, ",")
				set thisEventLocation to item 1 of thisEventLocationArray
				set thisEventLocationArray to my strSplit(thisEventLocation, "(")
				
				set thisEventLocation to item 1 of thisEventLocationArray
				
				
				set loopResult to loopResult & " at " & thisEventTime & " you have " & thisEventName & " at " & thisEventLocation & "; "
			else if eventSize is equal to 1 then
				set loopResult to loopResult & " All day: " & theItem & "; "
			else
				set listSize to listSize - 1
			end if
		end repeat
		
		
		if listSize is equal to 1 then
			set endResult to endResult & "You have one event on your calendar for today, " & loopResult
		else
			set endResult to endResult & "You have " & listSize & " events on your calendar for today, " & loopResult
		end if
	end if
	
	return endResult
end getTodayEvents


on getWeather(apiURL)
	tell application "JSON Helper"
		set fullWeather to fetch JSON from apiURL
		set todayWeather to daily of fullWeather
		set todayWeather2 to item 1 of |data| of todayWeather
		set todaySummary to summary of item 1 of |data| of todayWeather
		set todayHigh to temperatureMax of item 1 of |data| of todayWeather
		set todayLow to temperatureMin of item 1 of |data| of todayWeather
		set precipChance to precipProbability of item 1 of |data| of todayWeather
		set currentTemp to temperature of currently of fullWeather
		set currentCondition to summary of currently of fullWeather
		
		
		set fullSummary to "It is currently " & (round (currentTemp)) & " degrees and " & currentCondition & ". Today will have a high of " & (round (todayHigh)) & " and " & todaySummary
		
		return fullSummary
	end tell
end getWeather

on getNews()
	say "Here's the News:"
	tell application "iTunes"	
		set computerSpeaker to (first AirPlay device whose name = "Computer")
		set current AirPlay devices to {computerSpeaker}
		
		set sound volume to 100
	
		play the playlist named "Morning News"
	end tell
end getNews

on setSpeakers()
	tell application "Airfoil"
		set kitchenSpeaker to first speaker whose name is "Kitchen"
		set officeSpeaker to first speaker whose name is "Office"
		set lrSpeaker to first speaker whose name is "Living Room"
		set bedSpeaker to first speaker whose name is "Bedroom"
		set (volume of kitchenSpeaker) to 0.25
		set (volume of officeSpeaker) to 0.25
		set (volume of lrSpeaker) to 0.25
		set (volume of bedSpeaker) to 0.25
		connect to kitchenSpeaker
		connect to officeSpeaker
		connect to lrSpeaker
		connect to bedSpeaker
	end tell
end setSpeakers

on getDateAndTime()
	-- Get the "hour"
	set timeStr to time string of (current date)
	set Pos to offset of ":" in timeStr
	set theHour to characters 1 thru (Pos - 1) of timeStr as string
	set timeStr to characters (Pos + 1) through end of timeStr as string
	
	-- Get the "minute"
	set Pos to offset of ":" in timeStr
	set theMin to characters 1 thru (Pos - 1) of timeStr as string
	set timeStr to characters (Pos + 1) through end of timeStr as string
	
	--Get "AM or PM"
	set Pos to offset of " " in timeStr
	set theSfx to characters (Pos + 1) through end of timeStr as string
		
	set dateTimeArray to my strSplit((current date) as string, " at ")
	set newDate to item 1 of dateTimeArray
	
	return "Good morning. Today is " & newDate & ". The time is " & (theHour & ":" & theMin)
end getDateAndTime

on trim_line(this_text, trim_chars, trim_indicator)
	-- 0 = beginning, 1 = end, 2 = both
	set x to the length of the trim_chars
	-- TRIM BEGINNING
	if the trim_indicator is in {0, 2} then
		repeat while this_text begins with the trim_chars
			try
				set this_text to characters (x + 1) thru -1 of this_text as string
			on error
				-- the text contains nothing but the trim characters
				return ""
			end try
		end repeat
	end if
	-- TRIM ENDING
	if the trim_indicator is in {1, 2} then
		repeat while this_text ends with the trim_chars
			try
				set this_text to characters 1 thru -(x + 1) of this_text as string
			on error
				-- the text contains nothing but the trim characters
				return ""
			end try
		end repeat
	end if
	return this_text
end trim_line