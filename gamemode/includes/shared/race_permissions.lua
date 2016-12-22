--[[--------------------------------------------------------------------------------------
 _______                     ______                      _____ _____                
 ___    |___________________ ___  /_____ ______________ ___  /____(_)______ _______ 
 __  /| |_  ___/_  ___/_  _ \__  / _  _ \__  ___/_  __ `/_  __/__  / _  __ \__  __ \
 _  ___ |/ /__  / /__  /  __/_  /  /  __/_  /    / /_/ / / /_  _  /  / /_/ /_  / / /
 /_/  |_|\___/  \___/  \___/ /_/   \___/ /_/     \__,_/  \__/  /_/   \____/ /_/ /_/ 
 
 
	By Aritz Beobide-Cardinal (ARitz Cracker) && James R Swift (James xX)
 
--------------------------------------------------------------------------------------]]--
function Car.GetPitstop(ply)
	local result = NULL
	for k,v in ipairs(ents.FindByClass("sent_arc_pitstop")) do
		if v:GetDriver() == ply then
			result = v
			break
		end
	end
	return result
end
function Car.GetCar(ply)
	local result = NULL
	for k,v in ipairs(ents.FindByClass("sent_arc_car")) do
		if v:GetDriver() == ply then
			result = v
			break
		end
	end
	return result
end
--[[
hook.Add("CanTool","willox pls fix",function( ply, tr, tool )
	debug.Trace()
	print(tool..","..tostring(tr.HitPos))
end)
]]
hook.Add("CanTool","Acceleration ToolsOnlyInPitstop",function( ply, tr, tool )
	local inPitstop = true
	local pitstop = Car.GetPitstop(ply)
	if not IsValid(pitstop) then
		inPitstop = false
	end
	if IsValid(tr.Entity) and tr.Entity:GetClass() == "sent_arc_pitstop" then
		inPitstop = false
	end
	if inPitstop and not ply:GetPos():WithinAABox( pitstop:LocalToWorld(pitstop:OBBMins()), pitstop:LocalToWorld(pitstop:OBBMaxs())) then
		inPitstop = false
	end
	if inPitstop and not tr.HitPos:WithinAABox( pitstop:LocalToWorld(pitstop:OBBMins()), pitstop:LocalToWorld(pitstop:OBBMaxs())) then
		inPitstop = false
	end
	if not inPitstop then
		if SERVER then -- I would do client, but really is the server who decides.
			ARCLib.NotifyPlayer(ply,Car.Msgs.PitstopMsgs.ToolNotInPitstop, NOTIFY_ERROR, 5,true)
		end
		return false
	end
end)
local debugging = true
local function checkFreeze(ply,ent)
	if debugging then return nil end
	if ent.CarFrozenEnt then return false end
	local inPitstop = true
	local pitstop = Car.GetPitstop(ply)
	if not IsValid(pitstop) then
		inPitstop = false
	end
	if inPitstop and not ply:GetPos():WithinAABox( pitstop:LocalToWorld(pitstop:OBBMins()), pitstop:LocalToWorld(pitstop:OBBMaxs())) then
		inPitstop = false
	end
	if inPitstop and not ent:GetPos():WithinAABox( pitstop:LocalToWorld(pitstop:OBBMins()), pitstop:LocalToWorld(pitstop:OBBMaxs())) then
		inPitstop = false
	end
	if not inPitstop then
		return false
	end
end

hook.Add( "PhysgunPickup", "PhysOnlyInPitstop", checkFreeze)
hook.Add( "CanPlayerUnfreeze", "PhysOnlyInPitstop", checkFreeze)
hook.Add( "OnPhysgunFreeze", "PhysOnlyInPitstop", function(weapon, phys, ent, ply)
	return checkFreeze(ply,ent)
end)
hook.Add( "CanProperty", "PhysOnlyInPitstop", function(ply, property, ent)
	return checkFreeze(ply,ent)
end)

if SERVER then

else

end