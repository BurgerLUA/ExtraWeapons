SWEP.PrintName			= "Dilus Launcher 9000"			
SWEP.Author			= "Burger"
SWEP.Instructions		= ""
SWEP.HoldType = "rpg"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.Category = "Burger's Weapons"

SWEP.Slot			= 1
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true

SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "none"


SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"







if CLIENT then
	killicon.Add("ent_bur_naughty", "vgui/killicons/dilduslauncher", Color(255,255,255,255) )
	killicon.Add("weapon_bur_naughty", "vgui/killicons/dilduslauncher", Color(255,255,255,255) )
end


function SWEP:Initialize()
	self.ToggleSound = 1
	self.ClickSound = 1
	self.ReloadingTime = 0
	self.CoolDown = CurTime() + 5
end

function SWEP:Deploy()
	self.loopingsound = CreateSound(self.Owner, "ambient/machines/gas_loop_1.wav" )
	self.ToggleSound = 1
	self.ClickSound = 1
	self.ReloadingTime = 0
	self.CoolDown = CurTime() + 5
	return true
end

function SWEP:Holster()
	if SERVER then
		self.loopingsound:Stop()
	end
	return true
end

function SWEP:PrimaryAttack()

	if self.Weapon:Clip1() - self.TakeCount < 0 then return end


	self:TakePrimaryAmmo(self.TakeCount)
	self.CoolDown = CurTime() + 1

	
	self.FireCount = 20 - self.Weapon:Clip1()/5
	
	
	
	
	self.ShotAngle = Angle( -1, math.random(-1,1), 0 )
	self.Owner:ViewPunch( self.ShotAngle  )
	self.Weapon:EmitSound("garrysmod/balloon_pop_cute.wav",100-self.FireCount*2,50-self.FireCount*2)
	self.Owner:SetAnimation( PLAYER_ATTACK1 );
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )	



	if ( CLIENT ) then return end

	local ent = ents.Create( "ent_bur_naughty" )
		self.SpreadMul = 0.15
		EA =  self.Owner:EyeAngles() + Angle(math.Rand(1,-1),math.Rand(1,-1),0)*self.FireCount*self.SpreadMul
		pos = self.Owner:GetShootPos() + EA:Right() * 5 - EA:Up() * 4 + EA:Forward() * 8
		--pos = self.Owner:GetShootPos()
					
		ent:SetPos(pos)
		ent:SetAngles(EA + Angle(90,0,0))
		ent:Spawn()
		ent.Entity:SetDTInt( 0, 1 - (self.FireCount*0.04) )
		ent.Entity:SetDTInt( 1, 0 )
		ent:Activate()
		ent:SetOwner(self.Owner)
		ent:GetPhysicsObject():SetVelocity( self.Owner:GetVelocity() + EA:Forward() * (5500 - self.FireCount*250))
		--ent:GetPhysicsObject():AddAngleVelocity(Vector(0,0,-10000 + self.FireCount*500))
		
end
 

function SWEP:SecondaryAttack()


	if self.Weapon:Clip1() == 0 then return end


	self.CoolDown = CurTime() + 3

	self.Owner:EmitSound("items/gift_drop.wav",100,100)
	
	self.Owner:SetVelocity(Vector(0,0,1)*self.Weapon:Clip1()*5)
	self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
	self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
	
	self:TakePrimaryAmmo(self.Weapon:Clip1())
	
	
end


function SWEP:Reload()
end

function SWEP:Think()

	self.TakeCount = math.floor(math.Rand(3,5))
	
	if CLIENT then return end
	if self.ReloadingTime == nil then return end
	if self.ReloadingTime > CurTime() then return end
	if self.CoolDown > CurTime() then self.loopingsound:Stop() return end
	if self.Weapon:Clip1()+1 > 100 then
		
		if self.ClickSound == 0 then 
			self.Owner:EmitSound("weapons/slam/mine_mode.wav")
			self.loopingsound:Stop()
			self.ToggleSound = 1
			self.ClickSound = 1
		end
	return end
	
	
	if self.ToggleSound == 1 then
		self.loopingsound:Play()
		--print("play sound")
		self.ToggleSound = 0 
	end
	
	
	
	self.ReloadingTime = CurTime() + 0.04
	self.ClickSound = 0
	
	self.Weapon:SetClip1(self.Weapon:Clip1()+1)

end