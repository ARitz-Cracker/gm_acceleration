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
	
	self.LifterPos = self:OBBCenter() - Vector(0,0,156)
	self.LifterAng = angle_zero
	self.LifterPosLast = self.LifterPos
	self.LifterAngLast = self.LifterAng
	self.LifterPosStart = 0
	self.LifterPosEnd = 0
	self.LifterAngStart = 0
	self.LifterAngEnd = 0
	self.Lifter = NULL
	
	self:CreateLifter()
	--ambient/machines/machine3.wav
	--vehicles/crane/crane_extend_stop.wav 
	
	--plats/crane/vertical_start.wav
	--plats/crane/vertical_stop.wav
	self:DrawShadow( false ) 
end
function ENT:CreateLifter()
	self.Lifter = ents.Create ("prop_physics")
	self.Lifter:SetPos(self:LocalToWorld(self.LifterPos))
	self.Lifter:SetAngles(self:LocalToWorldAngles(self.LifterAng))
	self.Lifter:SetModel("models/props_phx/construct/metal_plate1.mdl")
	self.Lifter:Spawn()
	self.Lifter:GetPhysicsObject():EnableMotion( false ) 
	self.Lifter:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self.Lifter:SetRenderMode(RENDERMODE_NONE)
	self.Lifter.CarFrozenEnt = true
	self.Lifter:DrawShadow( false ) 
	self.Lifter:SetSolid( SOLID_NONE ) 
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
end)
hook.Add("EntityRemoved","Acceleration Forcefield",function(ent)
	if ent.Car_FieldSound then
		ent.Car_FieldSound:Stop() 
	end
	ent.Car_FieldSound = nil
end)

net.Receive("car_pit_enable",function(msglen,ply)
	local ent = net.ReadEntity()
	net.Start("car_pit_enable")
	net.WriteEntity(ent)
	net.WriteBool(ent.Barrier)
	net.WriteEntity(ent.Player)
	net.WriteEntity(ent.Lifter)
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
	local changetime
	if IsValid(self.Lifter) then 
		if self.LifterAngEnd > CurTime() then
			local a = self:LocalToWorldAngles(LerpAngle( ARCLib.BetweenNumberScale(self.LifterAngStart,CurTime(),self.LifterAngEnd), self.LifterAngLast, self.LifterAng ))
			self.Lifter:SetAngles(a)
			self:NextThink(CurTime())
			changetime = true
		elseif (self.LifterAngSound) then
			self.Lifter:SetAngles(self:LocalToWorldAngles(self.LifterAng))
			self.LifterAngSound:Stop()
			self.LifterAngSound = nil
			self:EmitSound("vehicles/crane/crane_extend_stop.wav")
		end
		
		if self.LifterPosEnd > CurTime() then
			local a = self:LocalToWorld(LerpVector( ARCLib.BetweenNumberScale(self.LifterPosStart,CurTime(),self.LifterPosEnd), self.LifterPosLast, self.LifterPos ))
			self.Lifter:SetPos(a)
			self:NextThink(CurTime())
			changetime = true
		elseif (self.LifterPosSound) then
			self.Lifter:SetPos(self:LocalToWorld(self.LifterPos))
			self.LifterPosSound:Stop()
			self.LifterPosSound = nil
			self:EmitSound("plats/crane/vertical_stop.wav")
		end
	end
	return changetime
end

function ENT:SetLifterAngles(ang)
	if ang != self.LifterAng and IsValid(self.Lifter) then
		self.LifterAngLast = self:WorldToLocalAngles(self.Lifter:GetAngles())
		self.LifterAng = ang
		self.LifterAngStart = CurTime()
		self.LifterAngEnd = CurTime() + 0.2;
		self.LifterAngSound = CreateSound( self, "ambient/machines/machine3.wav")
		self.LifterAngSound:Play()
	end
end
function ENT:SetLifterPos(pos)
	if pos != self.LifterPos and IsValid(self.Lifter) then
		self.LifterPosLast = self:WorldToLocal(self.Lifter:GetPos())
		self.LifterPos = pos
		self.LifterPosStart = CurTime()
		self.LifterPosEnd = CurTime() + 0.2;
		self.LifterPosSound = CreateSound( self, "plats/crane/vertical_start.wav")
		self.LifterPosSound:Play()
	end
end


function ENT:EnableBarrier(doit)
	net.Start("car_pit_enable")
	net.WriteEntity(self)
	net.WriteBool(doit)
	net.WriteEntity(self.Player)
	net.WriteEntity(self.Lifter)
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
function ENT:StartTouch(ent)

	if not ent.Car_FieldSoundTime or ent.Car_FieldSoundTime <= SysTime() then
		if ent.Car_FieldSound then
			ent.Car_FieldSound:Stop()
		end
		ent.Car_FieldSound = CreateSound( ent, "ambient/machines/combine_shield_touch_loop1.wav")
		ent.Car_FieldSound:PlayEx( 0.3, 50 ) 	
		ent.Car_FieldSound:ChangePitch( 100, 0.2 ) 
	end
	if ent:IsPlayer() then
		ent.Car_FieldSoundTime = SysTime() + 0.25
	end
end

function ENT:EndTouch(ent)
	if ent.Car_FieldSound then
		if ent:IsPlayer() then
			timer.Simple(0.3,function()
				if ent.Car_FieldSoundTime <= SysTime() then
					ent.Car_FieldSound:ChangePitch( 45, 0.5 ) 
					ent.Car_FieldSound:FadeOut( 0.6 )
				end
			end)
		else
			ent.Car_FieldSound:ChangePitch( 45, 0.5 ) 
			ent.Car_FieldSound:FadeOut( 0.6 ) 
		end
	end
end

function ENT:OnRemove()
	if IsValid(self.Lifter) then
		self.Lifter:Remove()
	end
end

function ENT:Use(activator, caller, type, value)

end
