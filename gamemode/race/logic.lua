--[[--------------------------------------------------------------------------------------
 _______                     ______                      _____ _____                
 ___    |___________________ ___  /_____ ______________ ___  /____(_)______ _______ 
 __  /| |_  ___/_  ___/_  _ \__  / _  _ \__  ___/_  __ `/_  __/__  / _  __ \__  __ \
 _  ___ |/ /__  / /__  /  __/_  /  /  __/_  /    / /_/ / / /_  _  /  / /_/ /_  / / /
 /_/  |_|\___/  \___/  \___/ /_/   \___/ /_/     \__,_/  \__/  /_/   \____/ /_/ /_/ 
 
 
	By Aritz Beobide-Cardinal (ARitz Cracker) && James R Swift (James xX)
 
--------------------------------------------------------------------------------------]]--

Car.Race = { }

Car.Race.Enums = { }
Car.Race.Enums.RaceStatus = {
	NoCurrentRace = 1,
	RaceInProgress = 2,
	EndOfRaceCutScene = 3
}

Car.Race.RaceStatus = Car.Race.Enums.RaceStatus.NoCurrentRace
Car.Race.MinimumRequired = 3
Car.Race.TimerLength = 20 -- seconds
Car.Race.LapCount = 0
Car.Race.CheckpointCount = 0
Car.Race.CurrentPlayers = { }
Car.Race.QueuedPlayers = { }

function Car.Race.ConfigurationLoaded( Configuration )


end

function Car.Race.Start( )

	if ( Car.Race.RaceStatus == Car.Race.Enums.RaceStatus.NoCurrentRace ) then
	
		Car.Race.CurrentPlayers = Car.Race.QueuedPlayers
		Car.Race.QueuedPlayers = { }
		
		for k, Pl in pairs( Car.Race.CurrentPlayers ) do
	
			Car.Race.AddPlayer( Pl )
			
		end
		
		Car.Race.RaceStatus = Car.Race.Enums.RaceStatus.RaceInProgress
		
		hook.Run( "AccelerationNewRace", Car.Race.CurrentPlayers )
		
	end

end

function Car.Race.AddPlayerToQueue( Pl )

	Car.Race.QueuedPlayers[ Pl ] = Pl
	
	if ( #Car.Race.QueuedPlayers >= Car.Race.MinimumRequired ) then
	
		Car.Race.MinimumPlayerRequirementMet( )
	
	end
	
end

function Car.Race.RemovePlayerFromQueue( Pl )
	
	Car.Race.QueuedPlayers[ Pl ] = nil
	
end

-- INTERNAL.
function Car.Race.MinimumPlayerRequirementMet( )

	local timerShouldStart = hook.Run( "AccelerationShouldRaceStart", Car.Race.QueuedPlayers )
	if ( timerShouldStart ~= false ) then
	
		timer.Simple( Car.Race.TimerLength, Car.Race.TimerCallback )
	
	end
	
end

-- INTERNAL.
function Car.Race.TimerCallback( )

	if ( #Car.Race.QueuedPlayers >= Car.Race.MinimumRequired ) then
	
		Car.Race.Start( )
		
	else
		
		hook.Run( "AccelerationRaceCanceled", Car.Race.QueuedPlayers )
		
	end

end

-- INTERNAL.
function Car.Race.AddPlayer( Pl )

	Pl.NextCheckpoint = 1
	Pl.LapCount = 0
	Pl.IsRacing = true

end

-- INTERNAL.
function Car.Race.RemovePlayer( Pl )

	Pl.NextCheckpoint = -1
	Pl.LapCount = 0
	Pl.IsRacing = false

end

-- INTERNAL.
function Car.Race.End( )

	for k, Pl in pairs( Car.Race.CurrentPlayers ) do
	
		Car.Race.RemovePlayer( Pl )
		
	end
	
	hook.Run( "AccelerationEndRace", Car.Race.CurrentPlayers )
	
	Car.Race.CurrentPlayers = { }

end

-- INTERNAL.
function Car.Race.HasRaceEnded( )

	for k, Pl in pairs( Car.Race.CurrentPlayers ) do
	
		if ( Pl.LapCount ~= Car.Race.LapCount ) then
			return false
		end
		
	end
	
	return true

end

-- INTERNAL.
function Car.Race.Think( )

	if ( Car.Race.RaceStatus == Car.Race.Enums.RaceStatus.RaceInProgress ) then
	
		if ( Car.Race.HasRaceEnded( ) ) then
			-- Normally do cutscene logic but not implemented yet
			Car.Race.End( )
			Car.Race.RaceStatus = Car.Race.Enums.RaceStatus.NoCurrentRace
		end
	
	end

end

-- INTERNAL.
function Car.Race.OnPlayerCheckpoint( Pl, CheckpointID )

	if ( CheckpointID == Car.Race.CheckpointCount ) then
		Pl.LapCount = Pl.LapCount + 1
		Pl.NextCheckpoint = 1
		
		hook.Run( "AccelerationPlayerFinishedLap", Pl )
		
		if ( Pl.LapCount == Car.Race.CheckpointCount ) then
			hook.Run( "AccelerationPlayerFinishedRace", Pl )
		end
		
	else
	
		--hook.Run( "AccelerationPlayerReachedCheckpoint", Pl, CheckpointID )
		Pl.NextCheckpoint = Pl.NextCheckpoint + 1
		
	end

end

hook.Add( "Think", Car.Race.Think )
hook.Add( "AccelerationPlayerCheckpointPassed", Car.Race.OnPlayerCheckpoint )
