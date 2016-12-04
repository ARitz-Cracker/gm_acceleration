
TOOL.Category = "Acceleration"
TOOL.Name = "#tool.snappy.name"

TOOL.ClientConVar[ "snappos" ] = "30"
TOOL.ClientConVar[ "snapang" ] = "20"

TOOL.Information = {
	{ name = "left", stage = 0 },
	{ name = "right", stage = 0 },
	{ name = "reload" }
}

function TOOL:CreateGhostProp(ent)
	MsgN(ent)
	self.CSProp = ClientsideModel(ent:GetModel(), RENDERMODE_TRANSALPHA)
	self.CSProp:SetPos(vector_origin)
	self.CSProp:SetAngles(angle_zero)
	self.CSProp:SetNoDraw(false)
	self.CSProp:DrawShadow( true )
	self.CSProp:SetSkin(ent:GetSkin())
	local mats = ent:GetMaterials()
	local mat = ent:GetMaterial() 
	if mat == "" then
		for i=1,#mats do
			MsgN(mats[i])
			self.CSProp:SetSubMaterial( i-1, mats[i] ) 
		end
	else
		self.CSProp:SetMaterial( mat ) 
	end
	local col = ent:GetColor()
	col.a = col.a * 0.5
	MsgN(col.a)
	self.CSProp:SetColor( col ) 
	self.CSProp:SetRenderMode( RENDERMODE_TRANSALPHA )
end

function TOOL:LeftClick( trace )
	if ( not IsValid( trace.Entity ) ) then return false end
	local ent = trace.Entity
	local entpos = ent:LocalToWorld(ent:OBBCenter())
	local entang = ent:GetAngles()

	local a = self:DoThePos(entpos)
	ent:SetAngles(self:DoTheAng(entang))
	ent:SetPos(a)
	ent:SetPos(ent:LocalToWorld(ent:OBBCenter()*-1))
	return true

end

function TOOL:RightClick( trace )
	if ( not IsValid( trace.Entity ) ) then return false end

	return true
end
function TOOL:DoThePos(entpos)
	local snapp = self:GetClientNumber( "snappos" )
	return Vector(math.Round(entpos.x/snapp)*snapp,math.Round(entpos.y/snapp)*snapp,math.Round(entpos.z/snapp)*snapp)
end
function TOOL:DoTheAng(entang)
	local snapa = self:GetClientNumber( "snapang" )
	return Angle(math.Round(entang.p/snapa)*snapa,math.Round(entang.y/snapa)*snapa,math.Round(entang.r/snapa)*snapa)
end
function TOOL:Think()
	if not CLIENT then return end
	local ent = LocalPlayer():GetEyeTrace().Entity
	if IsValid(self.CSProp) then
		if IsValid(ent) and ent:GetModel() == self.CSProp:GetModel() then
			local entpos = ent:LocalToWorld(ent:OBBCenter())
			local entang = ent:GetAngles()

			local a = self:DoThePos(entpos)
			self.CSProp:SetAngles(self:DoTheAng(entang)) -- Creating shit every frame! Giving the GC a run for its money!!!11
			self.CSProp:SetPos(a)
			self.CSProp:SetPos(self.CSProp:LocalToWorld(ent:OBBCenter()*-1))
		else
			self.CSProp:Remove()
		end
	elseif IsValid(ent) then
		
		self:CreateGhostProp(ent)
	end

end

function TOOL:Reload( trace )
	return false
end


function TOOL:Holster()
	if IsValid(self.CSProp) then
		self.CSProp:Remove()
	end
end

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl( "Header", { Description = "#tool.snappy.help" } )
	CPanel:AddControl( "Slider", { Label = "#tool.snappy", Command = "snappy_snappos", Type = "Float", Min = 15, Max = 90, Help = true } )
	CPanel:AddControl( "Slider", { Label = "#tool.snappy", Command = "snappy_snapang", Type = "Float", Min = 10, Max = 100, Help = true } )
end
