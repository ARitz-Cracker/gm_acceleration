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

Car.Msgs.tool = Car.Msgs.tool or {}
Car.Msgs.tool.snappy = Car.Msgs.tool.snappy or {}
Car.Msgs.tool.snappy.ent_selected = "Selected %ENT% as reference entity"
Car.Msgs.tool.snappy.ent_reset = "Cleared reference entity"