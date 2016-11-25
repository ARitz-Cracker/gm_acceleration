
SWEP.UseHands = true
SWEP.PrintName			= "Multilaser Grenade"		-- 'Nice' Weapon name (Shown on HUD)	
SWEP.Category 			= "Laser Wars"
SWEP.Slot				= 4						-- Slot in the weapon selection menu
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
SWEP.Purpose		= "When it explodes, it shoots lasers in all directions."
SWEP.Instructions	= "Throw!"

SWEP.ViewModelFOV	= 56
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_grenade.mdl"
SWEP.WorldModel		= "models/weapons/w_grenade.mdl"

SWEP.Spawnable			= true
SWEP.AdminOnly			= false

SWEP.Primary.ClipSize		= -1					-- Size of a clip
SWEP.Primary.DefaultClip	= 1				-- Default number of bullets in a clip
SWEP.Primary.Automatic		= false				-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "Grenade"

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

	self:SetWeaponHoldType( "grenade" )
	self.HoldDownPrimary = false
end

--[[---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
-----------------------------------------------------------]]
function SWEP:PrimaryAttack()
	if self.Owner.IsOut then return end

	-- Make sure we can shoot first
	if ( self:Ammo1() <= 0 ) then return end

	-- Play shoot sound
	--self.Weapon:EmitSound("arc_lasertag/weapons/fire2.wav")
	
	
	-- Remove 1 bullet from our clip
	self:TakePrimaryAmmo(1)

	self:SetNextPrimaryFire(CurTime() + 0.2)
	self:SetNextSecondaryFire(math.huge)
	self.HoldDownPrimary = true
	-- ACT_VM_PULLBACK_LOW -> ACT_VM_SECONDARYATTACK
	-- ACT_VM_PULLBACK_HIGH -> ACT_VM_THROW
	self.Weapon:SendWeaponAnim( ACT_VM_PULLBACK_HIGH )
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
function SWEP:Grenade(throw)
	if !SERVER then return end
	if !IsValid(self.Weapon) then return end
	local tr = self.Owner:GetEyeTrace()
	local ent = ents.Create( "prop_physics" )
	ent:SetModel( "models/weapons/w_grenade.mdl" )
	ent:SetPos (self.Owner:EyePos() + (self.Owner:GetAimVector() * 16))
	ent:SetAngles (self.Owner:EyeAngles())
	--ent:SetOwner(self.Owner)
	ent:Spawn()
	local phys = ent:GetPhysicsObject()
	local velocity = self.Owner:GetAimVector()
	velocity = velocity * 1100
	velocity = velocity + ( VectorRand() * 20 ) -- a random element
	phys:ApplyForceCenter( velocity )
	phys:AddAngleVelocity( VectorRand() * 100 ) 
	timer.Simple(3,function()
		if IsValid(phys) then
			phys:ApplyForceCenter( Vector(0,0,math.Rand(400,500)) )
			phys:AddAngleVelocity( VectorRand() * 1000 ) 
		end
	end)
	timer.Simple(4,function()
		if IsValid(ent) then
			ent:EmitSound("arc_lasertag/weapons/explode"..tostring(math.random(1,3))..".wav")
			phys:EnableMotion(false)
			local entpos = ent:GetPos()
			local ply = ARCLib.GetNearestPlayer(entpos,self.Owner)
			if IsValid(ply) then
				local dist = math.ceil(ply:GetPos():Distance(entpos)/145)
				if dist == math.random(math.Round(math.random()),dist) then
					--LaserWars.DamagePlayer(ply,point,attacker)
					ent:SetAngles(((ply:GetPos()+Vector(0,0,48)) - entpos):Angle())
				end
			end
			for k,v in pairs(player.GetAll()) do
				local dist = math.ceil(v:GetPos():Distance(entpos)/145)
				if dist == 1 then
					LaserWars.DamagePlayer(v,2,self.Owner)
				elseif dist == 2 then
					LaserWars.DamagePlayer(v,1,self.Owner)
				end
			end
			self.entang = ent:GetAngles()
			self.entang2 = ent:GetAngles()
			self.entang2:RotateAroundAxis( self.entang2:Up(), 90 )
			self.entang3 = ent:GetAngles()
			self.entang3:RotateAroundAxis( self.entang3:Right(), 90 )
			--local entang2 = entang+Angle( 90, 0, 0 )
			for i=1,8 do
				LaserWars.ShootLaser(self.Owner,entpos,(self.entang+Angle(0,0,i*45)):Up(),ent)
				if i != 4 && i != 8 then
					LaserWars.ShootLaser(self.Owner,entpos,(self.entang2+Angle(0,0,i*45)):Up(),ent)
				end
				if i != 2 && i != 4 && i != 6 && i != 8 then
					LaserWars.ShootLaser(self.Owner,entpos,(self.entang3+Angle(0,0,i*45)):Up(),ent)
				end
			end
			local effectdata = EffectData()
			effectdata:SetOrigin( entpos ) 
			effectdata:SetColor(self.Owner:Team())
			util.Effect( "arc_laserexplosion", effectdata )
			ent:Remove()
		end
	end)
end
function SWEP:Think()
	if self.HoldDownPrimary && !self.Owner:KeyDown( IN_ATTACK ) && !self.Owner:KeyDownLast( IN_ATTACK ) && !self.Owner:KeyPressed( IN_ATTACK ) && self:GetNextPrimaryFire() < CurTime()  then
		self.HoldDownPrimary = false
		self.Weapon:SendWeaponAnim( ACT_VM_THROW )  -- View model animation
		self.Owner:SetAnimation( PLAYER_ATTACK1 ) -- 3rd Person Animation
		timer.Simple(0.2,function()
			self:Grenade(true)
		end)
		timer.Simple(1,function() 
			if self:Ammo1() > 0 then
				self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
			end
		end)
		self:SetNextPrimaryFire(CurTime() + 1.5)
		self:SetNextSecondaryFire(CurTime() + 1.5)
	end
end
function SWEP:Holster( wep )
	return true
end
function SWEP:Deploy()
	if IsValid(self.Owner) then
		return (self:Ammo1() > 0)
	else
		return true
	end
end
function SWEP:ShootEffects()

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