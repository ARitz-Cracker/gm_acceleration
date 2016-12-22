ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.PrintName		= "Garage"
ENT.Author			= "ARitz Cracker"
ENT.Category 		= "Acceleration"
ENT.Contact    		= ""
ENT.Purpose 		= ""
ENT.Instructions 	= ""
ENT.RenderGroup 	= RENDERGROUP_BOTH

ENT.Spawnable = true;
ENT.AdminOnly = false
ENT.CarFrozenEnt = true

ENT.AddMaxs = Vector(100,100,350)
ENT.AddMins = Vector(-100,-100,0)

function ENT:SetupDataTables()

	--self:NetworkVar( "Bool", 0, "Barrier" )
	self:NetworkVar( "Entity", 0, "Driver" )
	self:NetworkVar( "Entity", 1, "Lifter" )

end