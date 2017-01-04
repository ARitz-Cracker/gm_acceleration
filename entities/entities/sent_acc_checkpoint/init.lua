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
	self:SetMoveType( MOVETYPE_VPHYSICS ) --MOVETYPE_NONE?
	self:SetSolid( SOLID_VPHYSICS )
	
	self.Counterpart = self.Counterpart or NULL
	self.CheckpointID = self.CheckpointID or -1
	
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
		return ang <= 0
	else
		return ang > 0
	end
end

function ENT:Think()
	if self.IsSlave or not IsValid(self.Counterpart) then return end
	for k, Pl in pairs( player.GetAll() ) do
		if ( Pl.IsRacing and Pl.NextCheckpoint == self.CheckpointID ) then
		
			local res1 = self:CheckPlayerPassed( Pl )
			local res2 = self.Counterpart:CheckPlayerPassed( Pl )
			-- They must be called like this since if it were in an if statement and the master check evaluated to false, the salve wouldn't even be considered.
			MsgN(tostring(res1).." "..tostring(res2))
			if res1 and res2 then
				self:OnCheckpoint( Pl )
			end
		end
	end
end

function ENT:SetSlave( bIsSlave )
	self.IsSlave = bIsSlave
	self:SetNWBool( "IsSlave", bIsSlave )
end

function ENT:SetCounterpart( eCounterpart )
	if eCounterpart != NULL and eCounterpart:GetClass() != "sent_acc_checkpoint" then return end
	self.Counterpart = eCounterpart
	self:SetNWEntity( "Counterpart", eCounterpart)
end

function ENT:SetCheckpointID( iCheckpointID )
	self.CheckpointID = iCheckpointID
	self:SetNWInt( "CheckpointID", iCheckpointID)
end

function ENT:OnCheckpoint( Pl )

	hook.Run( "AccelerationPlayerCheckpointPassed", Pl, self.CheckpointID )

	self:EmitSound("buttons/blip1.wav")

end

function ENT:CheckPlayerPassed( Pl )

	local ang = self:WorldToLocalAngles( ( Pl:GetPos()-self:GetPos() ):Angle() ).y
	if math.abs(ang) < 90 then
		self.PlayerAnglesTable[ Pl ] = nil
		return false
	end
	local passed = false
	if self.PlayerAnglesTable[ Pl ] then
		if self:CompareAng( ang, not self.IsSlave ) and self:CompareAng( self.PlayerAnglesTable[ Pl ], self.IsSlave ) then
			passed = true
		end
	end
	self.PlayerAnglesTable[ Pl ] = ang
	return passed
end