--[[--------------------------------------------------------------------------------------
 _______                     ______                      _____ _____                
 ___    |___________________ ___  /_____ ______________ ___  /____(_)______ _______ 
 __  /| |_  ___/_  ___/_  _ \__  / _  _ \__  ___/_  __ `/_  __/__  / _  __ \__  __ \
 _  ___ |/ /__  / /__  /  __/_  /  /  __/_  /    / /_/ / / /_  _  /  / /_/ /_  / / /
 /_/  |_|\___/  \___/  \___/ /_/   \___/ /_/     \__,_/  \__/  /_/   \____/ /_/ /_/ 
 
 
	By Aritz Beobide-Cardinal (ARitz Cracker) && James R Swift (James xX)
 
--------------------------------------------------------------------------------------]]--

-- This entity is takes a LOT of inspiration from the polyweld tool. (Not that I couldn't do it myself, ofc. But I'm on a deadline)
-- Shoutout to Sir Haza and Bobblehead!!

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

util.AddNetworkString( "car_car_looks" )
ARCLib.RegisterBigMessage("car_car_looks_dl",16384,128,true) 
function ENT:Initialize()
	
	if self.MeshCount > 200 then --I picked a number out of my ass, tbh
		ARCLib.NotifyPlayer(ply,Car.Msgs.PitstopMsgs.TooComplex, NOTIFY_ERROR, 10,true)
		self:Remove()
		return
	elseif not self.Props or not self.Mesh or #self.Mesh == 0 then
		print("NOOU!")
		self:Remove()
		return
	elseif not IsValid(self:GetDriver()) then
		print("DRIVER IS INVALID!")
		self:Remove()
		return
	end
	local ply = self:GetDriver()
	local lifter = Car.GetPitstop(ply).Lifter
	
	
	for k,v in ipairs(self.Props) do
		v.Ent:Remove()
		v.Ent = nil
	end
	self.Props[#self.Props+1] = self:EntIndex()
	self.PropString = util.TableToJSON( self.Props ) -- TODO: Create LuaSCON and use that instead of shitty JSON
	table.remove(self.Props)

	self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	local phys = self:GetPhysicsObject()
		
	if(phys:IsValid()) then
		self:PhysicsDestroy()
		self:PhysicsInitMultiConvex(self.Mesh)
		self:EnableCustomCollisions(true)		
	end
	phys = self:GetPhysicsObject() --Get new mesh physobj.
	if phys:IsValid() then
		phys:EnableDrag(true)
		phys:SetMass(self.Mass)
		phys:SetMaterial("metal")
		phys:EnableMotion(false)
	end
	
	for k,v in ipairs(self.Wheels) do
		v.Ent:SetParent()
		v.Ent:SetCollisionGroup( COLLISION_GROUP_NONE )
		--constraint.NoCollide( self, v.Ent, 0, 0 ) 
		constraint.Weld( self, v.Ent, 0, 0, 0, true, false ) -- TODO: Suspension
		--v.Ent:EnableSki()
		v.Ent:SetCar(self)
	end
	for k,v in ipairs(self.Seats) do
		v.Ent:SetParent()
		v.Ent:SetCollisionGroup( COLLISION_GROUP_NONE )
		--constraint.NoCollide( self, v.Ent, 0, 0 ) 
		constraint.Weld( self, v.Ent, 0, 0, 0, true, false ) -- Should I parent the seat to the car instead of welding it?
	end
	self.Seats[1].Ent.AccelerationCar = self
	if IsValid(lifter) then
		lifter:Remove()
	end
end

net.Receive("car_car_looks",function(len,ply)
	local ent = net.ReadEntity()
	if IsValid(ent) and ent:GetClass() == "sent_arc_car" then
		ARCLib.SendBigMessage("car_car_looks_dl",ent.PropString,ply,NULLFUNC) -- TODO: Get errors and report them/do something when a client couldn't get the properties
	end
end)

function ENT:SetProperties(props)
	self.MeshCount = 0
	self.Mesh = self.Mesh or {}
	self.Mass = self.Mass or 0
	for k,v in ipairs(props["prop_physics"]) do
		local ent = v.Ent
		
		local delta = ent:GetPos() - self:GetPos()
		local phys = ent:GetPhysicsObject()
		
		if( phys:IsValid() ) then
			
			local angle = phys:GetAngles()
			local convexes = phys:GetMeshConvexes()
			self.MeshCount = self.MeshCount + #convexes
			for _,convex in pairs(convexes) do
				local entmesh = {}
				for _, point in ipairs(convex) do
					point.pos:Rotate(angle)
					point.pos = point.pos + delta
					table.insert(entmesh,point.pos)
					
				end
				table.insert(self.Mesh,entmesh)
			end
			self.Mass = self.Mass + phys:GetMass()
		end
	end
	self.Seats = props["prop_vehicle_prisoner_pod"]
	self.Wheels = props["sent_arc_wheel"]
	self.WheelForce = self.CarForce / #self.Wheels -- TODO: Front/back wheel drive options instead of AWD.
	
	self.Props = props["prop_physics"]
end

--START CAR LOGIC
ENT.CarForce = 100
ENT.MaxSpeed = 1500 -- In inches per second

local car_keys = { -- HAHA PUNS ;)))))
	[IN_FORWARD] = true,
	[IN_MOVELEFT] = true,
	[IN_BACK] = true,
	[IN_MOVERIGHT] = true,
	[IN_ATTACK] = true,
	[IN_ATTACK2] = true,
	[IN_RELOAD] = true,
	[IN_JUMP] = true,
	[IN_SPEED] = true,
	[IN_ZOOM] = true,
	[IN_WALK] = true,
	[IN_LEFT] = true,
	[IN_RIGHT] = true,
}
Car.DefaultCarData = function()
	local CarData = {}
	CarData.SoundGears = 5
	CarData.SoundCurrentGear = 0

	CarData.SoundStart = "vehicles/v8/v8_start_loop1.wav"
	CarData.SoundStartPitch = 100

	CarData.SoundIdle = "vehicles/v8/v8_idle_loop1.wav"
	CarData.SoundIdlePitch = 100

	CarData.SoundAccelerate = "vehicles/v8/v8_firstgear_rev_loop1.wav" --"vehicles/v8/fourth_cruise_loop2.wav" --"vehicles/v8/v8_firstgear_rev_loop1.wav"
	CarData.SoundAcceleratePitchStart = 80
	CarData.SoundAcceleratePitchEnd = 135

	CarData.SoundBoost = "vehicles/v8/v8_turbo_on_loop1.wav"
	CarData.SoundBoostPitchStart = 80
	CarData.SoundBoostPitchEnd = 120

	CarData.SoundDecelerateFast = "vehicles/v8/v8_throttle_off_fast_loop1.wav"
	CarData.SoundDecelerateMedium = "vehicles/v8/v8_throttle_off_slow_loop2.wav"
	CarData.SoundDecelerateSlow = "vehicles/v8/v8_rev_short_loop1.wav"
	CarData.SoundDeceleratePitchStart = 120
	CarData.SoundDeceleratePitchEnd = 95

	CarData.SoundStop = "vehicles/v8/v8_stop1.wav"
	CarData.SoundStopPitch = 100
	return CarData
end

ENT.CarData = Car.DefaultCarData()

hook.Add( "KeyPress", "Acceleration CarPress", function( ply, key )
	if (not car_keys[key]) then return end
	local car = ply:GetVehicle().AccelerationCar
	if IsValid(car) then
		car:KeyPress(key)
	end
end)

hook.Add( "KeyRelease", "Acceleration CarRelease", function( ply, key )
	if (not car_keys[key]) then return end
	local car = ply:GetVehicle().AccelerationCar
	if IsValid(car) then
		car:KeyRelease(key)
	end
end)
hook.Add( "PlayerEnteredVehicle", "Acceleration CarEnter", function( ply, veh, role )
	local car = veh.AccelerationCar
	if IsValid(car) then
		car:EnableCar()
	end
end)
hook.Add( "PlayerLeaveVehicle", "Acceleration CarEnter", function( ply, veh, role )
	local car = veh.AccelerationCar
	if IsValid(car) then
		car:DisableCar()
	end
end)

function ENT:KeyPress(key)
	self.CarForce = 10000
	self.WheelForce = self.CarForce / #self.Wheels
	if key == IN_FORWARD then
		if self.CSoundDecelerate then
			self.CSoundDecelerate:FadeOut(0.3)
		end
		if self.CSoundIdle then
			self.CSoundIdle:FadeOut(0.3)
		end
		if self.CSoundAccelerate and self.CSoundAccelerate:IsPlaying() and self:GetVelocity():Length() > 250 then
			self.CSoundAccelerate:ChangeVolume( 1, 0.1 ) 
		else
			if self.CSoundAccelerate then
				self.CSoundAccelerate:Stop()
			end
			self.CSoundAccelerate = CreateSound(self,self.CarData.SoundAccelerate)
			self.CSoundAccelerate:PlayEx( 1, self.CarData.SoundAcceleratePitchStart )
		end
	
		for k,v in ipairs(self.Wheels) do
			v.Ent:SetForce(self.WheelForce)
		end
		self.SAccelerate = true
		
	elseif key == IN_JUMP then
		for k,v in ipairs(self.Wheels) do
			v.Ent:DisableSki()
		end
	elseif key == IN_MOVELEFT then
		for k,v in ipairs(self.Wheels) do
			v.Ent:SetSteerAngle(-30)
		end
	elseif key == IN_MOVERIGHT then
		for k,v in ipairs(self.Wheels) do
			v.Ent:SetSteerAngle(30)
		end
	end
end
function ENT:KeyRelease(key)
	if key == IN_FORWARD then
		if self.CSoundAccelerate then
			self.CSoundAccelerate:ChangeVolume( 0, 0.5 ) 
		end
		if self.CSoundIdle then
			self.CSoundIdle:FadeOut(0.1)
		end
		if self.CSoundDecelerate then
			self.CSoundDecelerate:Stop()
		end
		local speeds = self.MaxSpeed / 3
		local speed = self:GetVelocity():Length()
		
		if speed >= speeds*2 then
			self.CSoundDecelerate = CreateSound(self,self.CarData.SoundDecelerateFast)
		elseif speed >= speeds*0.5 then
			self.CSoundDecelerate = CreateSound(self,self.CarData.SoundDecelerateMedium)
		else
			self.CSoundDecelerate = CreateSound(self,self.CarData.SoundDecelerateSlow)
		end
		
		self.CSoundDecelerate:PlayEx( 1, self.CarData.SoundDeceleratePitchStart + (((speed/self.MaxSpeed)*-1) + 1)*(self.CarData.SoundDeceleratePitchEnd-self.CarData.SoundDeceleratePitchStart) )
		-- 
		
		for k,v in ipairs(self.Wheels) do
			v.Ent:SetForce(0)
		end
		self.SAccelerate = false
	elseif key == IN_JUMP then
		for k,v in ipairs(self.Wheels) do
			v.Ent:EnableSki()
		end
	elseif key == IN_MOVELEFT then
		for k,v in ipairs(self.Wheels) do
			v.Ent:SetSteerAngle(0)
		end
	elseif key == IN_MOVERIGHT then
		for k,v in ipairs(self.Wheels) do
			v.Ent:SetSteerAngle(0)
		end
	end
end

function ENT:EnableCar()
	self.EngineOn = true
	self.CSoundIdle = CreateSound(self,self.CarData.SoundStart)
	self.CSoundIdle:PlayEx( 1, self.CarData.SoundStartPitch )
	for k,v in ipairs(self.Wheels) do
		v.Ent:EnableSki()
	end
end

function ENT:DisableCar()
	for k,v in pairs(car_keys) do
		self:KeyRelease(k)
	end
	for k,v in ipairs(self.Wheels) do
		v.Ent:DisableSki()
	end
	self.EngineOn = false
	self.CSoundIdle:Stop()
	if self.CSoundAccelerate then
		self.CSoundAccelerate:Stop()
	end
	if self.CSoundBoost then
		self.CSoundBoost:Stop()
	end
	if self.CSoundDecelerate then
		self.CSoundDecelerate:Stop()
	end
	
	self:EmitSound( self.CarData.SoundStop, 72, self.CarData.SoundStopPitch)
end

function ENT:Think()
	if self.EngineOn then
		local speed = self:GetVelocity():Length()
		if self.SAccelerate then
			local maxGearSpeed = self.MaxSpeed/self.CarData.SoundGears
			self.CSoundAccelerate:ChangePitch( self.CarData.SoundAcceleratePitchStart + (speed%(maxGearSpeed))/maxGearSpeed*(self.CarData.SoundAcceleratePitchEnd-self.CarData.SoundAcceleratePitchStart), 0.3 ) 
		else
			if speed > 120 then
				self.CSoundDecelerate:ChangePitch( self.CarData.SoundDeceleratePitchStart + (((speed/self.MaxSpeed)*-1) + 1)*(self.CarData.SoundDeceleratePitchEnd-self.CarData.SoundDeceleratePitchStart), 0.3 )
			elseif not self.CSoundIdle:IsPlaying() then
				self.CSoundDecelerate:FadeOut(0.4)
				self.CSoundIdle = CreateSound(self,self.CarData.SoundIdle)
				self.CSoundIdle:PlayEx( 1, self.CarData.SoundIdlePitch )
			end
		end
	end
end

function ENT:PhysicsCollide( data, phys )

end

function ENT:OnRemove()
	if self.CSoundIdle then
		self.CSoundIdle:Stop()
	end
	if self.CSoundAccelerate then
		self.CSoundAccelerate:Stop()
	end
	if self.CSoundBoost then
		self.CSoundBoost:Stop()
	end
	if self.CSoundDecelerate then
		self.CSoundDecelerate:Stop()
	end
	for k,v in ipairs(self.Wheels) do
		v.Ent:Remove()
	end
	for k,v in ipairs(self.Seats) do
		v.Ent:Remove()
	end
end

function ENT:Use(activator, caller, type, value)
	activator:EnterVehicle( self.Seats[1].Ent )
end
