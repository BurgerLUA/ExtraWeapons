AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Items/AR2_Grenade.mdl") 
	self:PhysicsInit(SOLID_VPHYSICS)
	--self:SetModelScale(0.5)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self.EnableTrace = 0
	local phys = self:GetPhysicsObject()

	if phys and phys:IsValid() then
		phys:Wake()
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		phys:AddGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
		phys:AddGameFlag(FVPHYSICS_PENETRATING)
		--phys:AddGameFlag(FVPHYSICS_DMG_SLICE)
	end
	
	self.Hit = 0
	
	self.Sound1PlayTime = 0
	self.Sound1HasPlayed = true
		
	self.Sound2PlayTime = 0
	self.Sound2HasPlayed = true
	
	
	self:GetPhysicsObject():SetBuoyancyRatio(0)
	self.ArmTime = CurTime() + 0.2
	
	spd = physenv.GetPerformanceSettings()
    spd.MaxVelocity = 2992
	
    physenv.SetPerformanceSettings(spd)
end

function ENT:Use(activator, caller)
	return false
end

function ENT:OnRemove()
	return false
end 

local vel, len, pos, owner

function ENT:PhysicsCollide(data, physobj)

	if self.Hit == 1 then return end


	if data.HitEntity:Health() > 0 and data.Speed > 500 then 
		data.HitEntity:TakeDamage( 100, self.Owner, self.Entity )
	end	
		
	
	



	self.HitP = data.HitPos + self.Entity:GetUp()
	self.HitN = data.HitNormal
	
	--self.HitP = self:GetPos()
	--self.HitN = self:GetForward()
	
	self:SetNWVector( self.Entity.EntIndex().."HITP", self.HitP)
	self:SetNWVector( self.Entity.EntIndex().."HITN", self.HitN)




	if data.HitEntity:GetClass() == "worldspawn" && data.Speed > 2000 then
		physobj:EnableCollisions( false )
		self.Hit = 1
		physobj:EnableMotion(false)
		--print(data.HitNormal)
		physobj:SetPos(data.HitPos + data.HitNormal)
		physobj:SetAngles(data.HitNormal:Angle()+Angle(0,0,0))
		self:EmitSound("Concrete_Block.ImpactHard")
			
		self.effectdata = EffectData()
			self.effectdata:SetStart( self:GetPos() - self:GetRight() ) // not sure if we need a start and origin (endpoint) for this effect, but whatever
			self.effectdata:SetOrigin( self:GetPos() - self:GetRight()*6 )
			self.effectdata:SetScale( 1 )
				for i = 1, 25 do
					util.Effect( "GlassImpact", self.effectdata )	
				end
			
			
		self.Pos1 = self.HitP + self.HitN
		self.Pos2 = self.HitP - self.HitN
		util.Decal("ExplosiveGunshot", self.Pos1, self.Pos2)
			

		
		self.Sound1PlayTime = CurTime() + 3
		self.Sound1HasPlayed = false
		
		self.Sound2PlayTime = CurTime() + 4.25
		self.Sound2HasPlayed = false
		
		
		
		timer.Create(self:EntIndex().."arm2", 4.25, 1, function()
			self.EnableTrace = 1
		end)
		
			
	elseif data.Speed > 500 then
		self:EmitSound("Missile.ShotDown")

		--self.Pos1 = self.HitP + self.HitN
		--self.Pos2 = self.HitP - self.HitN
		--util.Decal("Smile", self.Pos1, self.Pos2)
		
		
		timer.Create(self:EntIndex().."remove", 5, 1, function()
			if not self:IsValid() then return end
			self.Entity:Remove()
		end)
	end
	
	
	
	

	
	
	
end


function ENT:Think()
	--print("I AM THINKING")
	if self.Sound1HasPlayed == false then
		if self.Sound1PlayTime < CurTime() then
			self.Entity:EmitSound("npc/ministrider/ministrider_preflechette.wav",100,100)
		end
	end

	if self.Sound2HasPlayed == false then
		if self.Sound2PlayTime < CurTime() then
			self.Entity:EmitSound("npc/roller/remote_yes.wav",100,100)
		end	
	end



	if self.EnableTrace == 1 then
	
		self:SetNWBool( "Enable", true)
		
		self.tracedata = {}
			self.tracedata.start = self.HitP
			self.tracedata.endpos = self.HitP - (self.HitN*10000)
			self.tracedata.filter = self
		self.trace = util.TraceLine(self.tracedata)
		self:SetNWVector( self.Entity.EntIndex().."HITTD", self.trace.HitPos)
		if self.trace.HitNonWorld then
			self.target = self.trace.Entity
			
			
			--print(self:GetPos())
			
			--if self.target == self.Owner then return end
		
			self.target:TakeDamage( 5, self.Owner, self )
			self:EmitSound("ambient/alarms/klaxon1.wav")
			self.target:EmitSound("npc/ministrider/flechette_flesh_impact3.wav")
			
			self:SetNWBool( "Enable", false)
			self.EnableTrace = 0
			
		
			--[[
			self.bullet = {}
				self.bullet.Num=1
				self.bullet.Attacker = self.Owner
				self.bullet.Src=self:GetPos() - self:GetForward()
				self.bullet.Dir=-self:GetAngles():Forward()
				self.bullet.Spread=Vector(0.5,0.5,0)
				self.bullet.Tracer=1	
				self.bullet.Force=1
				self.bullet.Damage=1
				
				for i=1, 50 do
					self:FireBullets(self.bullet)
				end
				--]]

				util.Effect( "EjectBrass_12Gauge", self.effectdata )	
				--self:GetPhysicsObject():EnableMotion(true)
				--self.GetPhysicsObject():Wake()
				
				
			
			
			if not self.trace.Entity:IsPlayer() then
				timer.Create(self.Entity:EntIndex( ) .. "remove",10,1,function()
					self.Entity:Remove()
				end)
			return end
			
			self.target:SetMaterial( "burger/ignorez" )
			--self.target:SetColor(Color(255,255,255))

			timer.Create(self.target:EntIndex().."trackupdate",1,10,function()
				if not self.Entity.target:Alive() then 
					timer.Destroy(self.Entity.target:EntIndex().."trackend")
					timer.Destroy(self.Entity.target:EntIndex().."trackupdate")
					self.Entity.target:SetMaterial("")
					--self.Entity.target:SetColor(Color(255,255,255)) 
					self.Entity:Remove()
				end	
			end)
			
			timer.Create(self.target:EntIndex().."trackend", 10, 1, function() 
				timer.Destroy(self.Entity.target:EntIndex().."trackupdate")
				self.Entity.target:SetMaterial("")
				--self.Entity.target:SetColor(Color(255,255,255))
				self.Entity:Remove()
			end)
			
			

		end
	end
	
end
