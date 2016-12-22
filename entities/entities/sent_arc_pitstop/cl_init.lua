
include('shared.lua')
local forceFieldTexture = Material("effects/combineshield/comshieldwall2")
function ENT:Initialize()
	self.Models = {}
	self.LastPos = vector_origin
	self:UpdatePoints()
	self.Barrier = true
	net.Start("car_pit_enable")
	net.WriteEntity(self)
	net.SendToServer()
end

function ENT:UpdatePoints()
	for k,v in ipairs(self.Models) do
		v:Remove()
	end

	self.Points = {}
	local mins = self:OBBMins()--+self.AddMins
	local maxs = self:OBBMaxs()--+self.AddMaxs
	self:SetRenderBounds( mins, maxs)
	local back_left_down = self:LocalToWorld(mins)
	local back_right_down = self:LocalToWorld(Vector(mins.x,maxs.y,mins.z))
	local front_left_down = self:LocalToWorld(Vector(maxs.x,mins.y,mins.z))
	local front_right_down = self:LocalToWorld(Vector(maxs.x,maxs.y,mins.z))
	
	local back_left_up = self:LocalToWorld(Vector(mins.x,mins.y,maxs.z))
	local back_right_up = self:LocalToWorld(Vector(mins.x,maxs.y,maxs.z))
	local front_left_up = self:LocalToWorld(Vector(maxs.x,mins.y,maxs.z))
	local front_right_up = self:LocalToWorld(maxs)
	
	local i = 1
	self.Points[i] = {front_left_up,front_right_up,front_right_down,front_left_down}
	i = i + 1
	self.Points[i] = {front_right_up,back_right_up,back_right_down,front_right_down}
	i = i + 1
	self.Points[i] = {back_right_up,back_left_up,back_left_down,back_right_down}
	i = i + 1
	self.Points[i] = {back_left_up,front_left_up,front_left_down,back_left_down}
	
	for ii=1,4 do
		local t = table.Reverse(self.Points[ii])
		--table.remove(t,1)
		--table.insert(t,color_white)
		self.Points[i+ii] = t
	end
	
	i = 1
	self.Models[i] = ClientsideModel("models/props_combine/combine_fence01a.mdl", RENDERGROUP_TRANSLUCENT )
	self.Models[i]:SetPos(front_right_down+Vector(0,0,38))
	self.Models[i]:SetAngles(self:GetAngles())
	--self.Models[i]:SetParent(self)
	self.Models[i]:SetNoDraw(false)
	self.Models[i]:DrawShadow( true ) 
	i = i + 1
	self.Models[i] = ClientsideModel("models/props_combine/combine_fence01b.mdl", RENDERGROUP_TRANSLUCENT )
	self.Models[i]:SetPos(front_right_down+Vector(0,0,320))
	self.Models[i]:SetAngles(self:GetAngles()+Angle(0,0,180))
	--self.Models[i]:SetParent(self)
	self.Models[i]:SetNoDraw(false)
	self.Models[i]:DrawShadow( true )
	i = i + 1
	self.Models[i] = ClientsideModel("models/props_combine/combine_fence01b.mdl", RENDERGROUP_TRANSLUCENT )
	self.Models[i]:SetPos(front_right_down+Vector(0,0,38))
	self.Models[i]:SetAngles(self:GetAngles()+Angle(0,90,0))
	--self.Models[i]:SetParent(self)
	self.Models[i]:SetNoDraw(false)
	self.Models[i]:DrawShadow( true ) 
	i = i + 1
	self.Models[i] = ClientsideModel("models/props_combine/combine_fence01a.mdl", RENDERGROUP_TRANSLUCENT )
	self.Models[i]:SetPos(front_right_down+Vector(0,0,320))
	self.Models[i]:SetAngles(self:GetAngles()+Angle(0,90,180))
	--self.Models[i]:SetParent(self)
	self.Models[i]:SetNoDraw(false)
	self.Models[i]:DrawShadow( true )
	
	i = i + 1
	self.Models[i] = ClientsideModel("models/props_combine/combine_fence01a.mdl", RENDERGROUP_TRANSLUCENT )
	self.Models[i]:SetPos(back_left_down+Vector(0,0,38))
	self.Models[i]:SetAngles(self:GetAngles()+Angle(0,180,0))
	--self.Models[i]:SetParent(self)
	self.Models[i]:SetNoDraw(false)
	self.Models[i]:DrawShadow( true ) 
	i = i + 1
	self.Models[i] = ClientsideModel("models/props_combine/combine_fence01b.mdl", RENDERGROUP_TRANSLUCENT )
	self.Models[i]:SetPos(back_left_down+Vector(0,0,320))
	self.Models[i]:SetAngles(self:GetAngles()+Angle(0,180,180))
	--self.Models[i]:SetParent(self)
	self.Models[i]:SetNoDraw(false)
	self.Models[i]:DrawShadow( true )
	i = i + 1
	self.Models[i] = ClientsideModel("models/props_combine/combine_fence01b.mdl", RENDERGROUP_TRANSLUCENT )
	self.Models[i]:SetPos(back_left_down+Vector(0,0,38))
	self.Models[i]:SetAngles(self:GetAngles()+Angle(0,270,0))
	--self.Models[i]:SetParent(self)
	self.Models[i]:SetNoDraw(false)
	self.Models[i]:DrawShadow( true ) 
	i = i + 1
	self.Models[i] = ClientsideModel("models/props_combine/combine_fence01a.mdl", RENDERGROUP_TRANSLUCENT )
	self.Models[i]:SetPos(back_left_down+Vector(0,0,320))
	self.Models[i]:SetAngles(self:GetAngles()+Angle(0,270,180))
	--self.Models[i]:SetParent(self)
	self.Models[i]:SetNoDraw(false)
	self.Models[i]:DrawShadow( true )
	
	i = i + 1
	self.Models[i] = ClientsideModel("models/props_combine/combine_fence01a.mdl", RENDERGROUP_TRANSLUCENT )
	self.Models[i]:SetPos(back_right_down+Vector(0,0,38))
	self.Models[i]:SetAngles(self:GetAngles()+Angle(0,90,0))
	--self.Models[i]:SetParent(self)
	self.Models[i]:SetNoDraw(false)
	self.Models[i]:DrawShadow( true ) 
	i = i + 1
	self.Models[i] = ClientsideModel("models/props_combine/combine_fence01b.mdl", RENDERGROUP_TRANSLUCENT )
	self.Models[i]:SetPos(back_right_down+Vector(0,0,320))
	self.Models[i]:SetAngles(self:GetAngles()+Angle(0,90,180))
	--self.Models[i]:SetParent(self)
	self.Models[i]:SetNoDraw(false)
	self.Models[i]:DrawShadow( true )
	i = i + 1
	self.Models[i] = ClientsideModel("models/props_combine/combine_fence01b.mdl", RENDERGROUP_TRANSLUCENT )
	self.Models[i]:SetPos(back_right_down+Vector(0,0,38))
	self.Models[i]:SetAngles(self:GetAngles()+Angle(0,180,0))
	--self.Models[i]:SetParent(self)
	self.Models[i]:SetNoDraw(false)
	self.Models[i]:DrawShadow( true ) 
	i = i + 1
	self.Models[i] = ClientsideModel("models/props_combine/combine_fence01a.mdl", RENDERGROUP_TRANSLUCENT )
	self.Models[i]:SetPos(back_right_down+Vector(0,0,320))
	self.Models[i]:SetAngles(self:GetAngles()+Angle(0,180,180))
	--self.Models[i]:SetParent(self)
	self.Models[i]:SetNoDraw(false)
	self.Models[i]:DrawShadow( true )
	
	i = i + 1
	self.Models[i] = ClientsideModel("models/props_combine/combine_fence01a.mdl", RENDERGROUP_TRANSLUCENT )
	self.Models[i]:SetPos(front_left_down+Vector(0,0,38))
	self.Models[i]:SetAngles(self:GetAngles()+Angle(0,270,0))
	--self.Models[i]:SetParent(self)
	self.Models[i]:SetNoDraw(false)
	self.Models[i]:DrawShadow( true ) 
	i = i + 1
	self.Models[i] = ClientsideModel("models/props_combine/combine_fence01b.mdl", RENDERGROUP_TRANSLUCENT )
	self.Models[i]:SetPos(front_left_down+Vector(0,0,320))
	self.Models[i]:SetAngles(self:GetAngles()+Angle(0,270,180))
	--self.Models[i]:SetParent(self)
	self.Models[i]:SetNoDraw(false)
	self.Models[i]:DrawShadow( true )
	i = i + 1
	self.Models[i] = ClientsideModel("models/props_combine/combine_fence01b.mdl", RENDERGROUP_TRANSLUCENT )
	self.Models[i]:SetPos(front_left_down+Vector(0,0,38))
	self.Models[i]:SetAngles(self:GetAngles()+Angle(0,0,0))
	--self.Models[i]:SetParent(self)
	self.Models[i]:SetNoDraw(false)
	self.Models[i]:DrawShadow( true ) 
	i = i + 1
	self.Models[i] = ClientsideModel("models/props_combine/combine_fence01a.mdl", RENDERGROUP_TRANSLUCENT )
	self.Models[i]:SetPos(front_left_down+Vector(0,0,320))
	self.Models[i]:SetAngles(self:GetAngles()+Angle(0,0,180))
	--self.Models[i]:SetParent(self)
	self.Models[i]:SetNoDraw(false)
	self.Models[i]:DrawShadow( true )

end

function ENT:EnableBarrier(doit)
	for k,v in ipairs(self.Models) do
		if doit then
			v:SetSkin(0)
		else
			v:SetSkin(1)
		end
	end
	self.Barrier = doit
end

function ENT:Think()
	local pos = self:GetPos()
	if ((self.LastPos - pos)!=vector_origin) then
		self:UpdatePoints()
	end
	
	self.LastPos = pos
end

function ENT:OnRemove()
	for k,v in ipairs(self.Models) do
		v:Remove()
	end
end

function ENT:Draw()
	--self:UpdatePoints() -- TODO: Only update points if entity has been moved
	--self:DrawModel()
	lifter = self:GetLifter()
	if IsValid(lifter) then
		local linepoint = lifter:GetPos() + lifter:GetAngles():Forward()*100
		local linepoint2 = lifter:GetPos() + lifter:GetAngles():Forward()*70 + lifter:GetAngles():Right()*10
		local linepoint3 = lifter:GetPos() + lifter:GetAngles():Forward()*70 + lifter:GetAngles():Right()*-10
		render.DrawLine( lifter:GetPos(), linepoint, color_red, true )
		render.DrawLine( linepoint, linepoint2, color_red, true )	
		render.DrawLine( linepoint, linepoint3, color_red, true )			
		render.DrawWireframeBox( lifter:GetPos(),lifter:GetAngles(), Car.LifterCarMins, Car.LifterCarMaxs, color_red, true ) 
	end
end
local color_red = Color(255,0,0,255)
function ENT:DrawTranslucent()
	if not self.Barrier then return end
	render.SetMaterial( forceFieldTexture )
	for k,v in ipairs(self.Points) do
		mesh.Begin( MATERIAL_QUADS, 1 )
		mesh.TexCoord( 0, 8, 6 ) 
		
		mesh.Position( v[1] ) -- Set the position
		mesh.TexCoord( 0, 0, 0 ) -- Set the texture UV coordinates
		mesh.AdvanceVertex() -- Write the vertex
			
		mesh.Position( v[2] ) -- Set the position
		mesh.TexCoord( 0, 8, 0 ) -- Set the texture UV coordinates
		mesh.AdvanceVertex() -- Write the vertex
		
		mesh.Position( v[3] ) -- Set the position
		mesh.TexCoord( 0, 8, 6 ) -- Set the texture UV coordinates
		mesh.AdvanceVertex() -- Write the vertex
		
		mesh.Position( v[4] ) -- Set the position
		mesh.TexCoord( 0, 0, 6 ) -- Set the texture UV coordinates
		mesh.AdvanceVertex() -- Write the vertex
		
		mesh.End() -- Finish writing the mesh and draw it
	end

end

net.Receive("car_pit_enable",function()
	local ent = net.ReadEntity()
	ent:UpdatePoints()
	if IsValid(ent) then
		ent:EnableBarrier(net.ReadBool())
	end
end)
