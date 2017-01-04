
TOOL.Category = "Acceleration"
TOOL.Name = "#tool.snappy.name"

TOOL.ClientConVar[ "snappos" ] = "20"
TOOL.ClientConVar[ "snapang" ] = "30"
TOOL.ClientConVar[ "lifter" ] = "1"
TOOL.ClientConVar[ "persist" ] = "0"
TOOL.ClientConVar[ "usex" ] = "0"
TOOL.ClientConVar[ "usey" ] = "0"
TOOL.ClientConVar[ "usez" ] = "0"
TOOL.ClientConVar[ "entity" ] = "-1"
--GetConVar( string name ) 

TOOL.Information = {
	{ name = "left", stage = 0 },
	{ name = "right", stage = 0 },
	{ name = "reload" }
}

function TOOL:LeftClick( trace )
	if ( not IsValid( trace.Entity ) ) then return false end
	local ent = trace.Entity
	local lifter
	if self:GetClientNumber( "lifter" ) != 0 then
		local pit = Car.GetPitstop(self:GetOwner())
		if IsValid(pit) then
			lifter = pit:GetLifter()
		end
	end
	Car.SnappySnap(ent, ent, self:GetClientNumber( "snappos" ), self:GetClientNumber( "snapang" ), Entity(self:GetClientNumber( "entity" )), self:GetClientNumber( "usex" ) != 0, self:GetClientNumber( "usey" ) != 0, self:GetClientNumber( "usez" ) != 0,lifter)
	return true

end

function TOOL:RightClick( trace )
	if ( not IsValid( trace.Entity ) ) then return false end
	if not CLIENT then return true end
	GetConVar( "snappy_entity" ):SetInt( trace.Entity:EntIndex() ) 
	notification.AddLegacy(ARCLib.PlaceholderReplace(Car.Msgs.tool.snappy.ent_selected,{ENT=tostring(trace.Entity)}),NOTIFY_GENERIC,10) 
	LocalPlayer():EmitSound("ambient/water/drip"..math.random(1, 4)..".wav" )
	return true
end

function TOOL:Think()

end

function TOOL:Reload( trace )
	if not CLIENT or not IsFirstTimePredicted() then return false end
	GetConVar( "snappy_entity" ):SetInt( -1 )
	notification.AddLegacy(Car.Msgs.tool.snappy.ent_reset,NOTIFY_GENERIC,10) 
	LocalPlayer():EmitSound("ambient/water/drip"..math.random(1, 4)..".wav" )
	return false
end


function TOOL:Holster()
	if SERVER then
		self:GetOwner():SendLua("Car.HoldingSnapTool = false") -- Yeah, I'm lazy sometimes. So what? ._. 
	end
end

function TOOL:Deploy()
	if SERVER then
		self:GetOwner():SendLua("Car.HoldingSnapTool = true")
	end
end

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl( "Header", { Description = "#tool.snappy.help" } )
	CPanel:AddControl( "Slider", { Label = "#tool.snappy.position", Command = "snappy_snappos", Type = "Float", Min = 5, Max = 90, Help = true } )
	CPanel:AddControl( "Slider", { Label = "#tool.snappy.angle", Command = "snappy_snapang", Type = "Float", Min = 15, Max = 90, Help = true } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.snappy.lifter", Command = "snappy_lifter", Help = true } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.snappy.persist", Command = "snappy_persist", Help = true } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.snappy.usex", Command = "snappy_usex", Help = true } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.snappy.usey", Command = "snappy_usey", Help = true } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.snappy.usez", Command = "snappy_usez", Help = true } )
end
