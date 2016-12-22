
EFFECT.Mat = Material( "effects/wheel_ring_nodir" )

function EFFECT:Init( data )
	self.Wheel = data:GetEntity()

	if ( !IsValid( self.Wheel ) ) then return end
	self.Pos = data:GetOrigin()
	self.Ang = data:GetAngles()
	self.Axis = data:GetNormal()
	self.Dir = data:GetScale()
	
	
	self.Maxs = (self.Wheel:OBBMaxs()-self.Wheel:OBBMins())*0.5
	self.Mins = -self.Maxs
	self:SetCollisionBounds( self.Mins, self.Maxs )

end

function EFFECT:Think()

	if ( !IsValid( self.Wheel ) ) then return false end

	local speed = FrameTime()

	self.Alpha = self.Alpha - speed * 0.8
	self.Size = self.Size + speed * 5

	if ( self.Alpha < 0 ) then return false end

	return true

end

function EFFECT:Render()

	if ( !IsValid( self.Wheel ) ) then return end
	if ( self.Alpha < 0 ) then return end

	render.SetMaterial( self.Mat )

	local Normal = self.Wheel:LocalToWorld( self.Axis ) - self.Wheel:GetPos()

	render.DrawQuadEasy( self.Wheel:GetPos() + Normal,
						 Normal:GetNormalized(),
						 self.Size, self.Size,
						 Color( 255, 255, 255, ( self.Alpha ^ 1.1 ) * 255 ),
						 0)

end
