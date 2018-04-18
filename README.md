# applescript-flash-briefing
An AppleScript-based "Flash Briefing" that plays over the house AirPlay speakers to announce weather, calendar events, birthdays, holidays and play news/podcasts. This requires macOS, iTunes, an [API key from Dark Sky](https://darksky.net/dev), [icalBuddy](http://hasseg.org/icalBuddy/) and [Airfoil](https://www.rogueamoeba.com/airfoil/). If you want to integrate it into HomeKit, you'll need [Ben Dodson's AppleScript plugin](https://github.com/bendodson/homebridge-applescript) as well.

---

I love the idea of the Amazon Echo's "Flash Briefing" but don't particularly like the device, so I came up with my own version. I have this AppleScript set to trigger using [Ben Dodson's AppleScript plugin](https://github.com/bendodson/homebridge-applescript) for Homebridge, so it shows up as a switch I can toggle on/off by voice, automation, etc. I have it trigger based on a date/time window (Mon-Fri between 6-9am) using a motion sensor in my office along with some other conditions to go off automatically, but you could just as easily do it manually. 

It all started off as a means to get the weather, and quickly snowballed into wanting calendar events and eventually the news. More ideas will come along with time I'm sure, but in the meantime this is what it does. 

### Requirements
A few things you'll need before you can get started. The **weather** requires an [API key from Dark Sky](https://darksky.net/dev), they're free for less than 1000 calls per day, so plenty for this script. Once you've generated your key, it will provide you with a URL, you need to place the entire thing into the variable at the top:
```set apiURL to "https://api.darksky.net/forecast/FAKEURL"```
The URL they provide should include your longitude and latitude to get precise weather data, be sure to double check the values are correct.

For the **calendar** data, you'll need to install an app called [icalBuddy](http://hasseg.org/icalBuddy/) and modify the calendar names in the code. There are variables at the top for the names of your birthdays calendar: ```set birthdayCalendar to "Birthdays"``` and another for any other calendar, such as Home, Work and Holidays: ```set calendars to "Home, Work, US Holidays"```

For **news/podcasts** we'll need to go into iTunes. Go to View>Media Kind>Podcasts, subscribe to whatever news podcasts you want to hear in the morning. In this example we'll use the daily 5-minute snippet from "NPR News Now" and a short snippet from Relay FM's "Subnet", but there are plenty of good ones out there you can add. Next we'll need to create a new "Smart Playlist" called "Morning News" (you can change this, but it needs updated in the code too) and create rules for each podcast. Refer to the following screenshot:
![](https://github.com/dippnerd/applescript-flash-briefing/raw/master/smart-playlist.png)
We need to set it to "Match *podcasts* for *any* of the following rules:" and create a line for each podcast, fitting the criteria "*Album* contains **podcast name**", then check the Limit box and set the value to the number of lines we created, for *items* selected by *most recently added* as well as turn on *Live updating*. This should give us a smart playlist that automatically updates with new podcasts every day, only playing one of each based on how new they are. 

For the speakers, I'm using the [Airfoil](https://www.rogueamoeba.com/airfoil/) software to broadcast to all of my speakers. Refer to my other project [airfoil-speakers-applescript](https://github.com/dippnerd/airfoil-speakers-applescript) for more details on setting that up.

Since you probably don't have the same speaker layout as me, you'll need to find the function ```setSpeakers()``` and update the code to correspond to your speaker names and quantity (may need to adjust volume too).

Once all of that is setup, I would recommend opening the Script Editor software on macOS to test this out and make sure it functions as expected. Once you're done testing, you can point the [Homebridge AppleScript plugin](https://github.com/bendodson/homebridge-applescript) to your script and be ready to go. 

### Things to consider
You can trigger this manually from the Home app/Control Center widget, as well as using Siri "turn on Flash Briefing", but I prefer it to be automated. I use a motion sensor and some various conditions, but you could easily make this your alarm in the morning based on time triggers, or an automation that detects when a specific light comes on between certain hours, for example. The switch unfortunately can't turn itself back off, so I recommend setting your automation to to "turn off" after a set period so it flips the switch back for the next day. 

Make sure to build your automations with enough conditions to account for this too. One of mine is to only turn the switch on if the switch is currently off. Sounds silly, but there have been cases where it triggered it multiple times, so be careful. 
