
AddCSLuaFile()

local default_animations = { "idle_all_01", "menu_walk" }

list.Set( "DesktopWindows", "AccelerationGarageControl", {

	title		= "Garage Control",
	icon		= "icon64/pitstop.png",
	width		= 460,
	height		= 350,
	onewindow	= true,
	init		= function( icon, window )
		local pitstop = Car.GetPitstop(LocalPlayer())
		if not IsValid(pitstop) then
			Derma_Message( Car.Msgs.PitstopMsgs.NoPitstop, "Garage Control", "OK" )
			window:Close()
			return
		end
		--START SIDE PANEL
		local mat = vgui.Create( "AngleSelect", window )
		mat:SetMaterial( "gm_acceleration/hud/angle_3" )
		mat:SetPos( 40, 30 )
		mat:SetSize( 96, 96 )

		local mat2 = vgui.Create( "AngleSelect", window )
		mat2:SetMaterial( "gm_acceleration/hud/angle_1" )
		mat2:SetPos( 40, 30+106 )
		mat2:SetSize( 96, 96 )
		
		local mat3 = vgui.Create( "AngleSelect", window )
		mat3:SetMaterial( "gm_acceleration/hud/angle_2" )
		mat3:SetPos( 40, 30+106+106 )
		mat3:SetSize( 96, 96 )
		mat3.OnValueChanged = onValChanged
		
		local onValChanged = function(panel,ang)
			net.Start("car_pit_angle")
			local p = mat:GetValue()
			p = (p - 360) * -1
			net.WriteAngle(Angle(p,mat2:GetValue(),mat3:GetValue()))
			net.SendToServer()
		end
		mat.OnValueChanged = onValChanged
		mat2.OnValueChanged = onValChanged
		mat3.OnValueChanged = onValChanged
		
		local updown = vgui.Create( "DAlphaBar", window )
		updown:SetPos( 10, 30 )
		updown:SetSize( 18, 310 )
		updown:SetValue(0)
		updown.OnChange = function( self,num )
			net.Start("car_pit_pos")
			net.WriteUInt(math.Round((num-1)*-170),8)
			net.SendToServer()
		end
		--END SIDE PANEL
		
		local DScrollPanel = vgui.Create( "DScrollPanel", window )
		DScrollPanel:SetSize( 300, 310 )
		DScrollPanel:SetPos( 150, 30 )
		
		--START MAIN CONTROLS
		
		
		--END MAIN CONTROLS
		
		--START FRIEND LIST
		local DCollapsible = vgui.Create( "DCollapsibleCategory", DScrollPanel )	// Create a collapsible category
		DCollapsible:SetSize( 300, 24 )										 // Set size
		DCollapsible:SetExpanded( 0 )											 // Is it expanded when you open the panel?
		DCollapsible:SetLabel( "Friends List" )							// Set the name ( label )
		DScrollPanel:AddItem(DCollapsible )
		
		local DermaList = vgui.Create( "DPanelList", DermaPanel )	// Make a list of items to add to our category ( collection of controls )
		DermaList:SetSpacing( 5 )							 // Set the spacing between items
		DermaList:EnableHorizontal( false )					// Only vertical items
		DermaList:EnableVerticalScrollbar( true )			 // Enable the scrollbar if ( the contents are too wide
		DCollapsible:SetContents( DermaList )					// Add DPanelList to our Collapsible Category

		local AppList = vgui.Create( "DListView" )
		AppList:SetMultiSelect( false )
		AppList:AddColumn( "Question" )
		AppList:AddColumn( "Answer" )

		AppList:AddLine( "WorkingYet", "No" )
		AppList:AddLine( "Why", "Lazyness" )
		AppList:AddLine( "When", "Sometime" )
		AppList:SetSize( 300, 100 )	
		DermaList:AddItem( AppList )						// Add the checkbox to the category

		local CategoryContentTwo = vgui.Create( "DLabel" )			// Make some more content
		CategoryContentTwo:SetText( "Hello" )
		DermaList:AddItem( CategoryContentTwo )
		--END FRIEND LIST
		
	end
} )
