function GM:GetFallDamage( ply, speed )
	speed = speed - 580
	return speed * (100/(1024-580))
end