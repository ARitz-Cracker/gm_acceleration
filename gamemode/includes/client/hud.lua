local transformationIcons = {}
transformationIcons[1] = surface.GetTextureID( "gm_acceleration/hud/logo_all" ) 
transformationIcons[2] = surface.GetTextureID( "gm_acceleration/hud/logo_build" ) 
transformationIcons[3] = surface.GetTextureID( "gm_acceleration/hud/logo_drive" ) 
transformationIcons[4] = surface.GetTextureID( "gm_acceleration/hud/logo_fly" )
Car.Transform = 0
local textColor = Color(255,255,255,255)
local outlineColor = Color(0,0,0,255)
hook.Add("HUDPaint", "Acceleration", function()
	if !LocalPlayer() then return end
	if Car.Transform > 0 and Car.Transform < 5 then
		local halfScrH = ScrH()/2
		local halfScrW = ScrW()/2
		local mul = math.sin(SysTime()*math.pi*4)
		local size = mul*50 + 462

		textColor.a = (mul*55)+200
		outlineColor.a = textColor.a
		surface.SetDrawColor(textColor)
		surface.SetTexture(transformationIcons[Car.Transform])
		surface.DrawTexturedRectRotated( halfScrW, halfScrH-40, size, size, math.sin(SysTime()*math.pi*2)*5 ) 
		draw.SimpleTextOutlined( Car.Msgs.HudMsg.Transform, "AccelerationBig", halfScrW, halfScrH + 210, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, outlineColor ) 
	end
end)
--[[
hook.Add("HUDShouldDraw", "hidehud", function(name) --Stops certian elements of the default hud. Such as, health and ammo
	for _, v in pairs{"CHudHealth", "CHudBattery" ,"CHudAmmo", "CHudSecondaryAmmo"} do
		if name == v then return false end
	end
end)
]]