
EFFECT.Mat = Material( "effects/wheel_ring_nodir" )

function EFFECT:Init( data )
	self.Wheel = data:GetEntity()

	if ( !IsValid( self.Wheel ) ) then return end
	--self.Pos = data:GetOrigin()
	--self.BaseAng = data:GetAngles()
	self.Axis = data:GetNormal()
	self.Dir = data:GetScale()
	
	self.Mul = 0
	self.Maxs = (self.Wheel:OBBMaxs()-self.Wheel:OBBMins())*0.5
	self.Mins = -self.Maxs
	self:SetCollisionBounds( self.Mins, self.Maxs )
	self.StartTime = CurTime()
	self.EndTime = CurTime() + 2
end

function EFFECT:Think()

	if ( !IsValid( self.Wheel ) ) then return false end
	if (self.EndTime < CurTime()) then return false end
	self.Mul = math.sin(ARCLib.BetweenNumberScale(self.StartTime,CurTime(),self.EndTime) * 2 * math.pi)
	self.Ang = self.Wheel:GetAngles()
	self.Ang:RotateAroundAxis(self.Axis,50*self.Mul*self.Dir)
	self.Pos = self.Wheel:LocalToWorld(self.Wheel:OBBCenter())
	self:SetPos(self.Pos)
	return true
end
local color_blue = Color(0,0,255,255)
function EFFECT:Render()

	if ( !IsValid( self.Wheel ) ) then return end
	if ( !self.Pos ) then return end
	render.DrawWireframeBox( self.Pos, self.Ang, self.Mins, self.Maxs, color_blue, false ) 
	if self.Mul < 0 then
		render.SetMaterial(ARCLib.GetWebIcon32("arrow_left"))
	else
		render.SetMaterial(ARCLib.GetWebIcon32("arrow_right"))
	end
	render.DrawSprite( self.Pos, 8, 8, color_white )
end
