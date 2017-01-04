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
Car.Msgs.HudMsg.Cancelled = "Race has been cancelled!"
Car.Msgs.HudMsg.NewRace = "There will be a new race in %TIME%"

Car.Msgs.Generic = Car.Msgs.Generic or {}
Car.Msgs.Generic.NewFolder = "New Folder"
Car.Msgs.Generic.FolderName = "Enter folder name"
Car.Msgs.Generic.FileName = "Enter file name"
Car.Msgs.Generic.InvalidFileName = "The name of the file is invalid"
Car.Msgs.Generic.DeleteSure = "Are you sure you want to delete %FILE%? There is no recycle bin to save you!"
Car.Msgs.Generic.SaveWait = "Please wait until the previous file has finished saving before saving again"
Car.Msgs.Generic.LoadWait = "Please wait until the previous file has finished loading before saving again"
Car.Msgs.Generic.SaveBad = "Your save file is corrupt or invalid"
Car.Msgs.Generic.Properties = "Properties"
Car.Msgs.Generic.Rename = "Rename"
Car.Msgs.Generic.Delete = "Delete"
Car.Msgs.Generic.Save = "Save"
Car.Msgs.Generic.Load = "Load"
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
Car.Msgs.PitstopMsgs.MassCenterWarning = "Acceleration uses a different welding method then the default weld tool.\nThis method is a lot less laggy, but the center of mass _will_ be the center of the car.\nThis means that, for example, if you put a bunch of heavy things on the back but light things on the front, the back will NOT weigh more than the front. Instead, the weight will be distributed evenly throughout your car. All your props will also be converted to have \"metal\" physical properties."
Car.Msgs.PitstopMsgs.NoSeat = "Your car has no seat."
Car.Msgs.PitstopMsgs.NoWheels = "Your car must have 2 or more wheels."
Car.Msgs.PitstopMsgs.NoProp = "Your car must have at least 1 prop."
Car.Msgs.PitstopMsgs.TooComplex = "Your car's collision model is to complex! Try turning some props into effects. (NOTE: Effects will be added in the future)"
Car.Msgs.PitstopMsgs.ModelBad = "%MODEL% is invalid! Maybe the server doesn't have it?"
Car.Msgs.PitstopMsgs.DeployCar = "Deploy Car"
Car.Msgs.PitstopMsgs.BuildMode = "Build Car"
Car.Msgs.PitstopMsgs.SaveAsk = "Save the car? You will not be able to save the car after it's deployed."

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
Car.Msgs.tool.assembler.name = "Car Assembler"
Car.Msgs.tool.assembler.desc = "Welds props to your car"
Car.Msgs.tool.assembler.left = "Makes the targetted entity part of your car"
Car.Msgs.tool.assembler.right = "Detaches the targetted entity from the car (THIS IS BROKEN!)"
Car.Msgs.tool.assembler.reload = "Dissasembles your car"
Car.Msgs.tool.assembler.help = "Assembles your car"

Car.Msgs.tool.assembler.ent_invalid = "This entity cannot be used in a vehicle."
Car.Msgs.tool.assembler.ent_within = "The entity is not within the size limit"

Car.Msgs.tool.mover = Car.Msgs.tool.mover or {}
Car.Msgs.tool.mover.name = "Mover"
Car.Msgs.tool.mover.desc = "Allows you to move things precisely"
Car.Msgs.tool.mover.help = "The mover tool allows for precise movment"
Car.Msgs.tool.mover.left = "Move selected object"
Car.Msgs.tool.mover.right = "Rotate selected object"
Car.Msgs.tool.mover.movex = {}
Car.Msgs.tool.mover.movex._ = "X distance"
Car.Msgs.tool.mover.movex.help = "The distance to move the entity. Positive number is forward, negative number is backwards."
Car.Msgs.tool.mover.movey = {}
Car.Msgs.tool.mover.movey._ = "Y distance"
Car.Msgs.tool.mover.movey.help = "The distance to move the entity. Positive number is right, negative number is left."
Car.Msgs.tool.mover.movez = {}
Car.Msgs.tool.mover.movez._ = "Z distance"
Car.Msgs.tool.mover.movez.help = "The distance to move the entity. Positive number is up, negative number is down."

Car.Msgs.tool.mover.lifter = {}
Car.Msgs.tool.mover.lifter._ = "Move relative to lifter"
Car.Msgs.tool.mover.lifter.help = "When checked, the entity will move relative to the lifter. If unchecked, the prop will move relative to you."
Car.Msgs.tool.mover.moveang = {}
Car.Msgs.tool.mover.moveang._ = "Rotation amount"
Car.Msgs.tool.mover.moveang = "The amount of degrees to rotate the entity by"
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

Car.Msgs.tool.checkpoint = Car.Msgs.tool.checkpoint or {}
Car.Msgs.tool.checkpoint.InvalidOrder = "Your race track has a gap in it somewhere! (They aren't in sequential order)"
Car.Msgs.tool.checkpoint.InvalidPair = "You have a checkpoint post who's all lonely :("
Car.Msgs.tool.checkpoint.Saved = "Race track saved!"
Car.Msgs.tool.checkpoint.Placed = "Checkpoint #%NUM% placed"

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
