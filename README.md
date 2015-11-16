# Presser
Simple AHK script for repeatedly pressing keys with fixed intervals.
You can create any binds count which can run independently with varios intervals.

###Configuration
You can configure script from presser.ini file in folder with program.
Every keybind should be in section [KeyN], where N - is sequential number from 1 to keybinds count.

###[KeyN]
You can set various parameters for keybind.
<br><b>Name</b><br>
	name for keybind. Used for notification about enabling/disabling of keybind. Default name will be <ToggleKey> - <Key>
<br><b>Key</b><br>
	key, which will be pressed by script. You can type any charsequence. For special keys, use curve brackets like "{F3}".
<br><b>ToggleKey</b><br>
	key, which will toggle keybind. ^Ctrl, !Alt, +Shift, #Win
<br><b>Interval</b><br>
	time between ticks
<br><b>EnableFrequency</b>
<br><b>DisableFrequency</b>
<br><b>TickFrequency</b><br>
	Frequency of sound which will be played on event of enabling, disabling and tick of keybind. If value is -1, sound will't play.
<br><b>RunOnStart</b><br>
	True for activate keybind on script load.

###[Config]
Keybind parameters can be defined in [Config] section, which will override default values. You can specify all values, besides Name, Key, ToggleKey.<br>
Also there is parameter for script notification.
###NotifyType
type of notification on keybind toggling. <br>
	0 - disabled, 1 - tooltip on upper-left part of the screen, 2 - tooltip on cursor position, 3 - gui window on upper-left part of the screen
