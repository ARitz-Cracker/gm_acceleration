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
util.AddNetworkString("car_pitcontrol_deploy")
local function GetPropList(ent,ply)
	local lifter = Car.GetPitstop(ply).Lifter
	local properties = {}
	properties["prop_physics"] = {}
	properties["sent_arc_wheel"] = {}
	properties["prop_vehicle_prisoner_pod"] = {}
	for k,v in ipairs(lifter:GetChildren()) do
		local class = v:GetClass()
		if properties[class] then
			local a = {}
			if ent then
				a.Ent = v
			end
			a.Mod = v:GetModel()
			a.Pos = lifter:WorldToLocal(v:GetPos())
			a.Ang = lifter:WorldToLocalAngles(v:GetAngles())
			a.BG = {}
			local bglen = 0
			--if class == "prop_physics" then
			for kk,vv in ipairs(v:GetBodyGroups()) do
				bglen = bglen + 1
				a.BG[bglen] = {vv.id,v:GetBodygroup(vv.id)}
			end
			--end
			a.Mat = v:GetMaterial()
			if a.Mat == "" then
				a.Mat = nil
				a.Skin = v:GetSkin()
			end
			a.Col = v:GetColor() 
			--a.mat = 
			properties[class][#properties[class] + 1] = a
			--Use WorldToLocal relative to lifter for positions
		else
			ARCLib.NotifyPlayer(ply,"Invalid entity: "..tostring(v), NOTIFY_ERROR, 5,true)
		end
	end
	if #properties["prop_vehicle_prisoner_pod"] > 1 then
		ARCLib.NotifyPlayer(ply,"Bugs may occur if there's more than one seat. (Proper support for passengers will be added in the future)", NOTIFY_ERROR, 5,true)
	end
	if ent then
		if #properties["prop_vehicle_prisoner_pod"] == 0 then
			ARCLib.NotifyPlayer(ply,Car.Msgs.PitstopMsgs.NoSeat, NOTIFY_ERROR, 5,true)
			return
		end
		if #properties["sent_arc_wheel"] < 2 then
			ARCLib.NotifyPlayer(ply,Car.Msgs.PitstopMsgs.NoWheels, NOTIFY_ERROR, 5,true)
			return
		end
		if #properties["prop_physics"] < 1 then
			ARCLib.NotifyPlayer(ply,Car.Msgs.PitstopMsgs.NoProp, NOTIFY_ERROR, 5,true)
			return
		end
	end
	return properties
end

local function LoadPropList(properties,ply)

end


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

net.Receive("car_pitcontrol_deploy",function(len,ply)
	local lifter = Car.GetPitstop(ply).Lifter
	if not IsValid(lifter) then
		ARCLib.NotifyPlayer(ply,Car.Msgs.PitstopMsgs.NoBuild, NOTIFY_ERROR, 5,true)
		return
	end
	local props = GetPropList(true,ply)
	if props then
		local ent = ents.Create("sent_arc_car")
		ent:SetPos(lifter:GetPos())
		ent:SetAngles(lifter:GetAngles())
		ent:SetProperties(props)
		ent:SetDriver(ply)
		ent:Spawn()
	end
end)
