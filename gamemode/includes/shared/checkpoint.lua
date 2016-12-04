--[[--------------------------------------------------------------------------------------
 _______                     ______                      _____ _____                
 ___    |___________________ ___  /_____ ______________ ___  /____(_)______ _______ 
 __  /| |_  ___/_  ___/_  _ \__  / _  _ \__  ___/_  __ `/_  __/__  / _  __ \__  __ \
 _  ___ |/ /__  / /__  /  __/_  /  /  __/_  /    / /_/ / / /_  _  /  / /_/ /_  / / /
 /_/  |_|\___/  \___/  \___/ /_/   \___/ /_/     \__,_/  \__/  /_/   \____/ /_/ /_/ 
 
 
	By Aritz Beobide-Cardinal (ARitz Cracker) && James R Swift (James xX)
 
--------------------------------------------------------------------------------------]]--

Car.Checkpoints = {}
Car.CheckpointThreshold = 2.5

-- Should be replaced with something more efficient
function Car.CheckpointFindNearestExcludeSelf( eCheckpoint, eAll )

	--if ( eCheckpoint.PairCheckpoint ) then
	--	return eCheckpoint.PairCheckpoint
	--end

	local vCheckpointPos = eCheckpoint:GetPos();
	local eNearest, eNearestDistance = NULL, math.huge
	
	for eKey, eCheck in pairs( eAll ) do
	
		if ( eCheck == eCheckpoint ) then continue end
	
		if ( vCheckpointPos:Distance( eCheck:GetPos() ) < eNearestDistance ) then
			eNearest = eCheck
			eNearestDistance = vCheckpointPos:Distance( eCheck:GetPos() )
		end
	
	end
	
	if ( eNearest == NULL ) then
		Car.Msg("Error in checkpoint logic! Nearest checkpoint is NULL")
	end
	
	eCheckpoint.PairCheckpoint = eNearest
	eNearest.PairCheckpoint = eCheckpoint
	
	Car.Checkpoints[ #Car.Checkpoints + 1] = {eCheckpoint, eNearest}
	print("being called")
	PrintTable( Car.Checkpoints )
	
	return eNearest

end

function Car.CheckpointInitialize( )

	local checkpoints = ents.FindByClass( "sent_acc_checkpoint" )
	
	PrintTable( checkpoints )
	
	if ( #checkpoints % 2 == 1) then
		Car.Msg("Error in checkpoint logic! Odd number of checkpoints")
	end
	
	for eKey, eCheck in pairs( checkpoints ) do
		Car.CheckpointFindNearestExcludeSelf( eCheck, checkpoints )
	end

end


function Car.PlayerPassedThroughCheckpointLogic( Pl )

	if ( not Pl.NextCheckpoint ) then
		Pl.NextCheckpoint = 1
		Pl.CheckpointAnglesCalculations = {}
	end
	
	--local new = {}
	
	--print( "printing table")
	--PrintTable( Car.Checkpoints )
	
	--[[--for i=1, 2 do
		local vPlayerToCheckpoint = Pl:GetPos() - Car.Checkpoints[Pl.NextCheckpoint][i]:GetPos();
		local vCheckpointToCheckpoint = Car.Checkpoints[Pl.NextCheckpoint][i]:GetPos() - Car.Checkpoints[Pl.NextCheckpoint][2 - i + 1]:GetPos()
		new[i] = math.acos ( (vCheckpointToCheckpoint:Dot(vPlayerToCheckpoint)) / (vPlayerToCheckpoint:Length() * vCheckpointToCheckpoint:Length() ) )
	end--]]--
	
	local vPlayerToCheckpoint1 = Car.Checkpoints[Pl.NextCheckpoint][1]:GetPos() -Pl:GetPos();
	local vPlayerToCheckpoint2 = Car.Checkpoints[Pl.NextCheckpoint][2]:GetPos() -Pl:GetPos();
	local AngleDifference = math.acos ( (vPlayerToCheckpoint1:Dot(vPlayerToCheckpoint2)) / (vPlayerToCheckpoint1:Length() * vPlayerToCheckpoint2:Length() ) )
	
	print( math.deg( AngleDifference ) )
	
	-- don't know what values I will be checking
	--PrintTable( new )
	
	if ( AngleDifference > Car.CheckpointThreshold ) then
	
		return true
		
	end

end
