local function AddVehicle( t, class )
	list.Set( "Vehicles", class, t )
end

local function HandleVehicleAnimation( vehicle, ply )
	return ply:SelectWeightedSequence( ACT_DRIVE_JEEP ) 
end
local function HandleAirboatAnimation( vehicle, ply )
	return ply:SelectWeightedSequence( ACT_DRIVE_AIRBOAT ) 
end
local Category = "Chairs (Animated)"
AddVehicle( {
	Name = "Wooden Chair (Car)",
	Model = "models/nova/chair_wood01.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A Wooden Chair with steering wheel animations",
	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleVehicleAnimation,
	}
}, "Chair_Wood_Wheel" )

AddVehicle( {
	Name = "Chair (Car)",
	Model = "models/nova/chair_plastic01.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A Plastic Chair with steering wheel animations",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleVehicleAnimation,
	}
}, "Chair_Plastic_Wheel" )

AddVehicle( {
	Name = "Jeep Seat (Car)",
	Model = "models/nova/jeep_seat.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A Seat from VALVe's Jeep with steering wheel animations",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleVehicleAnimation,
	}
}, "Seat_Jeep_Wheel" )

AddVehicle( {
	Name = "Airboat Seat (Car)",
	Model = "models/nova/airboat_seat.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A Seat from VALVe's Airboat with steering wheel animations",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleVehicleAnimation,
	}
}, "Seat_Airboat_Wheel" )

AddVehicle( {
	Name = "Office Chair (Car)",
	Model = "models/nova/chair_office01.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A Small Office Chair with steering wheel animations",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleVehicleAnimation,
	}
}, "Chair_Office1_Wheel" )

AddVehicle( {
	Name = "Big Office Chair (Car)",
	Model = "models/nova/chair_office02.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A Big Office Chair with steering wheel animations",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleVehicleAnimation,
	}
}, "Chair_Office2_Wheel" )

if ( IsMounted( "ep2" ) ) then 
	AddVehicle( {
		Name = "Jalopy Seat (Car)",
		Model = "models/nova/jalopy_seat.mdl",
		Class = "prop_vehicle_prisoner_pod",
		Category = Category,

		Author = "VALVe",
		Information = "A Seat from VALVe's Jalopy with steering wheel animations",

		KeyValues = {
			vehiclescript = "scripts/vehicles/prisoner_pod.txt",
			limitview = "0"
		},
		Members = {
			HandleAnimation = HandleVehicleAnimation,
		}
	} , "Seat_Jalopy_Wheel" )
end

AddVehicle( {
	Name = "Wooden Chair (Airboat)",
	Model = "models/nova/chair_wood01.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A Wooden Chair with Airboat animations",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleAirboatAnimation,
	}
}, "Chair_Wood_Airboat" )

AddVehicle( {
	Name = "Chair (Airboat)",
	Model = "models/nova/chair_plastic01.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A Plastic Chair with Airboat animations",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleAirboatAnimation,
	}
}, "Chair_Plastic_Airboat" )

AddVehicle( {
	Name = "Jeep Seat (Airboat)",
	Model = "models/nova/jeep_seat.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A Seat from VALVe's Jeep with Airboat animations",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleAirboatAnimation,
	}
}, "Seat_Jeep_Airboat" )

AddVehicle( {
	Name = "Airboat Seat (Airboat)",
	Model = "models/nova/airboat_seat.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A Seat from VALVe's Airboat with Airboat animations",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleAirboatAnimation,
	}
}, "Seat_Airboat_Airboat" )

AddVehicle( {
	Name = "Office Chair (Airboat)",
	Model = "models/nova/chair_office01.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A Small Office Chair with Airboat animations",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleAirboatAnimation,
	}
}, "Chair_Office1_Airboat" )

AddVehicle( {
	Name = "Big Office Chair (Airboat)",
	Model = "models/nova/chair_office02.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe",
	Information = "A Big Office Chair with Airboat animations",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleAirboatAnimation,
	}
}, "Chair_Office2_Airboat" )

if ( IsMounted( "ep2" ) ) then 
	AddVehicle( {
		Name = "Jalopy Seat (Airboat)",
		Model = "models/nova/jalopy_seat.mdl",
		Class = "prop_vehicle_prisoner_pod",
		Category = Category,

		Author = "VALVe",
		Information = "A Seat from VALVe's Jalopy with Airboat animations",

		KeyValues = {
			vehiclescript = "scripts/vehicles/prisoner_pod.txt",
			limitview = "0"
		},
		Members = {
			HandleAnimation = HandleAirboatAnimation,
		}
	} , "Seat_Jalopy_Airboat" )
end