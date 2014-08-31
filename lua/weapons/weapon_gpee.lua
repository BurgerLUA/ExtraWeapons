----------------------------------------------------------------------------------------------------------------|
--Buzzofwar-- Please do not steal or copy this! I  put much effort and time into perfecting it to make it simple|
----------------------------------------------------------------------------------------------------------------|

//General Settings \\
SWEP.Author 			= "Buzzofwar"                           -- Your name.
SWEP.Contact 			= "Buzzofwar"                     		-- How Pepole chould contact you.
SWEP.base 				= "weapon_base"							-- What base should the swep be based on.
SWEP.ViewModel 			= "models/weapons/c_arms_citizen.mdl" 	-- The viewModel, the model you se when you are holding it.
SWEP.WorldModel 		= ""   									-- The worlmodel, The model yu when it's down on the ground.
SWEP.HoldType 			= "normal"                            	-- How the swep is hold Pistol smg greanade melee.
SWEP.PrintName 			= "GMod Pee"                         	-- your sweps name.
SWEP.Category 			= "Burger's Weapons"                		-- Make your own catogory for the swep.
SWEP.ReloadSound 		= ""           							-- Reload sound.
SWEP.Instructions 		= "Pee with left click"              	-- How do pepole use your swep.
SWEP.Purpose 			= "Sometimes you just got to go"        -- What is the purpose with this.
SWEP.AdminSpawnable 	= true                          		-- Is the swep spawnable for admin.
SWEP.ViewModelFlip 		= true									-- If the model should be fliped when you see it.
SWEP.UseHands			= false									-- Weather the player model should use its hands.
SWEP.AutoSwitchTo 		= true                           		-- when someone walks over the swep, chould i automatectly change to your swep.
SWEP.Spawnable 			= true                               	-- Can everybody spawn this swep.
SWEP.AutoSwitchFrom 	= true                         			-- Does the weapon get changed by other sweps if you pick them up.
SWEP.FiresUnderwater 	= true                       			-- Does your swep fire under water.
SWEP.DrawCrosshair 		= false                           		-- Do you want it to have a crosshair.
SWEP.DrawAmmo 			= false                                 -- Does the ammo show up when you are using it.
SWEP.ViewModelFOV 		= 50                             		-- How much of the weapon do u see.
SWEP.Weight 			= 0                                   	-- Chose the weight of the Swep.
SWEP.SlotPos 			= 0                                    	-- Deside wich slot you want your swep do be in.
SWEP.Slot 				= 0                                     -- Deside wich slot you want your swep do be in.
SWEP.SwayScale			= 0										-- The Sway.
SWEP.BobScale			= 0										-- The amount of bob there should be.
//General settings\\
--------------------------------------------------------------------------------|
SWEP.Base						= "weapon_base"
SWEP.Primary.Ammo         		= "none"
SWEP.Primary.Sound 				= "npc/roller/mine/rmine_explode_shock1.wav" 
SWEP.Primary.TakeAmmo 			= 0
SWEP.Primary.Recoil				= 0
SWEP.Primary.Spread 			= 0  
SWEP.Primary.Damage				= 0
SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.NumberofShots 		= 0
SWEP.Primary.Delay 				= 0.1
SWEP.Primary.Force 				= 0
SWEP.Primary.Automatic   		= true							
SWEP.Primary.BulletShot 		= true
--------------------------------------------------------------------------------|
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo				= "none"
SWEP.Secondary.Delay 			= 8
--------------------------------------------------------------------------------|
--------------------------------------------------------------------------------|
local ShootSound = Sound ("ambient/water/water_spray1.wav");
local ShootSound2 = Sound ("vo/ravenholm/engage03.wav");

local Test = 0

function SWEP:Initialize()  
self:SetWeaponHoldType( self.HoldType )
util.PrecacheSound(self.Primary.Sound) 
end 

function SWEP:Think()
end




function SWEP:PrimaryAttack()
	self.Owner:ViewPunch( Angle( -0.1, 0, 0 ) )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound(ShootSound);
	self.BaseClass.ShootEffects (self);

	if Test <= 3 then 
		Test = Test+1 
	else 
		Test = 0 
	end

	if self.Owner:Health() <= self.Owner:GetMaxHealth()-1 and Test==0 then self.Owner:SetHealth(self.Owner:Health() + 1) end
	
	if (SERVER) then
		local trace = self.Owner:GetAngles()
		local ang = self.Owner:GetAngles() + Angle(math.random(-1,1),math.random(-1,1),math.random(-1,1)*0.5)
		local ent = ents.Create ("ent_pee");
			ent:SetPos(self.Owner:GetPos() + Vector(0,0,30) + self.Owner:GetForward()*4)
			ent:SetAngles(ang)
			ent:SetOwner(self.Owner)
			ent:Spawn();
		local trail = util.SpriteTrail(ent, 0, Color(255,255,0), false, 5, 1, .8, 1/(15+1)*0.5, "trails/laser.vmt")
		local phys = ent:GetPhysicsObject();
			phys:ApplyForceCenter (self.Owner:GetAimVector():GetNormalized() * 100);
			phys:AddVelocity(self.Owner:GetVelocity())
			phys:AddAngleVelocity(Vector(0,2,0))
		if IsValid(phys) then
			phys:ApplyForceCenter(ang:Forward() *0 +ang:Up() *165)
			phys:AddAngleVelocity(Vector(0,0,0))
		end
	end
	
end

function SWEP:SecondaryAttack()
	self.Owner:ViewPunch( Angle( -10, 0, 0 ) )
	self:SetNextSecondaryFire( CurTime() + 1 )
	self.Weapon:EmitSound(ShootSound2);
	self.BaseClass.ShootEffects(self);
	
	for i=1,1 do 
		if (SERVER) then
			local trace = self.Owner:GetEyeTrace();
			local ang = self.Owner:GetAimVector():Angle() + Angle(math.random(-1,1),math.random(-1,1),math.random(-1,1))
			local ent = ents.Create ("ent_cum");
				ent:SetPos(self.Owner:GetPos() + Vector(0,0,30) + self.Owner:GetForward()*4)
				ent:SetAngles(ang)
				ent:SetOwner(self.Owner)
				ent:Spawn();
			local trail = util.SpriteTrail(ent, 0, Color(255,255,255), true, math.random(4,5), 0, 0.05 * math.random(1,3), 1/(15+1)*0.5, "effects/bloodstream.vmt")
			local phys = ent:GetPhysicsObject();
			print()
			phys:ApplyForceCenter ( self.Owner:GetAimVector():GetNormalized() * 400 + self.Owner:GetVelocity( ):Length() * self.Owner:GetForward());
			phys:AddAngleVelocity(Vector(0,2,0))
			if IsValid(phys) then
				phys:ApplyForceCenter(ang:Forward() * 100 + ang:Up() * math.random(100,165))
				phys:AddAngleVelocity(Vector(0,0,0))
				phys:AddVelocity(self.Owner:GetVelocity())
			end
		end
	end
	


end

function SWEP:Reload()
end