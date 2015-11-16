# Presser
Simple AHK script for repeatedly pressing keys with fixed intervals.
You can create any binds count which can run independently with varios intervals. This is my first functional github project which serves github education purpouse more than any else. But it certainly can by useful for someone anyway. :)

###Configuration
You can configure script from presser.ini file in folder with program.
Every keybind should be in section [KeyN], where N - is sequential number from 1 to keybinds count.

<h4>[KeyN] section</h4>
You can set various parameters for keybind.<br>
<h6>Name</h6>
name for keybind. Used for notification about enabling/disabling of keybind. <br>Default name will be [ToggleKey] - [Key]
<h6>Key</h6>
key, which will be pressed by script. You can type any charsequence. For special keys, use curve brackets like "{F3}".
<h6>ToggleKey</h6>
key, which will toggle keybind. Modifiers: ^Ctrl, !Alt, +Shift, #Win
<h6>Interval</h6>
time between presses
<h6>EnableFrequency, DisableFrequency, TickFrequency</h6>
Frequency of sound which will be played on event of enabling, disabling and tick of keybind. If value is -1, sound will't play.
<h6>RunOnStart</h6>
True for activate keybind on script load.

<h4>[Config] section</h4>
Keybind parameters can be defined in [Config] section, which will override default values. You can specify all values, besides Name, Key, ToggleKey.<br>
Also there is some other script parameters
<h6>NotifyType</h6>
type of notification on keybind toggling. <br>
	- 0 - disabled
	- 1 - tooltip on upper-left part of the screen
	- 2 - tooltip on cursor position
	- 3 - gui window on upper-left part of the screen
<h6>NotificationTime</h6>
duration for which enabling/disabling keybind hint will be shown.

###Acknowledgments
I used free icon from awesome site www.iconarchive.com. Also, thanks user lexikos for useful little ahk script which can call functions by timers, nearly all core work was done by him, even if he doesn't aware of it.  ;) [https://autohotkey.com/boards/viewtopic.php?t=1948]


