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
	end
	
	for k,v in ipairs(self.Wheels) do
		v.Ent:SetParent()
		constraint.Weld( self, v.Ent, 0, 0, 0, true, false )
		--v.Ent:EnableSki()
	end
	for k,v in ipairs(self.Seats) do
		v.Ent:SetParent()
		constraint.Weld( self, v.Ent, 0, 0, 0, true, false )
	end
	if IsValid(lifter) then
		lifter:Remove()
	end
end

net.Receive("car_car_looks",function(len,ply)
	local ent = net.ReadEntity()
	if IsValid(ent) and ent:GetClass() == "sent_arc_car" then
		ARCLib.SendBigMessage("car_car_looks_dl",ent.PropString,ply,NULLFUNC) -- TODO: Get errors and report them
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
	
	self.Props = props["prop_physics"]
end

function ENT:Think()

end

function ENT:PhysicsCollide( data, phys )

end

function ENT:OnRemove()

end

function ENT:Use(activator, caller, type, value)
	activator:EnterVehicle( self.Seats[1].Ent )
end
