
SWEP.UseHands = true
SWEP.PrintName			= "Parachute"		-- 'Nice' Weapon name (Shown on HUD)	
SWEP.Category 			= "Acceleration"
SWEP.Slot				= 1						-- Slot in the weapon selection menu
SWEP.SlotPos			= 1					-- Position in the slot
SWEP.DrawAmmo			= false					-- Should draw the default HL2 ammo counter
SWEP.DrawCrosshair		= false 					-- Should draw the default crosshair
SWEP.DrawWeaponInfoBox	= true					-- Should draw the weapon info box
SWEP.BounceWeaponIcon   = true					-- Should the weapon icon bounce?
if CLIENT then
	SWEP.WepSelectIcon		= surface.GetTextureID( "weapons/swep" )
end
SWEP.Author			= "ARitz Cracker"
SWEP.Contact		= "aritz@aritzcracker.ca"
SWEP.Purpose		= "Parachute"
SWEP.Instructions	= "Fwaaah"

SWEP.ViewModelFOV	= 56
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_hands.mdl"
SWEP.WorldModel		= "models/weapons/w_pistol.mdl"

SWEP.Weight				= 8
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= true

SWEP.Spawnable			= true
SWEP.AdminOnly			= false

SWEP.Secondary.ClipSize		= -1				-- Size of a clip
SWEP.Secondary.DefaultClip	= -1				-- Default number of bullets in a clip
SWEP.Primary.Automatic		= false				-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1				-- Size of a clip
SWEP.Secondary.DefaultClip	= -1				-- Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				-- Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none"
SWEP.IsChute = true

function SWEP:DrawHUD()
end

function SWEP:Initialize()

	self:SetWeaponHoldType( "normal" )

end
local function GetAllAmmoTypes()
	local i = 1
	local ammos = {}
	ammos[i] = game.GetAmmoName( i )
	while ammos[i] != nil do
		i = i + 1
		ammos[i] = game.GetAmmoName( i )
	end
	return ammos
end


local baloonModels = {"dog","heart","normal","normal_skin1","normal_skin2"}
function SWEP:PrimaryAttack()

	if !SERVER then return end
	local ply = self.Owner
	local phys=ply:GetPhysicsObject()
	local cvel=phys:GetVelocity()
	local ragdoll = ents.Create( "prop_ragdoll" ) --Thanks Ulyssus for showing me how to mimic the ulx ragdoll command.
	ragdoll:SetPos( ply:GetPos() )
	ragdoll:SetModel( ply:GetModel() )
	ragdoll:SetAngles(Angle(90,ply:GetAngles().y,0))
	ragdoll:Spawn()
	ragdoll:Activate()
	ragdoll.IsChuteDoll=true
	timer.Simple(0,function()
		net.Start("arc_chute")
		net.WriteEntity(ply)
		net.WriteEntity(ragdoll)
		net.WriteVector(ply:GetPlayerColor())
		net.Broadcast()
	end)
	
	local balloons = {}
	timer.Simple(0.2,function()
		if not IsValid(ragdoll) then return end
		for i=1,5 do
			local balloon = ents.Create( "gmod_balloon" )
			if ( IsValid( balloon ) ) then 
				local stuff = list.Get( "BalloonModels" )[baloonModels[math.random(1,#baloonModels)]]
				balloon:SetModel(stuff.model)
				balloon:SetSkin(stuff.skin or 0)
				balloon:SetColor( Color( math.random(0,255), math.random(0,255), math.random(0,255), 255 ) )
				balloon:SetPos(ragdoll:GetPos())
				balloon:Spawn()
				balloon:SetForce( 100 )
				balloon:SetPlayer( ply )
				constraint.Rope( ragdoll, balloon, 1, 0, vector_origin, vector_origin, 50, 0, 0, 1, "cable/rope", false )
				table.insert(balloons,balloon)
			end
		end
		ply.Chutes = balloons
	end)

	
	--ragdoll:SetColor(Color(colvec.x*255,colvec.y*255,colvec.z*255,255))
	local curweps={}
	for k, v in ipairs(ply:GetWeapons()) do
		table.insert(curweps,v:GetClass())
	end
	ply.CurChuteWeps=curweps
	local curammo={}
	for k, v in ipairs(GetAllAmmoTypes()) do
		curammo[v] = ply:GetAmmoCount(v)
	end
	ply.CurChuteAmmo=curammo
	ply:SetParent( ragdoll )
	ply:StripWeapons()
	ply:Spectate( OBS_MODE_CHASE )
	ply:SpectateEntity( ragdoll )
	ply.ChuteRagdoll = ragdoll
	ragdoll:GetPhysicsObject():ApplyForceCenter(cvel*500000)
end
function SWEP:SecondaryAttack()

end
function SWEP:Holster( wep )
	return true
end
function SWEP:Deploy()
	return true
end
if CLIENT then
	net.Receive("arc_chute",function()
		local ply = net.ReadEntity()
		local doll = net.ReadEntity()
		local vec = net.ReadVector()
		MsgN(ply)
		MsgN(doll)
		if not IsValid(ply) or not IsValid(doll) then return end
		doll.IsChuteDoll=true
		function doll:GetPlayerColor()
			return vec
		end
	end)
end

if !SERVER then return end
util.AddNetworkString("arc_chute")

hook.Add("PlayerDeath","ARCParachute PreventGlitches",function(ply,wep,killer)
	if ply.ChuteRagdoll then
		ply.ChuteRagdoll:Remove()
		ply.ChuteRagdoll = nil 
		if ply.Chutes then
			for k,v in ipairs(ply.Chutes) do
				v:Remove()
			end
		end
		ply.Chutes = nil
	end
end)
hook.Add("CanTool","ARCParachute NoTool",function(ply,tr,tool)
	if tr.Entity.IsChuteDoll then return false end
end)
hook.Add("PhysgunPickup","ARCParachute NoPhys",function(ply,ent)
	if ent.IsChuteDoll then return false end
end)
hook.Add("PlayerDisconnected","ARCParachute Remove",function(ply)
	if ply.ChuteRagdoll then
		ply.ChuteRagdoll:Remove()
		ply.ChuteRagdoll = nil
		if ply.Chutes then
			for k,v in ipairs(ply.Chutes) do
				v:Remove()
			end
		end
		ply.Chutes = nil
	end
end)
hook.Add( "CanProperty", "ARCParachute Remove", function( ply, property, ent )
	if ( ent.IsChuteDoll ) then return false end
end)


hook.Add("KeyPress","ARCParachute Remove",function(ply,key)
	if (key==IN_ATTACK) then 
		if ply.ChuteRagdoll then
			local pos = ply.ChuteRagdoll:GetPos()
			pos.z = pos.z + 10 
			ply:SetParent()

			ply.ChuteRagdoll:Remove()
			ply.ChuteRagdoll = nil 
			if ply.Chutes then
				for k,v in ipairs(ply.Chutes) do
					timer.Simple(0.1,function()
						if !IsValid(v) then return end
						v:TakeDamage( 100, ply, ply ) 
					end)
				end
				ply.Chutes = nil
			end
			ply:Spawn()
			timer.Simple(0.0,function() ply:SetPos( pos ) end)
			ply:StripWeapons()
			ply:StripAmmo() 
			local weptbl=ply.CurChuteWeps
			for i=1, #weptbl do
				ply:Give(weptbl[i])
			end
			for k,v in pairs(ply.CurChuteAmmo) do
				ply:SetAmmo( v, k ) 
			end
			
			--[[
			local chutelocal, chutelocal2 = chute:GetRight()*40+chute:GetLocalPos(), chute:GetRight()*-40+chute:GetLocalPos()
			constraint.Rope( ply.chuteragdoll, chute, 7, 0, Vector(0,0,0), Vector(100,0,-20), 200, 0, 0, 2, "cable/rope", 0 )
			constraint.Rope( ply.chuteragdoll, chute, 5, 0, Vector(0,0,0), Vector(-100,0, -20), 200, 0, 0, 2, "cable/rope", 0 )
			]]
		end
	end
end)
