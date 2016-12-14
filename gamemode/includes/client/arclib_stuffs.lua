function Car.Load()
	if !file.IsDir( Car.Dir,"DATA" ) then
		Car.Msg("Created Folder: "..Car.Dir)
		file.CreateDir(Car.Dir)
	end
	if !file.IsDir( Car.Dir,"DATA" ) then
		Car.Msg("CRITICAL ERROR! FAILED TO CREATE ROOT FOLDER!")
		Car.Msg("LOADING FALIURE!")
		return
	end
	if !file.IsDir( Car.Dir.."/saved_cars","DATA" ) then
		Car.Msg("Created Folder: "..Car.Dir.."/saved_cars")
		file.CreateDir(Car.Dir.."/saved_cars")
	end
end