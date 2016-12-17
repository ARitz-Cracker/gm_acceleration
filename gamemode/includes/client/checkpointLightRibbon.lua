--[[--------------------------------------------------------------------------------------
 _______                     ______                      _____ _____                
 ___    |___________________ ___  /_____ ______________ ___  /____(_)______ _______ 
 __  /| |_  ___/_  ___/_  _ \__  / _  _ \__  ___/_  __ `/_  __/__  / _  __ \__  __ \
 _  ___ |/ /__  / /__  /  __/_  /  /  __/_  /    / /_/ / / /_  _  /  / /_/ /_  / / /
 /_/  |_|\___/  \___/  \___/ /_/   \___/ /_/     \__,_/  \__/  /_/   \____/ /_/ /_/ 
 
 
	By Aritz Beobide-Cardinal (ARitz Cracker) && James R Swift (James xX)
 
--------------------------------------------------------------------------------------]]--

local _mat = Material( "editor/wireframe" )
local _attachmentNameTop = "barriar_attachment_top"
local _attachmentNameBot = "barriar_attachment_bot"
local _checkpointMeshObjects = {}

local function _createMeshForCheckpoint( eCheckpoint )

	print ( "Light ribbon called on " , eCheckpoint )

	if ( not IsValid( eCheckpoint ) ) then return end
	if ( _checkpointMeshObjects[ eCheckpoint:GetCheckpointID() ] ) then return end
	if ( eCheckpoint:IsSlave( ) ) then return end

	local counterpart = eCheckpoint:GetCounterpart( )
	if ( not IsValid( counterpart ) ) then return end
	
	_checkpointMeshObjects[ eCheckpoint:GetCheckpointID( ) ]  = Mesh( _mat )
	local _mesh = _checkpointMeshObjects[ eCheckpoint:GetCheckpointID() ]
	
	local AttachmentID_top = eCheckpoint:LookupAttachment( _attachmentNameTop )
	local AttachmentID_bot = eCheckpoint:LookupAttachment( _attachmentNameBot )
	
	local verts = {
		{ pos = eCheckpoint:GetAttachment( AttachmentID_top ).Pos, u = 0, v = 0 },
		{ pos = eCheckpoint:GetAttachment( AttachmentID_bot ).Pos, u = 0, v = 1 },
		{ pos = counterpart:GetAttachment( AttachmentID_bot ).Pos, u = 1, v = 1 },
		
		{ pos = eCheckpoint:GetAttachment( AttachmentID_top ).Pos, u = 0, v = 0 },
		{ pos = counterpart:GetAttachment( AttachmentID_bot ).Pos, u = 1, v = 1 },
		{ pos = counterpart:GetAttachment( AttachmentID_top ).Pos, u = 1, v = 0 },
		
		{ pos = eCheckpoint:GetAttachment( AttachmentID_bot ).Pos, u = 0, v = 1 },
		{ pos = eCheckpoint:GetAttachment( AttachmentID_top ).Pos, u = 0, v = 0 },
		{ pos = counterpart:GetAttachment( AttachmentID_bot ).Pos, u = 1, v = 1 },
		
		{ pos = counterpart:GetAttachment( AttachmentID_bot ).Pos, u = 1, v = 1 },
		{ pos = eCheckpoint:GetAttachment( AttachmentID_top ).Pos, u = 0, v = 0 },
		{ pos = counterpart:GetAttachment( AttachmentID_top ).Pos, u = 1, v = 0 }
	}

	_mesh:BuildFromTriangles( verts ) -- Load the vertices into the IMesh object

end

hook.Add( "PostDrawOpaqueRenderables", "checkpointLightRibbon", function()

	for checkpointID, mesh in pairs( _checkpointMeshObjects ) do

		render.SetMaterial( _mat ) -- Apply the material
		mesh:Draw() -- Draw the mesh
		
	end
	
end )

hook.Add( "InitPostEntity", "checkpointLightRibbon", function ()

	timer.Simple( 1, function( )
	for k, eCheckpoint in pairs( ents.FindByClass( "sent_acc_checkpoint" ) ) do
	
		_createMeshForCheckpoint( eCheckpoint )
		
	end
	end)

end)