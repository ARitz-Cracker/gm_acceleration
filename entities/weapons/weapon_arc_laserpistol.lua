
SWEP.UseHands = true
SWEP.PrintName			= "Perpetual Pistol"		-- 'Nice' Weapon name (Shown on HUD)	
SWEP.Category 			= "Laser Wars"
SWEP.Slot				= 1						-- Slot in the weapon selection menu
SWEP.SlotPos			= 1					-- Position in the slot
SWEP.DrawAmmo			= true					-- Should draw the default HL2 ammo counter
SWEP.DrawCrosshair		= true 					-- Should draw the default crosshair
SWEP.DrawWeaponInfoBox	= true					-- Should draw the weapon info box
SWEP.BounceWeaponIcon   = true					-- Should the weapon icon bounce?
if CLIENT then
	SWEP.WepSelectIcon		= surface.GetTextureID( "weapons/swep" )
end
SWEP.Author			= "ARitz Cracker"
SWEP.Contact		= "aritz-rocks@hotmail.com"
SWEP.Purpose		= "Basic Laser Pistol for Laser Wars"
SWEP.Instructions	= "Shoooot!"

SWEP.ViewModelFOV	= 56
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_pistol.mdl"

SWEP.Weight				= 8
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= true

SWEP.Spawnable			= true
SWEP.AdminOnly			= false

SWEP.Primary.ClipSize		= 100					-- Size of a clip
SWEP.Primary.DefaultClip	= 100				-- Default number of bullets in a clip
SWEP.Primary.Automatic		= false				-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "AR2"

SWEP.Secondary.ClipSize		= -1				-- Size of a clip
SWEP.Secondary.DefaultClip	= -1				-- Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				-- Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none"


function SWEP:DrawHUD()
end


--[[---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
-----------------------------------------------------------]]
function SWEP:Initialize()

	self:SetWeaponHoldType( "pistol" )

end

--[[---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
-----------------------------------------------------------]]
function SWEP:PrimaryAttack()
	if self.Owner.IsOut then return end
	-- Make sure we can shoot first
	if ( !self:CanPrimaryAttack() ) then return end

	-- Play shoot sound
	self.Weapon:EmitSound("arc_lasertag/weapons/fire2.wav")
	
	
	-- Remove 1 bullet from our clip
	self:TakePrimaryAmmo(math.random(8,12))

	--self:SetNextPrimaryFire(CurTime() + 0.1)
	self:ShootEffects()
	local trace = self.Owner:GetEyeTrace()
	local effectdata = EffectData()
	effectdata:SetStart( self.Owner:GetShootPos() ) 
	effectdata:SetAttachment( 1 ) 
	effectdata:SetEntity( self ) 
	effectdata:SetOrigin(trace.HitPos)		
	effectdata:SetColor(self.Owner:Team())
	util.Effect( "arc_lasertracer", effectdata )
	local bouncecount = 0
	local stopbounce = true
	repeat
		stopbounce = true
		bouncecount = bouncecount + 1
		if IsValid(trace.Entity) then
			if trace.Entity:IsPlayer() then
				if SERVER then
					LaserWars.DamagePlayer(trace.Entity,1,self.Owner)
				end
			elseif table.HasValue( LaserWars.ReflectEnts, trace.Entity:GetClass() ) || table.HasValue( LaserWars.ReflectModels, trace.Entity:GetModel() ) || table.HasValue( LaserWars.ReflectTextures, trace.HitTexture ) then
				stopbounce = false
			end
		end
		if !stopbounce then
			local trace2 = util.QuickTrace( trace.HitPos, self:GetReflectedVector( trace.Normal, trace.HitNormal )*10000, trace.Entity ) 
			local ricdata = EffectData()
			ricdata:SetStart(trace.HitPos) 
			ricdata:SetAttachment( 1 ) 
			ricdata:SetEntity( NULL ) 
			ricdata:SetOrigin(trace2.HitPos)
			ricdata:SetColor(self.Owner:Team())
			util.Effect( "arc_lasertracer", ricdata )
		
			trace = trace2
		end
	until (bouncecount > 64 || stopbounce)
	
end
function SWEP:GetReflectedVector( startnormal, endnormal )

	return startnormal - 2 * ( endnormal:DotProduct( startnormal ) * endnormal );

end
function SWEP:SecondaryAttack()
	if self.Owner.IsOut then return end
	-- Make sure we can shoot first
	if ( !self:CanSecondaryAttack() ) then return end

	-- Play shoot sound
	self.Weapon:EmitSound("Weapon_Shotgun.Single")
	
	-- Shoot 9 bullets, 150 damage, 0.75 aimcone
	self:ShootBullet( 150, 9, 0.2 )
	
	-- Remove 1 bullet from our clip
	self:TakeSecondaryAmmo( 10 )
	
	-- Punch the player's view
	self.Owner:ViewPunch( Angle( -10, 0, 0 ) )

end

function SWEP:Think()
	if self.Weapon:Clip1() < 0 then
		self:SetClip1(0)
	else
		if self.Weapon:Clip1() < 100 && (!self.RechargeTime || self.RechargeTime < CurTime()) then
			self:SetClip1( self.Weapon:Clip1() + 1 ) 
			self.RechargeTime = CurTime() + 0.1
		end
	end
end
function SWEP:Holster( wep )
	return true
end
function SWEP:Deploy()
	return true
end
function SWEP:ShootEffects()

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )  -- View model animation
	--self.Owner:MuzzleFlash() -- Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 ) -- 3rd Person Animation

end
--[[---------------------------------------------------------
   Name: SWEP:TakePrimaryAmmo(   )
   Desc: A convenience function to remove ammo
-----------------------------------------------------------]]
function SWEP:TakePrimaryAmmo( num )
	
	-- Doesn't use clips
	if ( self.Weapon:Clip1() <= 0 ) then 
	
		if ( self:Ammo1() <= 0 ) then return end
		
		self.Owner:RemoveAmmo( num, self.Weapon:GetPrimaryAmmoType() )
	
	return end
	
	self.Weapon:SetClip1( self.Weapon:Clip1() - num )	
	
end

--[[---------------------------------------------------------
   Name: SWEP:CanPrimaryAttack( )
   Desc: Helper function for checking for no ammo
-----------------------------------------------------------]]
function SWEP:CanPrimaryAttack()

	if ( self.Weapon:Clip1() < math.random(8,12) ) then
	
		self:EmitSound( "Weapon_Pistol.Empty" )
		--self.Weapon:SendWeaponAnim( ACT_VM_DRYFIRE );
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		--self:Reload()
		return false
		
	end

	return true

end