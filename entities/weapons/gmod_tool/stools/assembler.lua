
TOOL.Category = "Acceleration"
TOOL.Name = "#tool.assembler.name"

--TOOL.ClientConVar[ "snappos" ] = "20"
--GetConVar( string name ) 

TOOL.Information = {
	{ name = "left", stage = 0 },
	{ name = "right", stage = 0 },
	{ name = "reload" }
}

function TOOL:LeftClick( trace )
	if ( not IsValid( trace.Entity ) ) then return false end
	return true

end

function TOOL:RightClick( trace )
	if ( not IsValid( trace.Entity ) ) then return false end
	return true
end

function TOOL:Think()

end

function TOOL:Reload( trace )
	if not CLIENT then return false end
	return false
end


function TOOL:Holster()

end

function TOOL:Deploy()

end

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl( "Header", { Description = "#tool.assembler.help" } )
end
