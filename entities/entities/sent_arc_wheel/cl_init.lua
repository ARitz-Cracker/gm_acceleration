
include('shared.lua')
function ENT:Initialize()
	self.Collisions = {}
	self.AdjustedSpeed = Vector(0,0,0)
	net.Start("car_wheel_axis")
	net.WriteEntity(self)
	net.SendToServer()
	self.LastPos = self:GetPos()
	self.SkiWheel = ClientsideModel(self:GetModel(), RENDERGROUP_OPAQUE )
	self.SkiWheel:SetPos(self:GetPos())
	self.SkiWheel:SetAngles(self:GetAngles())
	self.SkiWheel:SetParent(self)
	self.SkiWheel:SetNoDraw(true)
	self.DebugTab = {}
end

function ENT:Think()
	if not self.Drawing then
		self.UpdateModelPos = true
	end
	self.Drawing = false
end
color_red = Color(255,0,0,255)
color_green = Color(0,255,0,255)
color_blue = Color(0,0,255,255)

function ENT:Draw()
	self.Drawing = true
	if self.UpdateModelPos then -- Shitty hack for when entity stops being in PVS
		self.SkiWheel:SetPos(self:GetPos())
		self.SkiWheel:SetAngles(self:GetAngles())
		self.SkiWheel:SetParent(self)
		self.UpdateModelPos = false
	end
	if self.Enabled then
		if !self.Circumference then return end
		--self.SkiWheel:SetPos(self:GetPos())
		local curpos = self:GetPos()
		local v = curpos - self.LastPos
		local l = self:WorldToLocalAngles(v:Angle()):Forward()*v:Length()*self.WheelMoveAxis
		--local v2 = self:LocalToWorldAngles(l:Angle()):Forward()*l:Length() --No need since I already got the length of the new vector
		self.LastPos = curpos
		local sign = -1
		if (l.x + l.y + l.z < 0) then
			sign = 1
		end
		local ang = self.SkiWheel:GetAngles()
		ang:RotateAroundAxis(ang:Right(), (l:Length()*sign/self.Circumference)*360)
		self.SkiWheel:SetAngles(ang)
	else
		self.LastPos = self:GetPos()
	end
	self.SkiWheel:DrawModel()
	--self:DrawModel()
	for k,v in pairs(self.DebugTab) do
		for kk,vv in ipairs(v) do
			render.DrawLine( self:GetPos(), self:LocalToWorld(vv + vv:GetNormalized()), color_red, false )
			render.DrawLine( self:GetPos(), self:LocalToWorld(vv), color_green, false )
			render.DrawLine( self:GetPos(), self:LocalToWorld(vv*self.WheelMoveAxis), color_blue, false )
			
		end
	end
end
function ENT:OnRemove()
	if self.SkiWheel then
		self.SkiWheel:Remove()
	end
end

net.Receive("car_wheel_axis",function()
	local ent = net.ReadEntity()
	local chr = net.ReadUInt(2)
	local axis = string.char( chr + 119 ) 
	local enabled = net.ReadBool()
	if !IsValid(ent) then return end
	ent.WheelCutAxis = ent.SpeedVectorCutSettings[axis]
	ent.WheelMoveAxis = ent.SpeedVectorMoveSettings[axis]
	local dia = chr - 1
	if dia == 0 then dia = 3 end
	ent.Circumference = (ent:OBBMaxs()-ent:OBBMins())[string.char( dia + 119 )]*math.pi
	ent.Enabled = enabled
end)
net.Receive("car_wheel_debug",function()
	local ent = net.ReadEntity()
	if !IsValid(ent) then return end
	ent.DebugTab = net.ReadTable()
end)


