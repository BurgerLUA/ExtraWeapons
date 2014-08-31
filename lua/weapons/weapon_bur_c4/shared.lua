SWEP.PrintName			= "Remote C4"			
SWEP.Author			= "Burger"
SWEP.Instructions		= "Left Click to throw c4, right click to detonate."

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.Category = "Burger's Weapons"

SWEP.Slot			= 4
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.ViewModel			= "models/weapons/v_slam.mdl"
SWEP.WorldModel			= "models/weapons/w_slam.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

if CLIENT then
	killicon.AddFont( "ent_bur_slam", "HL2MPTypeDeath", "*", Color( 255, 200, 0, 255 ) )
end



function SWEP:PrimaryAttack()
	
	
	if ( CLIENT ) then return end
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.75 )	
	Count = 0
	for k, v in pairs(ents.FindByClass("ent_bur_slam")) do
		if v:GetOwner() == self.Owner then Count = Count + 1 end
	end
	
	if Count > 5 then return end
	
	self:SendWeaponAnim( ACT_SLAM_THROW_THROW )
		
	
	

	timer.Simple(0.5,function() 
	if self  == nil then return end
	if self:IsValid() == false then return end
	if self.Owner == nil then return end
	if self.Owner:IsValid() == false then return end
	if self.Owner:Alive() == false then return end

	self:SendWeaponAnim( ACT_SLAM_DETONATOR_DRAW )
	local ent = ents.Create( "ent_bur_slam" )
	
		EA =  self.Owner:EyeAngles()
		pos = self.Owner:GetShootPos()
		pos = pos + EA:Right() * 5 - EA:Up() * 4 + EA:Forward() * 8
					
		ent:SetPos(pos)
		ent:SetAngles(EA + Angle(-90,0,0))
		ent:Spawn()
		ent:Activate()
		ent:SetOwner(self.Owner)
		ent:GetPhysicsObject():SetVelocity(self.Owner:GetVelocity() + EA:Forward() * 500 + EA:Up()*100)
		
	end)

end
 

function SWEP:SecondaryAttack()
	self:SendWeaponAnim( ACT_SLAM_DETONATOR_DETONATE )
	self:EmitSound("ambient/machines/catapult_throw.wav",25,150)
end
