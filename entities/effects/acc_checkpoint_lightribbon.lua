--[[--------------------------------------------------------------------------------------
 _______                     ______                      _____ _____                
 ___    |___________________ ___  /_____ ______________ ___  /____(_)______ _______ 
 __  /| |_  ___/_  ___/_  _ \__  / _  _ \__  ___/_  __ `/_  __/__  / _  __ \__  __ \
 _  ___ |/ /__  / /__  /  __/_  /  /  __/_  /    / /_/ / / /_  _  /  / /_/ /_  / / /
 /_/  |_|\___/  \___/  \___/ /_/   \___/ /_/     \__,_/  \__/  /_/   \____/ /_/ /_/ 
 
 
	By Aritz Beobide-Cardinal (ARitz Cracker) && James R Swift (James xX)
 
--------------------------------------------------------------------------------------]]--


EFFECT.AttachmentNameTop = "barriar_attachment_top"
EFFECT.AttachmentNameBot = "barriar_attachment_bot"
EFFECT.Mat = Material( "models/props/acceleration/checkpoint/CheckpointLight" )

function EFFECT:Init( data )

	self.Checkpoint = data:GetEntity()
	if ( not IsValid( self.Checkpoint ) ) then return end
	if ( self.Checkpoint.IsSlave ) then return end
	
	self.AttachmentID_top = self.Checkpoint:LookupAttachment( self.AttachmentNameTop )
	self.AttachmentID_bot = self.Checkpoint:LookupAttachment( self.AttachmentNameBot )
	
	self:SetPos( self.Checkpoint:GetPos() )

end

function EFFECT:UpdateVisLeaf( )

	self:SetCollisionBounds(
		self.Verts[1] - self.Checkpoint:GetPos(),
		self.Verts[3] - self.Checkpoint:GetPos()
	)

end

function EFFECT:Think()

	if ( not IsValid( self.Checkpoint ) ) then return end
	if ( self.Checkpoint.IsSlave ) then return false end
	
	if ( IsValid( self.Checkpoint:GetCounterpart()) ) then
	
		if ( not self.Verts ) then
		
			self.Verts = {
				self.Checkpoint:GetAttachment( self.AttachmentID_top ).Pos,
				self.Checkpoint:GetAttachment( self.AttachmentID_bot ).Pos,
				self.Checkpoint:GetCounterpart():GetAttachment( self.AttachmentID_bot ).Pos,
				self.Checkpoint:GetCounterpart():GetAttachment( self.AttachmentID_top ).Pos
			}
			
			self:UpdateVisLeaf( )
			
		end
		
	end

	return true

end

function EFFECT:Render()

	if ( not IsValid( self.Checkpoint ) ) then return end
	if ( not IsValid( self.Checkpoint:GetCounterpart() ) ) then return end
	
	render.SetMaterial( self.Mat )
	render.DrawQuad( self.Verts[1], self.Verts[2], self.Verts[3], self.Verts[4], Color( 255, 255, 255 ) )
	
end