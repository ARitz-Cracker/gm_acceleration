include( "shared.lua" )
local fol = GM.FolderName.."/gamemode/includes/"
local sharedfiles, _ = file.Find( fol.."shared/*.lua", "LUA" )
local clientfiles, _ = file.Find( fol.."client/*.lua", "LUA" )
	
Car.Msg("####     Loading Clientside Files..     ####")
for i, v in ipairs( clientfiles ) do
	Car.Msg("#### Loading: "..fol.."client/"..v)
	include( fol.."client/"..v )
end
for i, v in ipairs( sharedfiles ) do
	Car.Msg("#### Loading: "..fol.."shared/"..v)
	include( fol.."shared/"..v )
end
