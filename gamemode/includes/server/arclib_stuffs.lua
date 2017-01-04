Car.Commands = {
    ["about"] = {
        command = function(ply,args) -- This function is called when you would enter "theawesomeaddon about" in console
            if !ARCBank.Loaded then Car.MsgCL(ply,ARCBank.Msgs.CommandOutput.SysReset) return end
            Car.MsgCL(ply,"This is the awesome addon, your addon! :)" )
        end, 
        usage = "", -- What arguments this command accepts use <> for requeired arguments and [] for optional ones.
        description = "About The Awesome addon",
        adminonly = false, -- If it should check your 
        hidden = false
    },
    ["test"] = {
        command = function(ply,args) 
            local str = "Arguments:"
            for _,arg in ipairs(args) do
                str = str.." | "..arg
            end
            Car.MsgCL(ply,str)
        end, 
        usage = " [argument(any)] [argument(any)] [argument(any)]",
        description = "[Debug] Tests arguments",
        adminonly = false,
        hidden = true
    },
    ["race"] = {
        command = function(ply,args) 
            if args[1] == "join" then
				Car.Race.AddPlayerToQueue( ply )
			elseif args[1] == "unjoin" then
				Car.Race.RemovePlayerFromQueue( ply )
			else
			
			end
        end, 
        usage = " <join|unjoin>",
        description = "Joins the race",
        adminonly = false,
        hidden = true
    },
  -- More command here
}
ARCLib.AddSettingConsoleCommands("Car") -- Adds the commands the admin GUI uses to change the settings
ARCLib.AddAddonConcommand("Car","gm_acceleration") -- Actually makes the command usable

function Car.Load()
	if !file.IsDir( Car.Dir,"DATA" ) then
		Car.Msg("Created Folder: "..Car.Dir)
		file.CreateDir(Car.Dir)
	end
	--
	if !file.IsDir( Car.Dir,"DATA" ) then
		Car.Msg("CRITICAL ERROR! FAILED TO CREATE ROOT FOLDER!")
		Car.Msg("LOADING FALIURE!")
		return
	end
	if !file.IsDir( Car.Dir.."/checkpoint","DATA" ) then
		Car.Msg("Created Folder: "..Car.Dir.."/checkpoint")
		file.CreateDir(Car.Dir.."/checkpoint")
	end
	
	ARCLib.LoadDefaultLanguages("Car","https://raw.githubusercontent.com/ARitz-Cracker/aritzcracker-addon-translations/master/default_gm_acceleration_languages.json",function(langChoices)
		ARCLib.AddonAddSettingMultichoice("Car","language",langChoices or {})
		ARCLib.AddonLoadSettings("Car",{})
		ARCLib.SetAddonLanguage("Car")
	end)
end