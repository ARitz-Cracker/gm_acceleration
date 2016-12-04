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
		if v.Player == ply then
			result = v
			break
		end
	end
	return result
end

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

if SERVER then

else

end