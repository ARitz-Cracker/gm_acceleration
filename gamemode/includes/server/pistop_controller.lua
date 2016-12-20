--[[--------------------------------------------------------------------------------------
 _______                     ______                      _____ _____                
 ___    |___________________ ___  /_____ ______________ ___  /____(_)______ _______ 
 __  /| |_  ___/_  ___/_  _ \__  / _  _ \__  ___/_  __ `/_  __/__  / _  __ \__  __ \
 _  ___ |/ /__  / /__  /  __/_  /  /  __/_  /    / /_/ / / /_  _  /  / /_/ /_  / / /
 /_/  |_|\___/  \___/  \___/ /_/   \___/ /_/     \__,_/  \__/  /_/   \____/ /_/ /_/ 
 
 
	By Aritz Beobide-Cardinal (ARitz Cracker) && James R Swift (James xX)
 
--------------------------------------------------------------------------------------]]--
function Car.WithinLifter(lifter,ent)
	local points = ent:GetPhysicsObject():GetMeshConvexes()
	local within = true
	for i=1,#points do
		for ii=1,#points[i] do
			if not (lifter:WorldToLocal(ent:LocalToWorld(points[i][ii].pos)):WithinAABox( Car.LifterCarMins, Car.LifterCarMaxs ) ) then
				within = false
				break
			end
		end
		if not within then break end
	end
	return within
end

util.AddNetworkString("car_pitcontrol_angle")
util.AddNetworkString("car_pitcontrol_pos")
util.AddNetworkString("car_pitcontrol_save")
util.AddNetworkString("car_pitcontrol_deploy")
ARCLib.RegisterBigMessage("car_pitcontrol_save_dl",16384,255)
local function GetPropList(ent,ply)
	local lifter = Car.GetPitstop(ply).Lifter
	if not IsValid(lifter) then
		ARCLib.NotifyPlayer(ply,Car.Msgs.PitstopMsgs.NoBuild, NOTIFY_ERROR, 5,true)
		return
	end
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
local defaultStuff = {}
defaultStuff.number = 0
defaultStuff.string = ""
defaultStuff.boolean = false
local function CheckValidProps(ply)
	local lifter = Car.GetPitstop(ply).Lifter
	if not IsValid(lifter) then
		return
	end
	for k,v in ipairs(lifter:GetChildren()) do
		if not IsValid(v:GetPhysicsObject()) or not Car.WithinLifter(lifter,v) then
			v:Remove()
		end
	end
end

local function LoadPropList(properties,ply)
	local lifter = Car.GetPitstop(ply).Lifter
	if not IsValid(lifter) then
		ARCLib.NotifyPlayer(ply,Car.Msgs.PitstopMsgs.NoBuild, NOTIFY_ERROR, 5,true)
		return
	end
	if table.Count( properties ) != 4 then
		ARCLib.NotifyPlayer(ply,Car.Msgs.Generic.SaveBad, NOTIFY_ERROR, 5,true)
		return
	end
	if not properties._CarData then
		ARCLib.NotifyPlayer(ply,Car.Msgs.Generic.SaveBad, NOTIFY_ERROR, 5,true)
		return
	end
	if not properties.prop_vehicle_prisoner_pod then
		ARCLib.NotifyPlayer(ply,Car.Msgs.Generic.SaveBad, NOTIFY_ERROR, 5,true)
		return
	end
	if not properties.sent_arc_wheel then
		ARCLib.NotifyPlayer(ply,Car.Msgs.Generic.SaveBad, NOTIFY_ERROR, 5,true)
		return
	end
	if not properties.prop_physics then
		ARCLib.NotifyPlayer(ply,Car.Msgs.Generic.SaveBad, NOTIFY_ERROR, 5,true)
		return
	end
	local defaultdata = Car.DefaultCarData()
	for k,v in pairs(defaultdata) do
		local typ = type(v)
		properties._CarData[k] = _G["to"..typ](properties._CarData[k]) or defaultStuff[typ] -- That should stop client strangeness
	end
	
	
	lifter.CarData = properties._CarData
	properties._CarData = nil
	for class,v in pairs(properties) do -- TODO: Use this in an ARCLib multithink function to prevent server lag
		for i,a in ipairs(v) do
			a.Mod = tostring(a.Mod)
			if util.IsValidModel( a.Mod ) then
				local ent = ents.Create(class) -- Before you yell at me, consider that I checked table.Count earlier
				ent:SetModel(a.Mod)
				ent:SetPos(lifter:LocalToWorld(Vector( a.Pos ) ))
				ent:SetAngles(lifter:LocalToWorldAngles(Angle( a.Ang ) ))
				for kk,vv in ipairs(v.BG or {}) do
					ent:SetBodygroup( unpack(vv) ) -- TODO: Validate this shit
				end
				if isstring(a.Mat) then
					ent:SetMaterial(a.Mat)
				else
					ent:SetSkin(tonumber(a.Skin) or 0)
				end
				ent:SetColor(v.Col or color_white)
				ent:SetParent(lifter)
			else
				ARCLib.NotifyPlayer(ply,ARCLib.PlaceholderReplace(Car.Msgs.PitstopMsgs.ModelBad,{MODEL=a.Mod}), NOTIFY_ERROR, 6,true)
			end
		end
	end
	timer.Simple(0,function() CheckValidProps(ply) end)
end
ARCLib.ReceiveBigMessage("car_pitcontrol_save_dl",function(err,per,data,ply)
	if err == ARCLib.NET_DOWNLOADING then
		--chat.AddText( "Saving car... "..math.floor(per*100).."%" )
	elseif err == ARCLib.NET_COMPLETE then
		if savingFile then
			tab = util.JSONToTable(data)
			if tab then
				LoadPropList(tab,ply)
			else
				ARCLib.NotifyPlayer(ply,Car.Msgs.Generic.SaveBad, NOTIFY_ERROR, 5,true)
			end
		end
	else
		Car.Msg("Failed receiving car from "..tostring(ply))
	end
end)

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
net.Receive("car_pitcontrol_save",function(msglen,ply)
	local lifter = Car.GetPitstop(ply).Lifter
	if not IsValid(lifter) then
		ARCLib.NotifyPlayer(ply,Car.Msgs.PitstopMsgs.NoBuild, NOTIFY_ERROR, 5,true)
		return
	end
	local props = GetPropList(false,ply)
	props._CarData = lifter.CarData
	local data = util.TableToJSON(props)
	if #data > 16384*255 then
		ARCLib.NotifyPlayer(ply,"Your save file is too big! (4MB)", NOTIFY_ERROR, 5,true)
		return
	end
	ARCLib.SendBigMessage("car_pitcontrol_save_dl",data,ply,function(err,per)
		if err == ARCLib.NET_UPLOADING then
			Car.Msg("Sending car to "..tostring(ply).."... "..math.floor(per*100).."%")
		elseif err == ARCLib.NET_COMPLETE then
			Car.Msg("Sent car to "..tostring(ply))
		else
			Car.Msg("Sending car error! "..err.." "..tostring(ply))
		end
	end)
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
		ent.CarData = lifter.CarData
		ent:Spawn()
	end
end)
