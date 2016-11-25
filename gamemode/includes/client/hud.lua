
hook.Add("HUDPaint", "Acceleration", function()
	if !LocalPlayer() then return end
	
end)
--[[
hook.Add("HUDShouldDraw", "hidehud", function(name) --Stops certian elements of the default hud. Such as, health and ammo
	for _, v in pairs{"CHudHealth", "CHudBattery" ,"CHudAmmo", "CHudSecondaryAmmo"} do
		if name == v then return false end
	end
end)
]]