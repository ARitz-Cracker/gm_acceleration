
TOOL.Category = "Acceleration"
TOOL.Name = "#tool.mover.name"

TOOL.ClientConVar[ "lifter" ] = "0"
TOOL.ClientConVar[ "movex" ] = "0"
TOOL.ClientConVar[ "movey" ] = "0"
TOOL.ClientConVar[ "movez" ] = "0"
TOOL.ClientConVar[ "moveang" ] = "20"
TOOL.ClientConVar[ "angaxis" ] = "1"
TOOL.ClientConVar[ "angcenter" ] = "1"
--GetConVar( string name ) 

TOOL.Information = {
	{ name = "left", stage = 0 },
	{ name = "right", stage = 0 },
	{ name = "reload" }
}

function TOOL:LeftClick( trace )
	if ( not IsValid( trace.Entity ) ) then return false end
	-- TODO: MOVE
	return true
end

function TOOL:RightClick( trace )
	if ( not IsValid( trace.Entity ) ) then return false end
	-- TODO: ROTATE
	return true
end

function TOOL:Think()

end

function TOOL:Reload( trace )

	return false
end


function TOOL:Holster()

end

function TOOL:Deploy()

end

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl( "Header", { Description = "#tool.mover.help" } )
	CPanel:AddControl( "Slider", { Label = "#tool.mover.movex", Command = "mover_movex", Type = "Float", Min = -50, Max = 50, Help = false } )
	CPanel:AddControl( "Slider", { Label = "#tool.mover.movey", Command = "mover_movey", Type = "Float", Min = -50, Max = 50, Help = false } )
	CPanel:AddControl( "Slider", { Label = "#tool.mover.movez", Command = "mover_movez", Type = "Float", Min = -50, Max = 50, Help = false } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.mover.lifter", Command = "mover_lifter", Help = true } )

	CPanel:AddControl( "Slider", { Label = "#tool.mover.moveang", Command = "mover_moveang", Type = "Float", Min = -90, Max = 90, Help = true } )
	local listOptions = {}
	listOptions["#tool.mover.angaxis.setting1"] = {mover_angaxis=1} -- Prop Up
	listOptions["#tool.mover.angaxis.setting2"] = {mover_angaxis=2} -- Prop Right
	listOptions["#tool.mover.angaxis.setting3"] = {mover_angaxis=3} -- Prop Forward
	listOptions["#tool.mover.angaxis.setting4"] = {mover_angaxis=4} -- Lifter Up
	listOptions["#tool.mover.angaxis.setting5"] = {mover_angaxis=5} -- Lifter Right
	listOptions["#tool.mover.angaxis.setting6"] = {mover_angaxis=6} -- Lifter Forward
	listOptions["#tool.mover.angaxis.setting7"] = {mover_angaxis=7} -- trace.HitNormal
	CPanel:AddControl( "ListBox", { Label = "#tool.mover.angaxis", Options = listOptions } )
	local listOptions = {}
	listOptions["#tool.mover.angcenter.setting1"] = {mover_angcenter=1} -- Prop origin
	listOptions["#tool.mover.angcenter.setting2"] = {mover_angcenter=2} -- Prop center
	listOptions["#tool.mover.angcenter.setting3"] = {mover_angcenter=3} -- Lifter origin
	listOptions["#tool.mover.angcenter.setting4"] = {mover_angcenter=4} -- trace.HitPos
	CPanel:AddControl( "ListBox", { Label = "#tool.mover.angcenter", Options = listOptions, Help = true } )
end
