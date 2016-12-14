--[[--------------------------------------------------------------------------------------
 _______                     ______                      _____ _____                
 ___    |___________________ ___  /_____ ______________ ___  /____(_)______ _______ 
 __  /| |_  ___/_  ___/_  _ \__  / _  _ \__  ___/_  __ `/_  __/__  / _  __ \__  __ \
 _  ___ |/ /__  / /__  /  __/_  /  /  __/_  /    / /_/ / / /_  _  /  / /_/ /_  / / /
 /_/  |_|\___/  \___/  \___/ /_/   \___/ /_/     \__,_/  \__/  /_/   \____/ /_/ /_/ 
 
 
	By Aritz Beobide-Cardinal (ARitz Cracker) && James R Swift (James xX)
 
--------------------------------------------------------------------------------------]]--
util.AddNetworkString("car_pitcontrol_angle")
util.AddNetworkString("car_pitcontrol_pos")
util.AddNetworkString("car_pitcontrol_save")
net.Receive("car_pitcontrol_angle",function(msglen,ply)
	local ent = Car.GetPitstop(ply)
	if IsValid(ent) then
		ent:SetLifterAngles(net.ReadAngle())
	end
end)
net.Receive("car_pitcontrol_pos",function(msglen,ply)
	local ent = Car.GetPitstop(ply)
	if IsValid(ent) then
		ent:SetLifterPos(ent:OBBCenter()-Vector(0,0,math.Clamp(net.ReadUInt(8),0,156)))
	end
end)
