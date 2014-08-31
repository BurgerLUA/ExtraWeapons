AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self.YeahTest = true
	self:SetModel("models/misc/dildo.mdl") 
	self:PhysicsInit(SOLID_VPHYSICS)
	--self:SetModelScale(0.5)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCustomCollisionCheck( true )
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	--self:PhysicsInit( SOLID_NONE )
	self.EnableTrace = 0
	local phys = self:GetPhysicsObject()

	if phys and phys:IsValid() then
		phys:Wake()
		phys:SetMass(1)
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		phys:AddGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
		phys:AddGameFlag(FVPHYSICS_DMG_DISSOLVE)
		--phys:AddGameFlag(FVPHYSICS_NO_SELF_COLLISIONS)
	end
	
	self:GetPhysicsObject():SetBuoyancyRatio(0)
	self.FallTime = CurTime() + self:GetDTInt(0)
	
	--spd = physenv.GetPerformanceSettings()
   -- spd.MaxVelocity = 2992
	
    --physenv.SetPerformanceSettings(spd)
end

function ENT:Use(activator, caller)
	return false
end

function ENT:OnRemove()
	return false
end 


function ENT:PhysicsCollide(data, physobj)

	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	physobj:EnableDrag(true)
	physobj:EnableGravity(true)
	
	self.HitP = data.HitPos + self.Entity:GetUp()
	self.HitN = data.HitNormal
	


	if data.HitEntity:IsValid() and data.Speed > 1000 then 

		--util.BlastDamage(self.Entity, self.Owner, data.HitPos,50,20+(data.OurOldVelocity:Length()/200)^1.5)
		
		if data.HitEntity:GetClass() == "func_breakable_surf" then
			data.HitEntity:Fire("Break")
		end
		
		
		
		if data.HitEntity:Health() >= 1 then
			
			
			if data.HitEntity:IsPlayer() then 
				if data.HitEntity:Team() == self.Owner:Team() and self.Owner:Team() ~= 1001 then return end
				data.HitEntity:TakeDamage( (20+(data.OurOldVelocity:Length()/200)^1.5)/2, self.Owner, self.Entity )
			else
				data.HitEntity:TakeDamage( (20+(data.OurOldVelocity:Length()/200)^1.5)/2, self.Owner, self.Entity )
			end
			
		end
		

		
		

		
		local ent = ents.Create( "ent_bur_naughty" )
	

		self.pos = self.HitP + self.HitN*10
					
		ent:SetPos(self.pos)
		ent:SetAngles(data.HitNormal:Angle() + Angle(180,0,0))
		ent:Spawn()
		ent:Activate()
		ent.Entity:SetDTInt( 0 , self:GetDTInt(0) )
		ent:SetOwner(self.Owner)
		ent:GetPhysicsObject():SetVelocity(data.OurOldVelocity)
		--ent:GetPhysicsObject():AddAngleVelocity(Vector(-10000 + self.FireCount*500,0,0))
		
		self:Remove()
		
		self:EmitSound("misc/rubberglove_snap.wav",100,100)
		

		
		if data.HitEntity:IsNPC() == true then
			self.AimVec = data.HitEntity:GetAngles()
		--elseif data.HitEntity:IsBot() then
		--	self.AimVec = data.HitEntity:GetAngles()
		elseif data.HitEntity:IsPlayer() then
			self.AimVec = data.HitEntity:GetAimVector():Angle()
		else return end
		
		if data.HitEntity:IsPlayer() or data.HitEntity:IsNPC() then	
			ent.Entity:SetDTInt( 1 , self:GetDTInt(1) + 1 )
		end

		if data.HitEntity:Health() > (20+(data.OurOldVelocity:Length()/200)^1.5)/2 then return end
		data.HitEntity:EmitSound("vo/npc/alyx/uggh02.wav")
		
		if self:GetDTInt(1) == 1 then
			data.HitEntity:EmitSound("weapons/rainblower/rainblower_start.wav")
			
			--print("anus")

			for fast=1, 10 do 
				self.ent3 = ents.Create("ent_bur_naughty")
				self.pos3 = self.HitP + Vector(math.random(-1,1),math.random(-1,1),math.random(-1,1))*10
				self.ent3:SetPos(self.pos3)
				self.ent3:SetAngles(data.HitNormal:Angle() + Angle(180,0,0))
				self.ent3:Spawn()
				--print("k dude")
				self.ent3:GetPhysicsObject():EnableDrag(false)
				self.ent3:GetPhysicsObject():EnableGravity(false)
				self.ent3:Activate()
				self.ent3.Entity:SetDTInt( 0 , self:GetDTInt(0)+5 )
				self.ent3.Entity:SetDTInt( 1 , 0 )
				self.ent3:SetOwner(self.Owner)
				--self.ent3:SetModel("models/Items/Flare.mdl")
				self.RandColor = Color(math.Rand(0,255),math.Rand(0,255),math.Rand(0,255))
				self.ent3:SetMaterial("models/shiny")
				self.ent3:SetColor(self.RandColor)
				self.trail = util.SpriteTrail(self.ent3, 0, self.RandColor, true, 30, 0, 1, 1/(15+1)*0.5, "trails/laser.vmt")
				self.ent3:GetPhysicsObject():SetVelocity(Vector(math.random(-1,1),math.random(-1,1),math.random(-1,1))*800)
				self.ent3:GetPhysicsObject():AddAngleVelocity(Vector(-1000,-1000,-1000))
			end
			
			if table.Count(ents.FindInSphere(self:GetPos(),1000)) > 0 then
				for k,v in pairs(ents.FindInSphere(self:GetPos(),1000)) do
					if v:Health() > 0 then
					
						if v:IsPlayer() then
							v:SendLua("chat.AddText(Color(255,0,0), \"P\",Color(255,100,0), \"E\",Color(255,255,0), \"N\",Color(100,255,0), \"E\",Color(0,255,0), \"T\",Color(0,255,100), \"R\",Color(0,255,255), \"A\",Color(0,100,255), \"T\",Color(0,0,255), \"I\",Color(100,0,255), \"O\",Color(255,0,255), \"N\")")
						end
					
						if v:IsPlayer() then
							--if v:Team() == self.Owner:Team() and self.Owner:Team() ~= 1001 then return end
							--if v == self.Owner then return end
							v:TakeDamage( 2000, self.Owner, self.Entity )
						else
							v:TakeDamage( 2000, self.Owner, self.Entity )
						end
					end
				end
			end
			
			
			
		end
		
		if self:GetDTInt(1) == 2 then
			print("omg")
		end
		

		self.ang = self.AimVec + Angle(math.random(-1,1),math.random(-1,1),math.random(-1,1))

		self.ent2 = ents.Create("ent_cum")
			constraint.NoCollide( self.ent2, data.HitEntity, 0, 0 )
			self.ent2:SetPos(data.HitEntity:GetPos() + Vector(0,0,30) + data.HitEntity:GetForward()*4)
			self.ent2:SetAngles(self.ang)
			self.ent2:SetOwner(data.HitEntity)
			self.ent2:Spawn();
			self.trail = util.SpriteTrail(self.ent2, 0, Color(255,255,255), true, math.random(4,5), 0, 0.05 * math.random(1,3), 1/(15+1)*0.5, "sprites/physbeama.vmt")
			self.phys = self.ent2:GetPhysicsObject();
			self.phys:ApplyForceCenter( data.HitEntity:GetAimVector():GetNormalized() * 400 + data.HitEntity:GetVelocity( ):Length() * data.HitEntity:GetForward());
			self.phys:AddAngleVelocity(Vector(0,2,0))
		if IsValid(self.phys) then
			self.phys:ApplyForceCenter(self.ang:Forward() * 100 + self.ang:Up() * math.random(100,165))
			self.phys:AddAngleVelocity(Vector(0,0,0))
		end
	end	
	
	if data.HitEntity:GetClass() == "worldspawn" && data.Speed > 2000 then
	
		--print((data.OurOldVelocity:Length()/200)^1.5)

		physobj:EnableMotion(false)
		--print(data.HitNormal)
		physobj:SetPos(data.HitPos - data.HitNormal*5)
		physobj:SetAngles(data.HitNormal:Angle()+Angle(90,0,0))
		self:EmitSound("Concrete_Block.ImpactHard")
			
		self.effectdata = EffectData()
			self.effectdata:SetStart( self:GetPos() - self:GetRight() ) // not sure if we need a start and origin (endpoint) for this effect, but whatever
			self.effectdata:SetOrigin( self:GetPos() - self:GetRight()*6 )
			self.effectdata:SetScale( 1 )
		for i = 1, 10 do
			util.Effect( "GlassImpact", self.effectdata )	
		end

		self.Pos1 = self.HitP + self.HitN
		self.Pos2 = self.HitP - self.HitN
		util.Decal("ExplosiveGunshot", self.Pos1, self.Pos2)
		
	elseif data.Speed > 500 then
		self:EmitSound("physics/body/body_medium_impact_hard3.wav")
	end
	
	timer.Create(self:EntIndex().."remove", 5, 1, function()
		if not self:IsValid() then return end
		self.Entity:Remove()
	end)
	
	
	
end


function ENT:Think()
	local phys = self:GetPhysicsObject()

	if self.FallTime <= CurTime() and phys:IsValid() and self.YeahTest==true then
		--phys:EnableDrag(true)
		phys:EnableGravity(true)
		--print("boom")
		self.YeahTest = false
	end
	
end
