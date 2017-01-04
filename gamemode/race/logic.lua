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
--Car.Race.MinimumRequired = 3
Car.Race.MinimumRequired = 1
Car.Race.TimerLength = 30 -- seconds
Car.Race.LapCount = 2
Car.Race.CheckpointCount = 0
Car.Race.CurrentPlayers = { }
Car.Race.QueuedPlayers = { }
Car.Race.RaceStartTime = math.huge

function Car.Race.ConfigurationLoaded( Configuration )


end

-- Internal too?
function Car.Race.Start( )

	if ( Car.Race.RaceStatus == Car.Race.Enums.RaceStatus.NoCurrentRace ) then
	
		Car.Race.CurrentPlayers = Car.Race.QueuedPlayers
		Car.Race.QueuedPlayers = { }
		
		for k, Pl in pairs( Car.Race.CurrentPlayers ) do
	
			Car.Race.AddPlayer( Pl )
			
		end
		
		Car.Race.RaceStatus = Car.Race.Enums.RaceStatus.RaceInProgress
		Car.Race.FinishingPlaces = {}
		hook.Run( "AccelerationNewRace", Car.Race.CurrentPlayers )
		
	end

end

function Car.Race.AddPlayerToQueue( Pl )

	Car.Race.QueuedPlayers[ #Car.Race.QueuedPlayers + 1] = Pl
	
	if ( #Car.Race.QueuedPlayers >= Car.Race.MinimumRequired ) and not Car.Race.TimerCounting then
		Car.Race.MinimumPlayerRequirementMet( )
	
	end
	
end

function Car.Race.RemovePlayerFromQueue( Pl )
	
	table.RemoveByValue( Car.Race.QueuedPlayers, Pl ) 
	
end

-- INTERNAL.
function Car.Race.MinimumPlayerRequirementMet( )

	local timerShouldStart = hook.Run( "AccelerationShouldRaceStart", Car.Race.QueuedPlayers )
	if ( timerShouldStart ~= false ) then
		if Car.Race.RaceStatus == Car.Race.Enums.RaceStatus.NoCurrentRace then
			ARCLib.NotifyBroadcast(ARCLib.PlaceholderReplace(Car.Msgs.HudMsg.NewRace,{TIME=ARCLib.TimeString(Car.Race.TimerLength,Car.Msgs.Time)}),NOTIFY_GENERIC,20,true)
			Car.Race.TimerCounting = true
			
			Car.Race.RaceStartTime = CurTime() + Car.Race.TimerLength
			--timer.Simple( Car.Race.TimerLength, Car.Race.TimerCallback )
		end
	end
	
end

-- INTERNAL.
function Car.Race.TimerCallback( )
	local tab = Car.Checkpoints.GetTable()
	Car.Race.TimerCounting = false
	if ( #Car.Race.QueuedPlayers >= Car.Race.MinimumRequired and istable(tab)) then
		
		ARCLib.NotifyBroadcast("The race has started! (No fancy countdown yet JUST GO!!)",NOTIFY_GENERIC,20,true)
		Car.Race.CheckpointCount = #tab
		Car.Race.Start( )
		
	else
		if isstring(tab) then
			ARCLib.NotifyBroadcast(tab, NOTIFY_ERROR, 5,true)
		end
		ARCLib.NotifyBroadcast(Car.Msgs.HudMsg.Cancelled,NOTIFY_GENERIC,20,true)
		hook.Run( "AccelerationRaceCanceled", Car.Race.QueuedPlayers )
		
	end

end

-- INTERNAL.
function Car.Race.AddPlayer( Pl )

	Pl.NextCheckpoint = 1
	Pl.LapCurrent = 0
	Pl.IsRacing = true

end

-- INTERNAL.
function Car.Race.RemovePlayer( Pl )

	Pl.NextCheckpoint = -1
	Pl.LapCurrent = 0
	Pl.IsRacing = false

end

-- INTERNAL.
function Car.Race.End( )

	for k, Pl in ipairs( Car.Race.CurrentPlayers ) do
	
		Car.Race.RemovePlayer( Pl )
		
	end
	
	hook.Run( "AccelerationEndRace", Car.Race.CurrentPlayers )
	
	Car.Race.CurrentPlayers = { }
	
	-- Start new race after this one
	if ( #Car.Race.QueuedPlayers >= Car.Race.MinimumRequired ) and not Car.Race.TimerCounting then
		Car.Race.MinimumPlayerRequirementMet( )
	end
end

-- INTERNAL.
function Car.Race.HasRaceEnded( )

	for k, Pl in pairs( Car.Race.CurrentPlayers ) do
	
		if ( Pl.LapCurrent <= Car.Race.LapCount ) then
			return false
		end
		
	end
	
	return true

end

-- INTERNAL.
function Car.Race.Think( )
	if Car.Race.RaceStartTime <= CurTime() then
		Car.Race.TimerCallback()
		Car.Race.RaceStartTime = math.huge
	end
	if ( Car.Race.RaceStatus == Car.Race.Enums.RaceStatus.RaceInProgress ) then
	
		if ( Car.Race.HasRaceEnded( ) ) then
			-- Normally do cutscene logic but not implemented yet
			for k,Pl in ipairs(Car.Race.FinishingPlaces) do
				ARCLib.NotifyBroadcast(Pl:Nick().." - #"..k,NOTIFY_GENERIC,20,true)
			end
			
			Car.Race.End( )
			Car.Race.RaceStatus = Car.Race.Enums.RaceStatus.NoCurrentRace
		end
	
	end

end

-- INTERNAL.
function Car.Race.OnPlayerCheckpoint( Pl, CheckpointID )

	if ( CheckpointID == Car.Race.CheckpointCount ) then
		
		Pl.NextCheckpoint = 1
		
	else
		
		if Pl.NextCheckpoint == 1 then
			Pl.LapCurrent = Pl.LapCurrent + 1
			hook.Run( "AccelerationPlayerFinishedLap", Pl )
			if ( Pl.LapCurrent > Car.Race.LapCount ) then
				hook.Run( "AccelerationPlayerFinishedRace", Pl )
			end
		end
		--hook.Run( "AccelerationPlayerReachedCheckpoint", Pl, CheckpointID )
		Pl.NextCheckpoint = Pl.NextCheckpoint + 1
		
	end

end

function Car.Race.OnPlayerFinishedRace( Pl )
	local i = #Car.Race.FinishingPlaces + 1
	ARCLib.NotifyBroadcast(Pl:Nick().." - #"..i,NOTIFY_GENERIC,20,true)
	Car.Race.FinishingPlaces[i] = Pl
end

hook.Add( "Think", "Car.Race.Think" ,Car.Race.Think )
hook.Add( "AccelerationPlayerCheckpointPassed" , "Car.Race.OnPlayerCheckpoint", Car.Race.OnPlayerCheckpoint )
hook.Add( "AccelerationPlayerFinishedRace", "Car.Race.OnPlayerFinishedRace", Car.Race.OnPlayerFinishedRace )
