-- This file is under copyright, and is bound to the agreement stated in the EULA.
-- Any 3rd party content has been used as either public domain or with permission.
-- © Copyright 2015-2016 Aritz Beobide-Cardinal All rights reserved.

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
ENT.ARitzDDProtected = true

util.AddNetworkString("car_wheel_axis")
util.AddNetworkString("car_wheel_debug")
function ENT:Initialize()
	self:SetModel( "models/xeon133/racewheelskinny/race-wheel-40_s.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self.phys = self:GetPhysicsObject()
	if self.phys:IsValid() then
		self.phys:Wake()
		self.phys:SetMaterial( "jeeptire" ) 
	end
	self:SetUseType(ONOFF_USE)
	--self:SetTrigger( true ) 
	self.CollidePositions = {}
	if !self.WheelAxis then
		self:SetWheelAxis("y")
	end
	self.Direction = 1
	self.SteerDirection = 0
	self.Speed = vector_origin
	self.Car = NULL
	self.SteerAng = 0
	self:SetTrigger(true)
end

function ENT:GetCar()
	return self.Car
end

function ENT:SetCar(car)
	self.Car = car
	self.SteerAng = 0
end

function ENT:SetSteerAngle(ang)
	if not IsValid(self.Car) then return end
	ang = ang * self.SteerDirection
	if (ang == 0 and self.SteerAng == 0) then return end
	
	local diff = ang - self.SteerAng
	local angles = self:GetAngles()
	angles:RotateAroundAxis( self.Car:GetUp(), diff) 
	refpoint = ent:OBBCenter()
	local pos = self:LocalToWorld(refpoint)
	self:SetAngles(angles)
	self:SetPos(self:GetPos()+(pos-self:LocalToWorld(refpoint)))
	self.SteerAng = ang
end

function ENT:EnableSki()
	self.phys:SetMaterial( "friction_10" )
	
	--self.phys:SetMaterial( "car_tire" )
	self.LastPhysUpdate = CurTime()
	self.Enabled = true
	net.Start("car_wheel_axis")
	net.WriteEntity(self)
	net.WriteUInt(string.byte(self.WheelAxis or "w") - 119,2)
	net.WriteBool(self.Enabled)
	net.Broadcast()
end
function ENT:DisableSki()
	self.phys:SetMaterial( "jeeptire" ) 
	self.Enabled = false
	net.Start("car_wheel_axis")
	net.WriteEntity(self)
	net.WriteUInt(string.byte(self.WheelAxis or "w") - 119,2)
	net.WriteBool(self.Enabled)
	net.Broadcast()
end

net.Receive("car_wheel_axis",function(msglen,ply)
	local ent = net.ReadEntity()
	net.Start("car_wheel_axis")
	net.WriteEntity(ent)
	net.WriteUInt(string.byte(ent.WheelAxis or "w") - 119,2)
	net.WriteBool(ent.Enabled)
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
	net.WriteBool(self.Enabled)
	net.Broadcast()
	self.WheelAxis = axis
	
	local dia = string.byte(self.WheelAxis) - 1
	if dia == 119 then dia = 122 end
	self.Radius = (self:OBBMaxs()-self:OBBMins())[string.char( dia )]/2--*math.pi
end
function ENT:SpawnFunction( ply, tr )
 	if ( !tr.Hit ) then return end
	local blarg = ents.Create ("sent_arc_wheel")
	blarg:SetPos(tr.HitPos + tr.HitNormal * 40)
	blarg:Spawn()
	blarg:Activate()
	blarg.Ply = ply
	return blarg
end

function ENT:Think()
	--if not self.Enabled then return end
	local selfpos = self:GetPos()
	local edited = false
	for k,v in pairs(self.CollidePositions) do
		if IsValid(k) or k:IsWorld() then
			--v.HitPos-v.OurPos
			local tablen = #v
			for i=tablen,1,-1 do
				local remov = true
				local trace = {}
				--local norm = v[i]:GetNormalized()
				trace.start = selfpos
				trace.endpos = self:LocalToWorld( v[i]--[[+norm]] )
				trace.filter = self
				local tr = util.TraceLine( trace ) 
				remov = !tr.Hit or tr.Entity != k
				if !remov then
					-- TODO: Check if hitnormal is at the angle we want
					--local a = tr.HitNormal:Angle()-(norm*-1):Angle()
					--a:Normalize()
					--PrintMessage(HUD_PRINTTALK,tostring(a))
					--if math.abs(a.p) > 12 then -- TODO: THIS ONLY WORKS WITH Y AS THE AXIS AND WITH A SPECIFIC COLLISION MODEL!
						--PrintMessage(HUD_PRINTTALK,tostring(a.p))
						--remov = true
					--end
				end
				
				--[[
				if !remov then
					remov = tr.Fraction < 0.85
					if remov then
						MsgN(tr.Fraction)
					end
				end
				]]
				
				--Almost completly unreliable because of vPhysics shenanigans
				--[[
				if !remov then
					remov = (v[i]*self.WheelMoveAxis):LengthSqr() > (self.Radius+1) ^ 2
					if remov then
						MsgN(tostring((v[i]*self.WheelMoveAxis):LengthSqr()).." > "..tostring((self.Radius+1) ^ 2 ))
					end
				end
				]]
				
				if remov then
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
	
	
	net.Start("car_wheel_debug")
	net.WriteEntity(self)
	net.WriteTable(self.CollidePositions)
	net.Broadcast()
	
	

--	self:NextThink(CurTime())
--	return true
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
	local pos = self.phys:WorldToLocal(data.HitPos)--:Normalize()
	
	local pos2 = pos*self.WheelMoveAxis
	pos2:Normalize()
	local correctedPos = pos2*(self.Radius+1) + pos*self.WheelCutAxis
	
	
	if not self.CollidePositions[data.HitEntity] then
		self.CollidePositions[data.HitEntity] = {correctedPos}
	else
		local tab = self.CollidePositions[data.HitEntity]
		local addToEnd = true
		for i=1,#tab do
			if tab[i]:IsEqualTol( correctedPos, 2 ) then -- There has to be a better way to do this
				--tab[i] = correctedPos
				addToEnd = false
				break
			end
		end
		if addToEnd then
			tab[#tab+1] = correctedPos
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
		if self.phys:IsAsleep() then
			self.phys:Wake()
		end
		self.LastPhysUpdate = CurTime()
	end
end

function ENT:PhysicsUpdate( phys ) --MAYBE: use PhysicsSimulate instead??


	if not self.Enabled then return end
	self.Friction = 8
	local diff = CurTime() - self.LastPhysUpdate
	self.LastPhysUpdate = CurTime()
	local wheelForce
	if self.Speed != vector_origin then
		wheelForce = self.phys:LocalToWorldVector(self.Speed*self.Direction)
	end
	local len = self:CollidePointAmount()
	
	local avgHitPoint = vector_origin
	for k,v in pairs(self.CollidePositions) do
		for i=1,#v do
			local hitPoint = self:LocalToWorld( v[i] )
			avgHitPoint = avgHitPoint + hitPoint
			local isolatedSpeed = self.phys:LocalToWorldVector(self.phys:WorldToLocalVector(self:GetPointVelocity(hitPoint))*self.WheelCutAxis) -- TODO: Make this work with moving platforms
			if isolatedSpeed:LengthSqr() > 0.2 then
				phys:ApplyForceOffset( (phys:GetMass() * isolatedSpeed*-diff*self.Friction)/len, hitPoint )
			end
			--[
			if wheelForce then
				local speed = wheelForce:Cross( hitPoint - phys:LocalToWorld(phys:GetMassCenter()) )
				phys:ApplyForceOffset( speed/len*diff, hitPoint ) -- TODO: Change back to hitPoint once stability issues are resolved
			end
			--]]
		end
	end
	
	--Temporary "Fix" until above commented out code is fixed
	--[[
	avgHitPoint = avgHitPoint / len
	if wheelForce then
		local speed = wheelForce:Cross( avgHitPoint - phys:LocalToWorld(phys:GetMassCenter()) )
		phys:ApplyForceOffset( speed*diff, avgHitPoint )
	end
	]]
end

function ENT:Use(activator, caller, toggle, value)
	if activator != self.Ply then return end
	if toggle == 1 then
		self.UseStartTime = CurTime()
	else
		if not IsValid(Car.GetPitstop(activator).Lifter) then return end
			if CurTime() - self.UseStartTime < 0.5 then
			if math.abs(self:GetAngles().r) > 90 then
				local welds = {}
				for k,v in ipairs(constraint.GetTable(self)) do
					if v.Type == "Weld" then
						welds[#welds + 1] = {v.Ent1,v.Ent2,v.Bone1,v.Bone2,v.forcelimit,v.nocollide,false}
					end
				end
				constraint.RemoveConstraints( self, "Weld") 
				
				
				local ang = self:GetAngles()
				ang.r = ang.r + 180
				ang.y = ang.y + 180
				self:SetAngles(ang)
				for i=1,#welds do
					constraint.Weld(unpack(welds[i]))
				end
			end
			if self.Direction == 1 then
				self.Direction = -1
			elseif self.Direction == -1 then
				self.Direction = 0
			elseif self.Direction == 0 then
				self.Direction = 1
			end
			self:DoDirectionEffect()
		else
		
		end
	end
end

function ENT:DoDirectionEffect() -- Copied from gmod_wheel
	local effectdata = EffectData()

		effectdata:SetOrigin( (self:OBBMaxs()-self:OBBMins())*self.WheelCutAxis*0.55 )
		effectdata:SetEntity( self.Entity )
		effectdata:SetScale( self.Direction )
	if self.Direction == 0 then
		util.Effect( "wheel_indicator_nodir", effectdata, true, true )
	else
		util.Effect( "wheel_indicator", effectdata, true, true )
	end
end
