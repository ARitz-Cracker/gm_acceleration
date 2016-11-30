-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2015-2016 Aritz Beobide-Cardinal All rights reserved.

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
ENT.ARitzDDProtected = true

util.AddNetworkString("car_pit_enable")
function ENT:Initialize()
	self:SetModel( "models/hunter/plates/plate8x8.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self.phys = self:GetPhysicsObject()
	if self.phys:IsValid() then
		self.phys:Wake()
	end
	self.Barrier = true 
end
net.Receive("car_pit_enable",function(msglen,ply)
	local ent = net.ReadEntity()
	net.Start("car_pit_enable")
	net.WriteEntity(ent)
	net.WriteBool(ent.Barrier)
	net.Send(ply)
end)
function ENT:SpawnFunction( ply, tr )
 	if ( !tr.Hit ) then return end
	local blarg = ents.Create ("sent_arc_pitstop")
	blarg:SetPos(tr.HitPos + tr.HitNormal * 40)
	blarg:Spawn()
	blarg:Activate()
	blarg.Player = ply
	return blarg
end

function ENT:Think()
	if self.Player then
	
	end
end

function ENT:EnableBarrier(doit)
	net.Start("car_pit_enable")
	net.WriteEntity(self)
	net.WriteBool(doit)
	net.Broadcast()
	self.Barrier = doit 
end

function ENT:OnRemove()

end

function ENT:Use(activator, caller, type, value)

end
