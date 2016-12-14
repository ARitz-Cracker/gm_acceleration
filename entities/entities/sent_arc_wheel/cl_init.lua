
include('shared.lua')
function ENT:Initialize()
	self.Collisions = {}
	self.AdjustedSpeed = Vector(0,0,0)
	net.Start("car_wheel_axis")
	net.WriteEntity(self)
	net.SendToServer()
	self.LastPos = self:GetPos()
	self.SkiWheel = ClientsideModel(self:GetModel(), RENDER_GROUP_VIEW_MODEL_OPAQUE)
	self.SkiWheel:SetPos(self:GetPos())
	self.SkiWheel:SetAngles(self:GetAngles())
	self.SkiWheel:SetParent(self)
	self.SkiWheel:SetNoDraw(true)
end

function ENT:Think()

end
color_red = Color(255,0,0,255)
color_green = Color(0,255,0,255)
color_blue = Color(0,0,255,255)

function ENT:Draw()
	if not self.Enabled then
		self:DrawModel()
		return
	end
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
	self.SkiWheel:DrawModel()
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
	if ent.Enabled then
		ent.SkiWheel:SetPos(ent:GetPos())
		ent.SkiWheel:SetAngles(ent:GetAngles())
		ent.SkiWheel:SetParent(ent)
	end
end)


