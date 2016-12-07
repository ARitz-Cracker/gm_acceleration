local PANEL = {}

function PANEL:Init()

	self.Material = nil
	self.AutoSize = false
	self.Angle = 0
	self:SetAlpha( 255 )

	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( false )

end

function PANEL:Paint()

	if (!self.Material) then return true end
	local w,h = self:GetSize()
	local x = w/2
	local y = h/2
	surface.SetMaterial( self.Material )
	surface.SetDrawColor( 255, 255, 255, self.Alpha )
	surface.DrawTexturedRectRotated( x, y, w, h, self.Angle ) 
	return true

end

function PANEL:OnMousePressed( keyCode )
	if keyCode == MOUSE_LEFT then
		self.Rotating = true
	end
	if keyCode == MOUSE_RIGHT then
		self.Angle = 0
		self:OnValueChanged(self.Angle)
	end
end

function PANEL:OnMouseReleased( keyCode )
	if keyCode == MOUSE_LEFT then
		self.Rotating = false
	end
end

function PANEL:SetValue( ang )
	self.Angle = tonumber(ang) or 0
end

function PANEL:GetValue( ang )
	return self.Angle
end

PANEL.OnValueChanged = NULLFUNC

function PANEL:Think( keyCode )
	if not self.Rotating then return end
	local w,h = self:GetSize()
	local x = w/2
	local y = h/2
	local xPos,yPos = self:LocalToScreen( x, y )
	local xMouse, yMouse = gui.MousePos()
	x = xMouse-xPos
	y = yMouse-yPos
	if (x < 0) then
		self.Angle = 180 + (math.atan(y / -x) * 180 / math.pi);
	else
		self.Angle = - (math.atan(y / x) * 180 / math.pi);
	end
	self:OnValueChanged(self.Angle)
end
vgui.Register( "AngleSelect", PANEL, "Material" )