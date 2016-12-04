-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2015-2016 Aritz Beobide-Cardinal All rights reserved.

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
ENT.ARitzDDProtected = true

util.AddNetworkString("car_wheel_axis")
function ENT:Initialize()
	self:SetModel( "models/xeon133/racewheelskinny/race-wheel-40_s.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self.phys = self:GetPhysicsObject()
	if self.phys:IsValid() then
		self.phys:Wake()
		self.phys:SetMaterial( "gmod_ice" ) 
	end
	--self:SetUseType(SIMPLE_USE)
	--self:SetTrigger( true ) 
	self.CollidePositions = {}
	if !self.WheelAxis then
		self:SetWheelAxis("y")
	end
	self.Direction = 1
	self.Speed = vector_origin
end
net.Receive("car_wheel_axis",function(msglen,ply)
	local ent = net.ReadEntity()
	net.Start("car_wheel_axis")
	net.WriteEntity(ent)
	net.WriteUInt(string.byte(ent.WheelAxis or "w") - 119,2)
	net.Send(ply)
end)
function ENT:SetWheelAxis(axis)
	if not self.SpeedVectorCutSettings[axis] then
		error("sent_arc_wheel.SetWheelAxis: invalid axis "..tostring(axis))
	end
	self.WheelCutAxis = self.SpeedVectorCutSettings[axis]
	self.WheelMoveAxis = self.SpeedVectorMoveSettings[axis]
	net.Start("car_wheel_axis")
	net.WriteEntity(self)
	net.WriteUInt(string.byte(axis) - 119,2)
	net.Broadcast()
	self.WheelAxis = axis
end
function ENT:SpawnFunction( ply, tr )
 	if ( !tr.Hit ) then return end
	local blarg = ents.Create ("sent_arc_wheel")
	blarg:SetPos(tr.HitPos + tr.HitNormal * 40)
	blarg:Spawn()
	blarg:Activate()
	return blarg
end

function ENT:Think()
	local selfpos = self:GetPos()
	local edited = false
	for k,v in pairs(self.CollidePositions) do
		if IsValid(k) or k:IsWorld() then
			--v.HitPos-v.OurPos
			local tablen = #v
			for i=tablen,1,-1 do
				local trace = {}
				trace.start = selfpos
				trace.endpos = self:LocalToWorld( v[i]*1.3 )
				trace.filter = self
				local tr = util.TraceLine( trace )
				if !tr.Hit or tr.Entity != k then
					table.remove(v,i)
					if #v == 0 then
						self.CollidePositions[k] = nil
					end
					edited = true
				end
			end
		else
			self.CollidePositions[k] = nil
			edited = true
		end
	end
end

function ENT:CalculateAverageHitPos(tab)
	local tablen = #tab
	local averagePosition = vector_origin
	for i=1,tablen do
		averagePosition = averagePosition + tab[i]
	end
	tablen = tablen + 1
	tab[tablen] = averagePosition
end
function ENT:GetPointVelocity(pos)
	local phys = self:GetPhysicsObject()
	local angVel = phys:GetAngleVelocity() 
	return Vector(math.rad(angVel.x),math.rad(angVel.y),math.rad(angVel.z)):Cross( pos - phys:LocalToWorld(phys:GetMassCenter()) ) + phys:GetVelocity()
end


function ENT:PhysicsCollide( data, phys )
	local pos = self:WorldToLocal(data.HitPos)
	if not self.CollidePositions[data.HitEntity] then
		self.CollidePositions[data.HitEntity] = {pos,pos}
	else
		local tab = self.CollidePositions[data.HitEntity]
		local addToEnd = true
		for i=1,#tab-1 do
			if tab[i]:IsEqualTol( pos, 10 ) then
				tab[i] = pos
				addToEnd = false
				break
			end
		end
		if addToEnd then
			tab[#tab] = pos
		end
	end
	
end
function ENT:OnRemove()

end
function ENT:CollidePointAmount()
	local i = 0
	for k,v in pairs(self.CollidePositions) do
		i = i + #v
	end
	return i
end
function ENT:SetForce(speed)
	if speed == 0 then
		self.Speed = vector_origin
	else
		self.Speed = Vector(speed,speed,speed)*self.WheelCutAxis
	end
end

function ENT:PhysicsUpdate( phys )
	local wheelForce
	if self.Speed != vector_origin then
		wheelForce = self.phys:LocalToWorldVector(Vector(0,300,0)*self.Direction)
	end
	local len = self:CollidePointAmount()
	for k,v in pairs(self.CollidePositions) do
		for i=1,#v do
			local hitPoint = self:LocalToWorld( v[i] )
			local isolatedSpeed = self.phys:LocalToWorldVector(self.phys:WorldToLocalVector(self:GetPointVelocity(hitPoint))*self.WheelCutAxis)
			if isolatedSpeed:LengthSqr() > 0.2 then
				phys:ApplyForceOffset( phys:GetMass() * isolatedSpeed*-0.4/len, hitPoint )
			end
			if wheelForce then
				local speed = wheelForce:Cross( hitPoint - phys:LocalToWorld(phys:GetMassCenter()) )
				phys:ApplyForceOffset( speed/len, hitPoint )
			end
		end
	end
end

function ENT:Use(activator, caller, type, value)
	self.Direction = self.Direction * -1
	self:DoDirectionEffect()
end

function ENT:DoDirectionEffect() -- Copied from gmod_wheel
	local effectdata = EffectData()

		effectdata:SetOrigin( (self:OBBMaxs()-self:OBBMins())*self.WheelCutAxis*0.55 )
		effectdata:SetEntity( self.Entity )
		effectdata:SetScale( self.Direction )

	util.Effect( "wheel_indicator", effectdata, true, true )

end
