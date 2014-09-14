if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName			= "Sensor Launcher"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 3
	killicon.AddFont( "weapon_cs_he", "csd", "O", Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "ent_cs_he", "csd", "O", Color( 255, 80, 0, 255 ) )
	SWEP.ViewModelFlip = false
end

SWEP.HoldType			= "shotgun"
SWEP.Base				= "weapon_cs_base"
SWEP.Spawnable			= true
SWEP.Category			= "Burger's Weapons"

SWEP.ViewModel			= "models/weapons/c_shotgun.mdl"
SWEP.WorldModel			= "models/weapons/w_shotgun.mdl"

SWEP.Primary.Damage			= 100
SWEP.Primary.NumShots		= 1
SWEP.Primary.Sound			= Sound("weapons/ar2/npc_ar2_altfire.wav")
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Delay			= 1
SWEP.Primary.Ammo			= "shotgun"
SWEP.Primary.Automatic = false

SWEP.CoolDown = 0
SWEP.RecoilMul	= 0
SWEP.Type = "sniper" -- shotgun, sniper, selective, other
SWEP.ZoomAmount = 2
SWEP.EnableScope = true
SWEP.EnableCrosshair = true

SWEP.IsReloading = false
SWEP.ReloadDelay = 0

function SWEP:PrimaryAttack()	
	if self:Clip1() == 0 then
		self:Reload()
	return end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:TakePrimaryAmmo(1)
	self:EmitSound(self.Primary.Sound, 100, 100)
	
	if SERVER then
		nade = ents.Create("ent_bur_sensor")
		EA =  self.Owner:EyeAngles()
		pos = self.Owner:GetShootPos()
		pos = pos - EA:Up() * 4 + EA:Forward() * 8
					
		nade:SetPos(pos)
		nade:SetAngles(EA)
		nade:Spawn()
		nade:SetOwner(self.Owner)
		nade:GetPhysicsObject():SetVelocity(EA:Forward() * 9000)
	end
	
end



function SWEP:Reload()
	if self:Clip1() >= self.Primary.ClipSize then return end
	if self.IsReloading == true then return end
	self:SendWeaponAnim(ACT_VM_HOLSTER)
	self.IsReloading = true
	if not self.ReloadDelay then 
		self.ReloadDelay = 0
	end
	if self.ReloadDelay > CurTime() then return end
	
	self.ReloadDelay=CurTime() + 4
	self.Weapon:EmitSound("weapons/357/357_reload1.wav",100,100)

	timer.Simple(1.5,function() self.Weapon:EmitSound("weapons/357/357_reload3.wav",100,100) end)
	timer.Simple(3,function() self.Weapon:EmitSound("weapons/357/357_reload4.wav",100,100) end)

end

function SWEP:Think()
	if self.ReloadDelay < CurTime() then
		if self.IsReloading == true then
			self:SetClip1(1)
			self:SendWeaponAnim(ACT_VM_DRAW)
			self.IsReloading = false
		end
	end
end
	
	
function SWEP:Holster()
	if self.IsReloading then 
		return false
	else
		return true
	end
end
	



