include("shared.lua")

function ENT:Initialize()

end

function ENT:Draw()
	
	self:DrawModel()
		
	self.Enable = self:GetNWBool( "Enable", false )

	if self.Enable then
		self.HitP = self:GetNWVector( self.Entity.EntIndex().."HITP", Vector( 0, 0, 0 ) )
		self.HitN = self:GetNWVector( self.Entity.EntIndex().."HITTD", Vector( 0, 0, 0 ) )
		
		self:SetRenderBoundsWS( self.HitP, self.HitN )
		
		--HitN = self:GetNWVector( "TraceHitPos", Vector( 0, 0, 0 ) )
	
		render.SetMaterial(Material("sprites/bluelaser1"))
		render.DrawBeam(self.HitP, self.HitN, 2, 0, 12.5, Color(255, 0, 0, 255))
	end
	
	
	
end
	
	
	


function ENT:Think()


	


end 