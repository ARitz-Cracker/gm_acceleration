--[[--------------------------------------------------------------------------------------
 _______                     ______                      _____ _____                
 ___    |___________________ ___  /_____ ______________ ___  /____(_)______ _______ 
 __  /| |_  ___/_  ___/_  _ \__  / _  _ \__  ___/_  __ `/_  __/__  / _  __ \__  __ \
 _  ___ |/ /__  / /__  /  __/_  /  /  __/_  /    / /_/ / / /_  _  /  / /_/ /_  / / /
 /_/  |_|\___/  \___/  \___/ /_/   \___/ /_/     \__,_/  \__/  /_/   \____/ /_/ /_/ 
 
 
	By Aritz Beobide-Cardinal (ARitz Cracker) && James R Swift (James xX)
 
--------------------------------------------------------------------------------------]]--

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()

	self:SetModel( "models/props/acceleration/checkpoint.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	
	self.Counterpart = NULL
	self.CheckpointID = -1
	
	self.PlayerAnglesTable = {}
	
end

function ENT:SpawnFunction( ply, tr )

 	if ( !tr.Hit ) then return end
	local blarg = ents.Create ("sent_acc_checkpoint")
	blarg:SetPos(tr.HitPos)
	blarg:Spawn()
	blarg:Activate()
	return blarg
	
end

function ENT:CompareAng(ang,flip)
	if flip then
		return ang <= 90
	else
		return ang > 90
	end
end

function ENT:Think()
	
	for k, Pl in pairs( player.GetAll() ) do
	
		--if ( !Pl.IsRacing or Pl.NextCheckpoint ~= self.CheckpointID ) then continue end
		self:CheckPlayerPassed( Pl )
		
	end
	
end

function ENT:SetSlave( bIsSlave )
	self.IsSlave = bIsSlave
end

function ENT:SetCounterpart( eCounterpart )
	self.Counterpart = eCounterpart
end

function ENT:SetCheckpointID( iCheckpointID )
	self.CheckpointID = iCheckpointID
end

function ENT:OnCheckpoint( Pl )

	self:EmitSound("buttons/blip1.wav")

end

function ENT:CheckPlayerPassed( Pl )

	local ang = self:WorldToLocalAngles( ( Pl:GetPos()-self:GetPos() ):Angle() ).y
	
	if self.PlayerAnglesTable[ Pl ] then
		if self:CompareAng( ang, not self.IsSlave ) and self:CompareAng( self.PlayerAnglesTable[ Pl ], self.IsSlave ) then
			self:OnCheckpoint( Pl )
		end
	end
	
	self.PlayerAnglesTable[ Pl ] = ang

end