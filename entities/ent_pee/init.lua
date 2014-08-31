AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()

	--self.Entity:SetName("piss")

	self.Owner = self.Entity:GetOwner()

	if !IsValid(self.Owner) then
		self:Remove()
		return
	end

	self.Entity:SetModel("models/hunter/plates/plate.mdl")
	self:SetMaterial("Models/effects/vol_light001")
	self:PhysicsInitSphere(1)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:DrawShadow(false)
	--self.Entity:SetMass(1)
	self:GetPhysicsObject():EnableGravity( true )
	--self.Entity:SetCollisionGroup(COLLISION_GROUP_PLAYER_MOVEMENT )
	
	local phys = self.Entity:GetPhysicsObject()


//	util.SpriteTrail(self.Entity, 0, Color(255, 255, 0, 255), false, 2, 10, 5, 5 / ((2 + 10) * 0.5), "trails/laser.vmt")
end

function ENT:Think()

	if self.Entity:WaterLevel() > 2 then
		self.Entity:Remove()
	end
end

function ENT:PhysicsCollide(data, physobj)
			
			


	if data.Speed > 50 then
		self.Entity:EmitSound(Sound("ambient/water/rain_drip3.wav"))
	end
	
	timer.Create( "Pee" .. self.Entity:EntIndex(), 1, 1, function() if self:IsValid() then self.Entity:Remove() end end )
			
	if (data.HitEntity):Health() >= 1 then 
		(data.HitEntity):TakeDamage( 2 , self.Owner , self.Entity )
		ParticleEffect( "slime_splash_01_droplets", data.HitPos, data.HitNormal:Angle( ) )
		self.Entity:Remove()
	end
	
	if data.HitEntity:GetClass() == "worldspawn" or data.HitEntity:GetClass() == "prop_ragdoll" then
		
		self.Entity:GetPhysicsObject():EnableMotion(false)
		
		
		local Pos1 = data.HitPos + data.HitNormal
		local Pos2 = data.HitPos - data.HitNormal
		util.Decal("BeerSplash", Pos1, Pos2)
		
		local effectdata = EffectData()
			effectdata:SetStart( data.HitPos ) // not sure if we need a start and origin (endpoint) for this effect, but whatever
			effectdata:SetOrigin( data.HitPos )
			effectdata:SetScale( 0.5 )
			util.Effect( "StriderBlood", effectdata )	
		
		
		
		ParticleEffect( "slime_splash_01_droplets", data.HitPos, data.HitNormal:Angle( ) )
	end
	
	
end
