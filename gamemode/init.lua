AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
local fol = GM.FolderName.."/gamemode/includes/"

local sharedfiles, _ = file.Find( fol.."shared/*.lua", "LUA" )
local serverfiles, _ = file.Find( fol.."server/*.lua", "LUA" )
local clientfiles, _ = file.Find( fol.."client/*.lua", "LUA" )
	
Car.Msg("####     Loading Serverside Files..     ####")
for i, v in ipairs( serverfiles ) do
	Car.Msg("#### Loading: "..fol.."server/"..v)
	include( fol.."server/"..v )
end
for i, v in ipairs( sharedfiles ) do
	Car.Msg("#### Loading: "..fol.."shared/"..v)
	include( fol.."shared/"..v )
end
Car.Msg("####     Sending Clientside Files..     ####")
for i, v in ipairs( clientfiles ) do
	Car.Msg("#### Sending: "..fol.."client/"..v)
	AddCSLuaFile( fol.."client/"..v )
end
for i, v in ipairs( sharedfiles ) do
	Car.Msg("#### Sending: "..fol.."shared/"..v)
	AddCSLuaFile( fol.."shared/"..v )
end
