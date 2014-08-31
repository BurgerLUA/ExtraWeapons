AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()


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
			
		--	print(data.HitEntity:GetClass())


			
			
			


	if data.Speed > 50 then
		self.Entity:EmitSound("physics/flesh/flesh_squishy_impact_hard4.wav",100,100)
	end
	
	timer.Create( "Cum" .. self.Entity:EntIndex(), 1, 1, function() if self:IsValid() then self.Entity:Remove() end end )
			
		

	--if (data.HitEntity):GetClass() == "prop_ragdoll" then
	--	data.HitEntity:Fire( "StartRagdollBoogie" )
	--end
	
			

			
	if (data.HitEntity):Health() >= 1 and data.HitEntity:IsWorld() == false then 
	
			if (data.HitEntity):Health() <= 25 then
				local ent = ents.Create("prop_physics") -- This creates our zombie entity
					ent:SetModel("models/props_c17/doll01.mdl")
					ent:SetPos(data.HitPos) -- This positions the zombie at the place our trace hit.
					ent:Spawn()
					ent:EmitSound("ambient/creatures/teddy.wav", 100, 100)
				timer.Create( "baby" .. ent:EntIndex(), 4, 1, function() if ent:IsValid() then ent:Remove() end end )
			end
	
	
		(data.HitEntity):TakeDamage( 25 , self.Owner , self.Entity )
		--ParticleEffect( "water_splash_03", data.HitPos, data.HitNormal:Angle( ) )
		self.Entity:Remove()
	end
	
	
	
	
	
	
	if data.HitEntity:GetClass() == "worldspawn" or data.HitEntity:GetClass() == "prop_ragdoll" then
		self.Entity:GetPhysicsObject():EnableMotion(false)

	
		
		
		
		local Pos1 = data.HitPos + data.HitNormal
		local Pos2 = data.HitPos - data.HitNormal
		util.Decal("PaintSplatBlue", Pos1, Pos2)
		
		local effectdata = EffectData()
			effectdata:SetStart( data.HitPos ) // not sure if we need a start and origin (endpoint) for this effect, but whatever
			effectdata:SetOrigin( data.HitPos )
			effectdata:SetScale( 1 )
			util.Effect( "AR2Impact", effectdata )	
		
		
		
		--ParticleEffect( "water_splash_03", data.HitPos, data.HitNormal:Angle( ) )
	end
	
	
end
