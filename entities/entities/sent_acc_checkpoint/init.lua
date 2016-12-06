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

	self:SetModel( "models/props_trainstation/trainstation_post001.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	
end

function ENT:SpawnFunction( ply, tr )

 	if ( !tr.Hit ) then return end
	local blarg = ents.Create ("sent_acc_checkpoint")
	blarg:SetPos(tr.HitPos + tr.HitNormal * 40)
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
	local ang = self:WorldToLocalAngles((Entity(1):GetPos()-self:GetPos()):Angle()).y --TODO: Currently the checkpoints have infinite hight. Check if pitch < 0 to make sure people are not underneith? (That would also assume that the origin is at the bottom of the entity)
	if self.LastAng then
		if self:CompareAng(ang,not self.IsSlave) and self:CompareAng(self.LastAng,self.IsSlave) then
			self:EmitSound("buttons/blip1.wav")
		end
	end
	self.LastAng = ang
end

function ENT:OnRemove()

end

function ENT:Use(activator, caller, type, value)

end
