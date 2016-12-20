
AddCSLuaFile()
local savingFile = false
local loadingFile = false
local function DoShit(filename,save)
	filename = string.lower(filename)
	if string.sub(filename,#filename-3) != ".dat" then
		filename = filename .. ".dat"
	end
	if save then
		if savingFile then
			Derma_Message( Car.Msgs.Generic.SaveWait, "Acceleration", Car.Msgs.Generic.OK )
			return
		end
		savingFile = filename
		net.Start("car_pitcontrol_save")
		net.SendToServer()
		
	elseif file.Exists(filename,"DATA") then
		if loadingFile then
			Derma_Message( Car.Msgs.Generic.LoadWait, "Acceleration", Car.Msgs.Generic.OK )
			return
		end
		loadingFile = true
		ARCLib.SendBigMessage("car_pitcontrol_save_dl",file.Read(filename,"DATA") or "",ply,function(err,per)
			if err == ARCLib.NET_UPLOADING then
				chat.AddText( "Loading car... "..math.floor(per*100).."%" )
			elseif err == ARCLib.NET_COMPLETE then
				chat.AddText( "Loaded car! " )
				loadingFile = false
			else
				chat.AddText( "Loading car error! "..err )
				loadingFile = false
			end
		end) 
	else
		Derma_Message( Car.Msgs.Generic.InvalidFileName, "Acceleration", Car.Msgs.Generic.OK )
	end
end
ARCLib.ReceiveBigMessage("car_pitcontrol_save_dl",function(err,per,data,ply)
	if err == ARCLib.NET_DOWNLOADING then
		chat.AddText( "Saving car... "..math.floor(per*100).."%" )
	elseif err == ARCLib.NET_COMPLETE then
		if savingFile then
			file.Write(savingFile,data)
			chat.AddText( "Saved car as "..savingFile )
		end
	else
		chat.AddText( "Saving car error! "..err )
	end
end)
--Car.Msgs.Generic.SaveWait

local function SaveMenu(save)
	local basefol = Car.Dir.."/saved_cars"
	local frame = vgui.Create( "DFrame" )
	frame:SetSize( 498, 322 )
	frame:SetSizable( true )
	frame:Center()
	frame:MakePopup()
	frame:SetTitle( "Acceleration" )
	
	local browser = vgui.Create( "DFileBrowser", frame )
	--browser:Dock( FILL )
	browser:SetPos(2,24+24)
	browser:SetSize(494,246)
	browser:SetPath( "DATA" ) -- The access path i.e. GAME, LUA, DATA etc.
	browser:SetBaseFolder( basefol ) -- The root folder
	browser:SetCurrentFolder( "" )
	local Filename = vgui.Create( "DTextEntry", frame ) -- create the form as a child of frame
	Filename:SetPos( 2, 272+24 )
	Filename:SetSize( 302, 24 )
	Filename:SetText( "Untitled.dat" )
	function browser:OnSelect( path, pnl )
		Filename:SetText( string.GetFileFromFilename( path ))
	end
	function browser:OnDoubleClick( path, pnl )
		DoShit((browser:GetCurrentFolder() or basefol).."/"..Filename:GetText(),save)
		frame:Close()
	end
	
	local Savebutt = vgui.Create( "DButton", frame )
	if save then
		Savebutt:SetText( Car.Msgs.Generic.Save )
	else
		Savebutt:SetText( Car.Msgs.Generic.Load )
	end
	Savebutt:SetPos( 304, 272+24 )
	Savebutt:SetSize( 96, 24 )
	Savebutt.DoClick = function(self)
		DoShit((browser:GetCurrentFolder() or basefol).."/"..Filename:GetText(),save)
		frame:Close()
	end
	local Closebutt = vgui.Create( "DButton", frame )
	Closebutt:SetText( Car.Msgs.Generic.Cancel )
	Closebutt:SetPos( 400, 272+24 )
	Closebutt:SetSize( 96, 24 )
	Closebutt.DoClick = function(self)
		frame:Close()
	end
	
	local NewButt = vgui.Create( "DButton", frame )
	NewButt:SetImage( "icon16/folder_add.png" )
	NewButt:SetText("")
	NewButt:SetPos( 2,24 )
	NewButt:SetSize( 24, 24 )
	NewButt.DoClick = function(self)
		local fol = browser:GetCurrentFolder()
		if not fol then
			LocalPlayer():EmitSound("common/wpn_denyselect.wav" )
			return
		end
		Derma_StringRequest( "Acceleration", Car.Msgs.Generic.FolderName, Car.Msgs.Generic.NewFolder, function(text)
			file.CreateDir( fol.."/"..text )
			browser:SetBaseFolder( basefol )
			browser:SetCurrentFolder( string.sub(fol,#basefol+2).."/"..text)
		end, nil, Car.Msgs.Generic.OK, Car.Msgs.Generic.Cancel ) 
	end
	local FolDelButt = vgui.Create( "DButton", frame )
	FolDelButt:SetImage( "icon16/folder_delete.png" )
	FolDelButt:SetText("")
	FolDelButt:SetPos( 2+24,24 )
	FolDelButt:SetSize( 24, 24 )
	FolDelButt.DoClick = function(self)
		local fol = browser:GetCurrentFolder()
		if not fol or #fol <= 34 then
			LocalPlayer():EmitSound("common/wpn_denyselect.wav" )
			return
		end
		while fol[#fol] == "/" do
			fol = string.sub(a,1,#fol-1)
		end
		ARCLib.DeleteAll(fol)
		browser:SetBaseFolder( basefol ) -- TODO: Only do this based on the current folder
		browser:SetCurrentFolder( "" )
	end
	local RenameButt = vgui.Create( "DButton", frame )
	RenameButt:SetImage( "icon16/page_edit.png" )
	RenameButt:SetText("")
	RenameButt:SetPos( 2+24*2,24 )
	RenameButt:SetSize( 24, 24 )
	RenameButt.DoClick = function(self)
		local fol = browser:GetCurrentFolder()
		if not fol then
			LocalPlayer():EmitSound("common/wpn_denyselect.wav" )
			return
		end
		local filename = fol.."/"..Filename:GetText()
		if not file.Exists( filename, "DATA" ) then
			LocalPlayer():EmitSound("common/wpn_denyselect.wav" )
			return
		end
		local path = string.GetPathFromFilename( filename ) 
		local name = string.GetFileFromFilename( filename ) 
		Derma_StringRequest( "Acceleration", Car.Msgs.Generic.FileName, name, function(text)
			local GModNeedsAFuckingRenameFunction = file.Read(filename,"DATA")
			local newfilename = path..text
			file.Write(newfilename)
			if file.Exists(newfilename,"DATA") then
				file.Delete(filename)
				browser:SetBaseFolder( basefol )
				browser:SetCurrentFolder( string.sub(fol,#basefol+2))
			else
				Derma_Message( Car.Msgs.Generic.InvalidFileName, "Acceleration", Car.Msgs.Generic.OK )
			end
			
		end, nil, Car.Msgs.Generic.OK, Car.Msgs.Generic.Cancel ) 
	end
	local PropertyButt = vgui.Create( "DButton", frame )
	PropertyButt:SetImage( "icon16/page_gear.png" )
	PropertyButt:SetText("")
	PropertyButt:SetPos( 2+24*3,24 )
	PropertyButt:SetSize( 24, 24 )
	PropertyButt.DoClick = function(self)
		local fol = browser:GetCurrentFolder()
		if not fol then
			LocalPlayer():EmitSound("common/wpn_denyselect.wav" )
			return
		end
		local filename = fol.."/"..Filename:GetText()
		if not file.Exists( filename, "DATA" ) then
			LocalPlayer():EmitSound("common/wpn_denyselect.wav" )
			return
		end
		Derma_Message( file.Size( filename, "DATA" ).."B\n"..os.date( "%c", file.Time( filename, "DATA" ) )  , filename, Car.Msgs.Generic.OK )
	end
	local DeleteButt = vgui.Create( "DButton", frame )
	DeleteButt:SetImage( "icon16/page_delete.png" )
	DeleteButt:SetText("")
	DeleteButt:SetPos( 2+24*4,24 )
	DeleteButt:SetSize( 24, 24 )
	DeleteButt.DoClick = function(self)
		local fol = browser:GetCurrentFolder()
		if not fol then
			LocalPlayer():EmitSound("common/wpn_denyselect.wav" )
			return
		end
		local filename = fol.."/"..Filename:GetText()
		if not file.Exists( filename, "DATA" ) then
			LocalPlayer():EmitSound("common/wpn_denyselect.wav" )
			return
		end
		--Car.Msgs.Generic.DeleteSure
		Derma_Query( ARCLib.PlaceholderReplace(Car.Msgs.Generic.DeleteSure,{FILE=Filename:GetText()}), Car.Msgs.Generic.Delete, Car.Msgs.Generic.Yes, function()
			file.Delete( filename )
			browser:SetCurrentFolder( string.sub(browser:GetCurrentFolder() or basefol,#basefol+2))
		end, Car.Msgs.Generic.No)
	end
	local RefreshButt = vgui.Create( "DButton", frame )
	RefreshButt:SetImage( "icon16/arrow_rotate_clockwise.png" )
	RefreshButt:SetText("")
	RefreshButt:SetPos( 498-26,24 )
	RefreshButt:SetSize( 24, 24 )
	RefreshButt.DoClick = function(self)
		browser:SetCurrentFolder( string.sub(browser:GetCurrentFolder() or basefol,#basefol+2))
	end
	function browser:OnRightClick( path, pnl )
		local Menu = vgui.Create( "DMenu" )
		if not save then
			local btnWithIcon = Menu:AddOption( Car.Msgs.Generic.Load ,Savebutt.DoClick)
			btnWithIcon:SetIcon( "icon16/page_go.png" )
			Menu:AddSpacer()
		end
		local btnWithIcon = Menu:AddOption( Car.Msgs.Generic.Rename ,RenameButt.DoClick)
		btnWithIcon:SetIcon( "icon16/page_edit.png" )
		local btnWithIcon = Menu:AddOption( Car.Msgs.Generic.Properties ,PropertyButt.DoClick)
		btnWithIcon:SetIcon( "icon16/page_gear.png" )
		local btnWithIcon = Menu:AddOption( Car.Msgs.Generic.Delete ,DeleteButt.DoClick)
		btnWithIcon:SetIcon( "icon16/page_delete.png" )
		Menu:Open()
	end
end

local nagCenter = true

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
			net.Start("car_pitcontrol_angle")
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
			net.Start("car_pitcontrol_pos")
			net.WriteUInt(math.Round((num-1)*-156),8)
			net.SendToServer()
		end
		--END SIDE PANEL
		
		--TODO: SWITCH TO http://wiki.garrysmod.com/page/Category:DCategoryList
		local DScrollPanel = vgui.Create( "DPanelList", window )
		DScrollPanel:SetSize( 300, 310 )
		DScrollPanel:SetPos( 150, 30 )
		DScrollPanel:SetSpacing( 5 )
		
		
		--START FILE LIST
		local DCollapsible = vgui.Create( "DCollapsibleCategory" )	// Create a collapsible category
		DCollapsible:SetSize( 300, 24 )										 // Set size
		DCollapsible:SetExpanded( 1 )											 // Is it expanded when you open the panel?
		DCollapsible:SetLabel( "File" )							// Set the name ( label )
		DScrollPanel:AddItem(DCollapsible )
		
		local DermaList = vgui.Create( "DPanelList", DermaPanel )
		DermaList:SetSpacing( 2 )
		DermaList:EnableHorizontal( false )
		DermaList:EnableVerticalScrollbar( true )
		DCollapsible:SetContents( DermaList )
		
		local DButton = vgui.Create( "DButton" )
		DButton:SetText( "Build mode" )
		DButton.DoClick = function(self)
		
		end
		DermaList:AddItem( DButton )
		local DButton = vgui.Create( "DButton" )
		DButton:SetText( "Load car" )
		DButton.DoClick = function(self)
			SaveMenu(false)
		end
		DermaList:AddItem( DButton )
		local DButton = vgui.Create( "DButton" )
		DButton:SetText( "Save car" )
		DButton.DoClick = function(self)
			SaveMenu(true)
		end
		DermaList:AddItem( DButton )
		local DButton = vgui.Create( "DButton" )
		DButton:SetText( "Deploy Car" )
		DButton.DoClick = function(self)
			if nagCenter then
				Derma_Message( Car.Msgs.PitstopMsgs.MassCenterWarning, "Acceleration", Car.Msgs.Generic.OK )
				nagCenter = false
			end
			net.Start("car_pitcontrol_deploy")
			net.SendToServer()
		end
		DermaList:AddItem( DButton )
		--END FILE LIST
		
		--START FRIEND LIST
		local DCollapsible = vgui.Create( "DCollapsibleCategory" )	// Create a collapsible category
		DCollapsible:SetSize( 300, 24 )										 // Set size
		DCollapsible:SetExpanded( 0 )											 // Is it expanded when you open the panel?
		DCollapsible:SetLabel( "Friends List" )							// Set the name ( label )
		DScrollPanel:AddItem(DCollapsible )
		
		local DermaList = vgui.Create( "DPanelList", DermaPanel )	// Make a list of items to add to our category ( collection of controls )
		DermaList:SetSpacing( 5 )							 // Set the spacing between items
		DermaList:EnableHorizontal( false )					// Only vertical items
		DermaList:EnableVerticalScrollbar( true )
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

