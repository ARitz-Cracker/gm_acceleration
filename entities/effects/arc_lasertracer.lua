

EFFECT.Mat = Material( "arc_lasertag/tracer1" )
EFFECT.MatFade = Material( "arc_lasertag/tracer2" )
--[[---------------------------------------------------------
   Init( data table )
-----------------------------------------------------------]]
function EFFECT:Init( data )

	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	self.Col = team.GetColor( data:GetColor())
	-- Keep the start and end pos - we're going to interpolate between them
	if IsValid(self.WeaponEnt) then
		self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	else
		self.StartPos = self.Position
	end
	self.EndPos = data:GetOrigin()
	
	self.Alpha = 255
	self.Life = 0.0;

	self:SetRenderBoundsWS( self.StartPos, self.EndPos )

end

--[[---------------------------------------------------------
   THINK
-----------------------------------------------------------]]
function EFFECT:Think( )

	self.Life = self.Life + FrameTime() * 3;
	self.Alpha = 255 * ( 1 - self.Life )	
	
	return (self.Life < 1)

end

--[[---------------------------------------------------------
   Draw the effect
-----------------------------------------------------------]]
function EFFECT:Render( )

	if ( self.Alpha < 1 ) then return end
			
	render.SetMaterial( self.Mat )
	local texcoord = math.Rand( 0, 1 )
	
	local norm = (self.StartPos - self.EndPos) * self.Life

	self.Length = norm:Length()
	
	for i=1, 3 do		
		
		render.DrawBeam( self.StartPos - norm, 										-- Start
					 self.EndPos,											-- End
					 8,													-- Width
					 texcoord,														-- Start tex coord
					 texcoord + self.Length / 128,									-- End tex coord
					 Color( self.Col.r, self.Col.g, self.Col.b, 255 ) )		-- Color (optional)
	end
	render.SetMaterial( self.MatFade )
	render.DrawBeam( self.StartPos,
						self.EndPos,
						5,
						texcoord,
						texcoord + ((self.StartPos - self.EndPos):Length() / 128),
						Color( self.Col.r, self.Col.g, self.Col.b, 128 * ( 1 - self.Life ) )	)

end
