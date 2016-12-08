--[[--------------------------------------------------------------------------------------
 _______                     ______                      _____ _____                
 ___    |___________________ ___  /_____ ______________ ___  /____(_)______ _______ 
 __  /| |_  ___/_  ___/_  _ \__  / _  _ \__  ___/_  __ `/_  __/__  / _  __ \__  __ \
 _  ___ |/ /__  / /__  /  __/_  /  /  __/_  /    / /_/ / / /_  _  /  / /_/ /_  / / /
 /_/  |_|\___/  \___/  \___/ /_/   \___/ /_/     \__,_/  \__/  /_/   \____/ /_/ /_/ 
 
 
	By Aritz Beobide-Cardinal (ARitz Cracker) && James R Swift (James xX)
 
--------------------------------------------------------------------------------------]]--

Car.CheckpointEntityName = "sent_acc_checkpoint"
Car.CheckpointDataFolderName = Car.DataFolder .. "checkpoint/"

function Car.LoadCheckpointConfiguration( )

	local configFile = file.Read( Car.CheckpointDataFolderName .. game.GetMap() .. ".txt" )
	if ( configFile ) then
		return util.JSONToTable( configFile )
	end
	
	return false
	
end

function Car.InitializeCheckpoints( )

	-- Count number of checkpoints to see if map has racetrack by default
	if ( #ents.FindByClass( Car.CheckpointEntityName ) > 0 ) then
		Car.Msg( "Initialized checkpoints, map supports gamemode by default" )
		return true
	end
	
	-- Load configuration file
	local configuration = Car.LoadCheckpointConfiguration( )
	if ( not configuration ) then
		Car.Msg( "Failed to initialized checkpoints, No map support or custom support" )
		return false
	end
	
	for checkpointID, pairTable in pairs( configuration ) do
	
		local MasterCheckpoint = ents.Create( Car.CheckpointEntityName )
		MasterCheckpoint:SetPos( pairTable[1].Position )
		MasterCheckpoint:SetAngles( pairTable[1].Angle )
		MasterCheckpoint:SetCheckpointID( checkpointID )
		MasterCheckpoint:SetSlave( false )
		MasterCheckpoint:Spawn( )
		MasterCheckpoint:Activate( )
		
		local SlaveCheckpoint = ents.Create( Car.CheckpointEntityName )
		SlaveCheckpoint:SetPos( pairTable[2].Position )
		SlaveCheckpoint:SetAngles( pairTable[2].Angle )
		SlaveCheckpoint:SetCheckpointID( checkpointID )
		SlaveCheckpoint:SetSlave( true )
		SlaveCheckpoint:Spawn( )
		SlaveCheckpoint:Activate( )
		
		MasterCheckpoint:SetCounterpart( SlaveCheckpoint )
		SlaveCheckpoint:SetCounterpart( MasterCheckpoint )
		
	end

end