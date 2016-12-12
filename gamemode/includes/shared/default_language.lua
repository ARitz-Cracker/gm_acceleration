--[[--------------------------------------------------------------------------------------
 _______                     ______                      _____ _____                
 ___    |___________________ ___  /_____ ______________ ___  /____(_)______ _______ 
 __  /| |_  ___/_  ___/_  _ \__  / _  _ \__  ___/_  __ `/_  __/__  / _  __ \__  __ \
 _  ___ |/ /__  / /__  /  __/_  /  /  __/_  /    / /_/ / / /_  _  /  / /_/ /_  / / /
 /_/  |_|\___/  \___/  \___/ /_/   \___/ /_/     \__,_/  \__/  /_/   \____/ /_/ /_/ 
 
 
	By Aritz Beobide-Cardinal (ARitz Cracker) && James R Swift (James xX)
 
--------------------------------------------------------------------------------------]]--

Car.MsgsSource = {"tool"}
Car.Msgs = Car.Msgs or {}
Car.Msgs.HudMsg = Car.Msgs.HudMsg or {}
Car.Msgs.HudMsg.Transform = "PRESS [JUMP] TO TRANSFORM"

Car.Msgs.Generic = Car.Msgs.Generic or {}
Car.Msgs.Generic.OK = "OK"
Car.Msgs.Generic.Cancel = "Cancel"
Car.Msgs.Generic.Yes = "Yes"
Car.Msgs.Generic.No = "No"
Car.Msgs.Generic.Abort = "Abort"
Car.Msgs.Generic.Retry = "Retry"
Car.Msgs.Generic.Ignore = "Ignore"


Car.Msgs.PitstopMsgs = Car.Msgs.PitstopMsgs or {}
Car.Msgs.PitstopMsgs.NoPitstop = "You do not have a garage"
Car.Msgs.PitstopMsgs.NotInPitstop = "You are not in your garage"
Car.Msgs.PitstopMsgs.ToolNotInPitstop = "You cannot use a tool outside your garage"
Car.Msgs.PitstopMsgs.ToolNotAcceleration = "You can only use the remover or tools from the \"Acceleration\" category"
Car.Msgs.PitstopMsgs.NoBuild = "Your garage is not in BUILD mode"

Car.Msgs.tool = Car.Msgs.tool or {}
Car.Msgs.tool.snappy = Car.Msgs.tool.snappy or {}
Car.Msgs.tool.snappy.name = "Snappy"
Car.Msgs.tool.snappy.help = "This tool \"snaps\" the entity you're targetting in place. Allowing for more exact building!"
Car.Msgs.tool.snappy.position = {}
Car.Msgs.tool.snappy.position._ = "Snap position"
Car.Msgs.tool.snappy.position.help = "Snaps the entity position to the nearest...position?? (TODO: Better explination)"

Car.Msgs.tool.snappy.ent_selected = "Selected %ENT% as the reference entity"
Car.Msgs.tool.snappy.ent_reset = "Cleared reference entity"

Car.Msgs.tool.assembler = Car.Msgs.tool.assembler or {}
Car.Msgs.tool.assembler.ent_invalid = "This entity cannot be used in a vehicle."
Car.Msgs.tool.assembler.ent_within = "The entity is not within the size limit"

Car.Msgs.tool.mover = Car.Msgs.tool.mover or {}
Car.Msgs.tool.mover.name = "Mover"
Car.Msgs.tool.mover.desc = "Allows you to move things precisely"
Car.Msgs.tool.mover.left = "Move selected object"
Car.Msgs.tool.mover.right = "Rotate selected object"
Car.Msgs.tool.mover.movex = "Backward/Forward distance"
Car.Msgs.tool.mover.movey = "Left/Right distance"
Car.Msgs.tool.mover.movez = "Down/Up distance"

Car.Msgs.tool.mover.lifter = "Move relative to lifter"
Car.Msgs.tool.mover.moveang = "Rotation amount (degrees)"
Car.Msgs.tool.mover.angaxis = {}
Car.Msgs.tool.mover.angaxis._ = "Rotation Axis"
Car.Msgs.tool.mover.angaxis.setting1 = "Entity Up/Down"
Car.Msgs.tool.mover.angaxis.setting2 = "Entity Right/Left"
Car.Msgs.tool.mover.angaxis.setting3 = "Entity Front/Back"
Car.Msgs.tool.mover.angaxis.setting4 = "Lifter Up/Down"
Car.Msgs.tool.mover.angaxis.setting5 = "Lifter Right/Left"
Car.Msgs.tool.mover.angaxis.setting6 = "Lifter Front/Back"
Car.Msgs.tool.mover.angaxis.setting7 = "Perpendicular to the target surface"

Car.Msgs.tool.mover.angcenter = {}
Car.Msgs.tool.mover.angcenter._ = "Rotation Center"
Car.Msgs.tool.mover.angcenter.setting1 = "Entity origin"
Car.Msgs.tool.mover.angcenter.setting2 = "Center of the entity's model"
Car.Msgs.tool.mover.angcenter.setting3 = "Lifter refrence point"
Car.Msgs.tool.mover.angcenter.setting4 = "The target position"

Car.Msgs.CommandOutput = Car.Msgs.CommandOutput or {}
Car.Msgs.CommandOutput.SysReset = "System reset required! Please enter \"youraddon reset\""
Car.Msgs.CommandOutput.SysSetting = "%SETTING% has been changed to %VALUE%"
Car.Msgs.CommandOutput.AdminCommand = "You must be one of these ranks to use this command: %RANKS%"
Car.Msgs.CommandOutput.SettingsSaved = "Settings have been saved!"
Car.Msgs.CommandOutput.SettingsError = "Error saving settings."
Car.Msgs.CommandOutput.ResetYes = "System reset!"
Car.Msgs.CommandOutput.ResetNo = "Error. Check server console for details."

Car.Msgs.AdminMenu = Car.Msgs.AdminMenu or {}
Car.Msgs.AdminMenu.Remove = "Remove"
Car.Msgs.AdminMenu.Add = "Add"
Car.Msgs.AdminMenu.Description = "Description:"
Car.Msgs.AdminMenu.Enable = "Enable"
Car.Msgs.AdminMenu.Settings = "Settings"
Car.Msgs.AdminMenu.AdvSettings = "Advanced Settings"
Car.Msgs.AdminMenu.ChooseSetting = "Choose setting"
Car.Msgs.AdminMenu.Commands = "Commands"
Car.Msgs.AdminMenu.SaveSettings = "Save Settings"
Car.Msgs.AdminMenu.Logs = "System Logs"
Car.Msgs.AdminMenu.Unavailable = "This feature is currently unavailable"

Car.SettingsDesc = Car.SettingsDesc or {}
Car.SettingsDesc.admins = "The usergroups that can access the admin commands"
Car.SettingsDesc.language = "The language to display"
