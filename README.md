# Presser
Simple AHK script for repeatedly pressing keys with fixed intervals.
You can create any binds count which can run independently with varios intervals.

###Configuration
You can configure script from presser.ini file in folder with program.
Every keybind should be in section [KeyN], where N - is sequential number from 1 to keybinds count.

<h1>KeyN</h1>
You can set various parameters for keybind.
<br><h2>Name</h2><br>
	name for keybind. Used for notification about enabling/disabling of keybind. Default name will be <ToggleKey> - <Key>
<br><h2>Key</h2><br>
	key, which will be pressed by script. You can type any charsequence. For special keys, use curve brackets like "{F3}".
<br><h2>ToggleKey</h2><br>
	key, which will toggle keybind. ^Ctrl, !Alt, +Shift, #Win
<br><h2>Interval</h2><br>
	time between ticks
<br><h2>EnableFrequency</h2>
<br><h2>DisableFrequency</h2>
<br><h2>TickFrequency</h2><br>
	Frequency of sound which will be played on event of enabling, disabling and tick of keybind. If value is -1, sound will't play.
<br><h2>RunOnStart</h2><br>
	True for activate keybind on script load.

###[Config]
Keybind parameters can be defined in [Config] section, which will override default values. You can specify all values, besides Name, Key, ToggleKey.<br>
Also there is some other script parameters
<br><h2>NotifyType</h2><br>
type of notification on keybind toggling. <br>
	0 - disabled, 1 - tooltip on upper-left part of the screen, 2 - tooltip on cursor position, 3 - gui window on upper-left part of the screen
<br><h2>NotificationTime</h2><br>
	duration for which enabling/disabling keybind hint will be shown.

