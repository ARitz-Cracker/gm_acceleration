
function EFFECT:Init( data )
    self.Position = data:GetOrigin() 
	self.Col = team.GetColor( data:GetColor())	
end


function EFFECT:Think( )
    return false  
end
local parttble = {}
function EFFECT:Render()
	parttble = {}
    self.emitter = ParticleEmitter( self.Position )
    for i=1, 20 do
		local vec = Vector(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1))
		vec:Normalize()    
		if !self.emitter then return end
			parttble[i] = self.emitter:Add( "arc_lasertag/tracer1", self.Position)
			parttble[i]:SetGravity(Vector(0,0,-600)) 
			parttble[i]:SetCollide( true ) 
			parttble[i]:SetBounce(0.25) 
			parttble[i]:SetAirResistance( 0.5) 
            parttble[i]:SetVelocity( vec * math.random(175,225) )
			parttble[i]:SetRoll(math.Rand(50,100)) 
			parttble[i]:SetRollDelta(math.Rand( -1000, 1000 ))
            parttble[i]:SetDieTime(math.Rand(1,4))
            parttble[i]:SetStartAlpha(200)
            parttble[i]:SetEndAlpha(0)
            parttble[i]:SetStartSize(math.Rand(2, 3))
            parttble[i]:SetEndSize( math.random() )
            --particle:SetRoll( math.Rand( -10,10  ) )
            --particle:SetRollDelta(math.Rand( -2, 2 ))
            parttble[i]:SetColor( math.Clamp(self.Col.r+math.random(-125,125),0,255), math.Clamp(self.Col.g+math.random(-125,125),0,255), math.Clamp(self.Col.b+math.random(-125,125),0,255))            
    end
    for i=1, 50 do
		local vec = Vector(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1))
		vec:Normalize()    
		if !self.emitter then return end
			parttble[i+20] = self.emitter:Add( "arc_lasertag/tracer1", self.Position)
			parttble[i+20]:SetGravity(Vector(0,0,10))
			parttble[i+20]:SetAirResistance( math.random(300,600)) 
			parttble[i+20]:SetBounce(0.25) 
            parttble[i+20]:SetVelocity( vec * math.random(900,1200) )
			parttble[i+20]:SetRoll(math.Rand(50,100))
			parttble[i+20]:SetRollDelta(math.Rand( -75, 75 ))			
            parttble[i+20]:SetDieTime(math.Rand(0.5,2))
            parttble[i+20]:SetStartAlpha(200)
            parttble[i+20]:SetEndAlpha(0)
            parttble[i+20]:SetStartSize(math.Rand(3, 6))
            parttble[i+20]:SetEndSize( math.Rand(0,2) )
            --particle:SetRoll( math.Rand( -10,10  ) )
            --particle:SetRollDelta(math.Rand( -2, 2 ))
            parttble[i+20]:SetColor( math.Clamp(self.Col.r+math.random(-125,125),0,255), math.Clamp(self.Col.g+math.random(-125,125),0,255), math.Clamp(self.Col.b+math.random(-125,125),0,255))            
    end
	self.emitter:Finish()   
end
