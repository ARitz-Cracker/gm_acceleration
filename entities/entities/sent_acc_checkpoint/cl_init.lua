--[[--------------------------------------------------------------------------------------
 _______                     ______                      _____ _____                
 ___    |___________________ ___  /_____ ______________ ___  /____(_)______ _______ 
 __  /| |_  ___/_  ___/_  _ \__  / _  _ \__  ___/_  __ `/_  __/__  / _  __ \__  __ \
 _  ___ |/ /__  / /__  /  __/_  /  /  __/_  /    / /_/ / / /_  _  /  / /_/ /_  / / /
 /_/  |_|\___/  \___/  \___/ /_/   \___/ /_/     \__,_/  \__/  /_/   \____/ /_/ /_/ 
 
 
	By Aritz Beobide-Cardinal (ARitz Cracker) && James R Swift (James xX)
 
--------------------------------------------------------------------------------------]]--

include('shared.lua')

function ENT:Initialize()

	local effectdata = EffectData()
	effectdata:SetEntity( self )

	util.Effect( "acc_checkpoint_pulse", effectdata )

end

function ENT:Think()

end

local color_blue = Color(0,0,255,255)
local color_red = Color(255,0,0,255)

function ENT:Draw()

	self:DrawModel()
	local ang = (LocalPlayer():GetPos()-self:GetPos()):Angle()
	render.DrawLine( self:GetPos(), self:GetPos() + ang:Forward()*10, color_white, false ) 
	render.DrawLine( self:GetPos(), self:GetPos() + self:LocalToWorldAngles( Angle(0,90,0) ):Forward()*10, color_blue, false ) 
	render.DrawLine( self:GetPos(), self:GetPos() + self:GetAngles():Forward()*10, color_red, false ) 
	
end

function ENT:OnRemove()

end
