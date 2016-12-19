--[[--------------------------------------------------------------------------------------
 _______                     ______                      _____ _____                
 ___    |___________________ ___  /_____ ______________ ___  /____(_)______ _______ 
 __  /| |_  ___/_  ___/_  _ \__  / _  _ \__  ___/_  __ `/_  __/__  / _  __ \__  __ \
 _  ___ |/ /__  / /__  /  __/_  /  /  __/_  /    / /_/ / / /_  _  /  / /_/ /_  / / /
 /_/  |_|\___/  \___/  \___/ /_/   \___/ /_/     \__,_/  \__/  /_/   \____/ /_/ /_/ 
 
 
	By Aritz Beobide-Cardinal (ARitz Cracker) && James R Swift (James xX)
 
--------------------------------------------------------------------------------------]]--

include('shared.lua')

function ENT:Initialize()
	self.CSModels = {}
	self.ModelPos = {}
	self.ModelAng = {}
	net.Start("car_car_looks")
	net.WriteEntity(self)
	net.SendToServer()
end

function ENT:Think()
	if not self.Drawing then
		self.UpdateModelPos = true
	end
	
	self.Drawing = false
end

function ENT:Draw()
	if self.UpdateModelPos then -- Shitty hack for when entity stops being in PVS
		for k,v in ipairs(self.CSModels) do
			v:SetPos(self:LocalToWorld(self.ModelPos[k]))
			v:SetAngles(self:LocalToWorldAngles(self.ModelAng[k]))
			v:SetParent(self)
		end
		self.UpdateModelPos = false
	end

	self.Drawing = true
	for k,v in ipairs(self.CSModels) do
		v:DrawModel()
	end
end
function ENT:DrawTranslucent()
end

function ENT:OnRemove()
	for k,v in ipairs(self.CSModels) do
		v:Remove()
	end
end

ARCLib.ReceiveBigMessage("car_car_looks_dl",function(err,per,data,ply)
	if err == ARCLib.NET_DOWNLOADING then
		print("Getting car properties...")
		print("Progress: "..math.floor(per*100).."%")
	elseif err == ARCLib.NET_COMPLETE then
		print(data)
		local tab = util.JSONToTable(data) -- LuaSCON HAS TO BE A THING SOON ;-;
		local ent = Entity(table.remove(tab))
		if not IsValid(ent) then return end
		ent.ModelPos = {}
		ent.ModelAng = {}
		ent.CSModels = {}
		ent.CSModelsi = 0
		for k,v in ipairs(tab) do
			local csmodel =  ClientsideModel(v.Mod, RENDERGROUP_OPAQUE )
			csmodel:SetPos(ent:LocalToWorld(v.Pos))
			csmodel:SetAngles(ent:LocalToWorldAngles(v.Ang))
			for kk,vv in ipairs(v.BG) do
				csmodel:SetBodygroup( unpack(vv))
			end
			if v.Mat then
				csmodel:SetMaterial(v.Mat)
			else
				csmodel:SetSkin(v.Skin)
			end
			csmodel:SetColor(v.Col)
			csmodel:SetParent(ent)
			--csmodel:SetNoDraw(true)
			csmodel:DrawShadow(true)
			ent.CSModelsi = ent.CSModelsi + 1
			ent.ModelPos[ent.CSModelsi] = v.Pos
			ent.ModelAng[ent.CSModelsi] = v.Ang
			ent.CSModels[ent.CSModelsi] = csmodel
		end
	else
		print("Car properties message errored! "..err)
	end
end)
