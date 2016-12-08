--[[--------------------------------------------------------------------------------------
 _______                     ______                      _____ _____                
 ___    |___________________ ___  /_____ ______________ ___  /____(_)______ _______ 
 __  /| |_  ___/_  ___/_  _ \__  / _  _ \__  ___/_  __ `/_  __/__  / _  __ \__  __ \
 _  ___ |/ /__  / /__  /  __/_  /  /  __/_  /    / /_/ / / /_  _  /  / /_/ /_  / / /
 /_/  |_|\___/  \___/  \___/ /_/   \___/ /_/     \__,_/  \__/  /_/   \____/ /_/ /_/ 
 
 
	By Aritz Beobide-Cardinal (ARitz Cracker) && James R Swift (James xX)
 
--------------------------------------------------------------------------------------]]--


EFFECT.AttachmentName = "particle_attachment"
EFFECT.Mat = Material( "effects/spark" )

function EFFECT:Init( data )

	self.Checkpoint = data:GetEntity()
	if ( not IsValid( self.Checkpoint ) ) then return end
	
	self.AttachmentID = self.Checkpoint:LookupAttachment( self.AttachmentName )
	self.Attachment = self.Checkpoint:GetAttachment( self.AttachmentID )

	local size = 64
	self:SetCollisionBounds( Vector( -size, -size, 0 ), Vector( size, size, size ) )
	
	self:SetAngles( self.Attachment.Ang )
	self:SetPos( self.Attachment.Pos )
	self:SetParent( self.Checkpoint )
	
	self.StartPos = self.Attachment.Pos
	self.EndPos = self.Attachment.Pos + self.Attachment.Ang:Up() * size

end

function EFFECT:Think()

	if ( not IsValid( self.Checkpoint ) ) then return end

	return true

end

function EFFECT:Render()

	if ( not IsValid( self.Checkpoint ) ) then return end
	
	render.SetMaterial( self.Mat )

	render.DrawBeam( self.StartPos, self.EndPos, 16, 1, 0, Color( 0, 255, 0, 255 ) )
end