
TOOL.Category = "Acceleration"
TOOL.Name = "#tool.checkpoint.name"

TOOL.Information = {
	{ name = "left", stage = 0 },
	{ name = "right", stage = 0 },
	{ name = "reload" }
}
TOOL.ClientConVar[ "pos" ] = "1"

function TOOL:LeftClick( trace )
	if ( not IsValid( trace.Entity ) ) then return false end
	if trace.Entity:GetClass() ~= "sent_acc_checkpoint" then return end
	self.Master = trace.Entity
	return true
end

function TOOL:RightClick( trace )
	if ( not IsValid( trace.Entity ) ) then return false end
	if trace.Entity:GetClass() ~= "sent_acc_checkpoint" then return end
	self.Slave = trace.Entity
	
	return true
end

function TOOL:Think()

end

function TOOL:Reload( trace )
	if not IsValid(self.Slave) or not IsValid(self.Master) then return false end
	local var = GetConVar( "checkpoint_pos" )
	local i = var:GetInt()
	if CLIENT then
		if IsFirstTimePredicted() then
			var:SetInt(i+1)
		end
		return false
	end
	local MasterCheckpoint = self.Master
	local SlaveCheckpoint = self.Slave
	
	local mAng = (SlaveCheckpoint:GetPos() - MasterCheckpoint:GetPos()):Angle()
	local sAng = (MasterCheckpoint:GetPos() - SlaveCheckpoint:GetPos()):Angle()
	mAng:RotateAroundAxis(mAng:Up(), 180)
	sAng:RotateAroundAxis(sAng:Up(), 180)
	
	
	MasterCheckpoint:SetAngles( mAng )
	SlaveCheckpoint:SetAngles( sAng )
	
	MsgN(i)
	MasterCheckpoint:SetCheckpointID( i )
	MasterCheckpoint:SetSlave( false )
	SlaveCheckpoint:SetCheckpointID( i )
	SlaveCheckpoint:SetSlave( true )
	
	MasterCheckpoint:Spawn( )
	SlaveCheckpoint:Spawn( )
	
	MasterCheckpoint:Activate( )
	SlaveCheckpoint:Activate( )
	
	MasterCheckpoint:SetCounterpart( SlaveCheckpoint )
	SlaveCheckpoint:SetCounterpart( MasterCheckpoint )
	
	MasterCheckpoint:GetPhysicsObject():EnableMotion(false)
	SlaveCheckpoint:GetPhysicsObject():EnableMotion(false)
	
	ARCLib.NotifyPlayer(self:GetOwner(),ARCLib.PlaceholderReplace(Car.Msgs.tool.checkpoint.Placed,{NUM=tostring(i)}), NOTIFY_GENERIC, 5,true)
	return false
end
concommand.Add( "checkpoint_clear", function( ply, cmd, args )
	if not ply:IsSuperAdmin() then return end
	for k,v in ipairs(ents.FindByClass("sent_acc_checkpoint")) do
		v:SetSlave( false )
		v:SetCounterpart( NULL )
		v:SetCheckpointID( -1 )
		v.CarFrozenEnt = false
	end
end)
concommand.Add( "checkpoint_save", function( ply, cmd, args )
	if not ply:IsSuperAdmin() then return end
	local tab = Car.Checkpoints.GetTable()
	if isstring(tab) then
		ARCLib.NotifyPlayer(ply,tab, NOTIFY_ERROR, 5,true)
	else
		Car.SaveCheckpointConfiguration( tab )
		ARCLib.NotifyPlayer(ply,Car.Msgs.tool.checkpoint.Saved, NOTIFY_GENERIC, 5,true)
	end
end)

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl( "Header", { Description = "#tool.checkpoint.help" } )
	CPanel:AddControl( "slider", { Label = "#tool.checkpoint.position", Command = "checkpoint_pos", Min = 1, Max = 100, Help = true } )
	CPanel:AddControl( "button", { Label = "#tool.checkpoint.clear" , command = "checkpoint_clear"} )
	CPanel:AddControl( "button", { Label = "#tool.checkpoint.save" , command = "checkpoint_save"} )
end