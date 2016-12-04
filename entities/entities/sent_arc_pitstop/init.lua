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

	self.Points = {}
	local mins = self:OBBMins()+self.AddMins
	local maxs = self:OBBMaxs()+self.AddMaxs
	local x0 = mins.x
	local y0 = mins.y
	local z0 = mins.z
	local x1 = maxs.x
	local y1 = maxs.y
	local z1 = maxs.z
	
	self:PhysicsInitMultiConvex( { {
		Vector( x1, y1, z1 ),
		Vector( x1, y1, z0 ),
		Vector( x0, y1, z0 ),
		Vector( x0, y1, z1 ),
		Vector( x1, y1+0.01, z1 ),
		Vector( x1, y1+0.01, z0 ),
		Vector( x0, y1+0.01, z0 ),
		Vector( x0, y1+0.01, z1 )
		},{
		Vector( x1, y0, z1 ),
		Vector( x1, y0, z0 ),
		Vector( x1, y1, z0 ),
		Vector( x1, y1, z1 ),
		Vector( x1+0.01, y0, z1 ),
		Vector( x1+0.01, y0, z0 ),
		Vector( x1+0.01, y1, z0 ),
		Vector( x1+0.01, y1, z1 )
		},{
		Vector( x0, y0, z1 ),
		Vector( x0, y0, z0 ),
		Vector( x1, y0, z0 ),
		Vector( x1, y0, z1 ),
		Vector( x0, y0-0.01, z1 ),
		Vector( x0, y0-0.01, z0 ),
		Vector( x1, y0-0.01, z0 ),
		Vector( x1, y0-0.01, z1 )
		},{
		Vector( x0, y0, z1 ),
		Vector( x0, y0, z0 ),
		Vector( x0, y1, z0 ),
		Vector( x0, y1, z1 ),
		Vector( x0-0.01, y0, z1 ),
		Vector( x0-0.01, y0, z0 ),
		Vector( x0-0.01, y1, z0 ),
		Vector( x0-0.01, y1, z1 )
		},{
		Vector( x0, y0, z1 ),
		Vector( x0, y1, z1 ),
		Vector( x1, y1, z1 ),
		Vector( x1, y0, z1 ),
		Vector( x0, y0, z1+0.01 ),
		Vector( x0, y1, z1+0.01 ),
		Vector( x1, y1, z1+0.01 ),
		Vector( x1, y0, z1+0.01 )
	} } )


	-- Set up solidity and movetype
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	-- Enable custom collisions on the entity
	self:EnableCustomCollisions( true )
	self:SetCustomCollisionCheck( true )
	self:SetUseType( SIMPLE_USE )
	self.phys = self:GetPhysicsObject()
	if self.phys:IsValid() then
		self.phys:Wake()
		self.phys:EnableMotion(false)
	end
	self.Barrier = true
	self.IsPitstop = true
	self.Whitelist = {}
end
hook.Add("ShouldCollide","Acceleration Forcefield",function(ent1,ent2)
	if ent1.IsPitstop then
		for k,v in pairs(ent1.Whitelist) do
			if not IsValid(k) then
				ent1.Whitelist[k] = nil
			end
		end
		if not ent1.Barrier or ent2 == ent1.Player or ent1.Whitelist[ent2] then
			return false
		else
			return true -- This is probably a bad idea. But nothing should come through the field anyway
		end
	end
	MsgN("ent1 = "..tostring(ent1))
	MsgN("ent2 = "..tostring(ent2))
end)
net.Receive("car_pit_enable",function(msglen,ply)
	local ent = net.ReadEntity()
	net.Start("car_pit_enable")
	net.WriteEntity(ent)
	net.WriteBool(ent.Barrier)
	net.WriteEntity(ent.Player)
	net.Send(ply)
end)
function ENT:SpawnFunction( ply, tr )
 	if ( !tr.Hit ) then return end
	local blarg = ents.Create ("sent_arc_pitstop")
	blarg:SetPos(tr.HitPos)
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
	net.WriteEntity(self.Player)
	net.Broadcast()
	self.Barrier = doit 
	self:CollisionRulesChanged()
	if doit then
		self:EmitSound("ambient/levels/outland/combineshieldactivate.wav")
	else
		self:EmitSound("ambient/levels/outland/combineshield_deactivate.wav")
	end
	--pitstop/impact.wav
end

function ENT:PhysicsCollide( data, phys )
	sound.Play( "pitstop/impact.wav", data.HitPos, 80, math.random(85,135), math.Clamp(data.Speed/1200,0,1))
end
function ENT:OnRemove()

end

function ENT:Use(activator, caller, type, value)

end
