global function InitR5RPlaylistPanel
global function RefreshUIPlaylists

struct
{
	var menu
	var panel
	var listPanel
	table<var, string> playlist_button_table
} file

void function InitR5RPlaylistPanel( var panel )
{
	file.panel = panel
	file.menu = GetPanel( "CreatePanel" )
	file.listPanel = Hud_GetChild( panel, "PlaylistList" )
}

void function RefreshUIPlaylists()
{
	if ( file.listPanel == null )
		return

	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )
	array<string> visiblePlaylists = GetVisiblePlaylistsForCreate()
	Hud_InitGridButtons( file.listPanel, visiblePlaylists.len() )

	foreach ( int id, string playlist in visiblePlaylists )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + id )
		var rui = Hud_GetRui( button )
		RuiSetString( rui, "buttonText", GetUIPlaylistName( playlist ) )

		if ( !( button in file.playlist_button_table ) )
		{
			Hud_AddEventHandler( button, UIE_CLICK, SelectServerPlaylist )
			Hud_AddEventHandler( button, UIE_GET_FOCUS, OnPlaylistHover )
			Hud_AddEventHandler( button, UIE_LOSE_FOCUS, OnPlaylistUnHover )
			file.playlist_button_table[button] <- playlist
		}
		else
		{
			file.playlist_button_table[button] = playlist
		}
	}

	Hud_SetHeight( Hud_GetChild( file.panel, "PanelBG" ), Hud_GetHeight( file.listPanel ) + 1 )
}

array<string> function GetVisiblePlaylistsForCreate()
{
	array<string> visiblePlaylists

	// TODO(bridge-create): late-reg GetAvailablePlaylists for UI VM (S21 bulk
	// Script_RegisterUIFunctions is skipped). Until then use a static bridge set
	// so the Create tab always paints a usable list.
	//
	// Prefer playlists that still resolve name/visible flags from the loaded
	// playlist table when present.
	array<string> candidates = [
		"survival_dev",
		"survival",
		"custom_tdm",
		"custom_ctf",
		"fs_aimtrainer"
	]

	foreach ( string playlist in candidates )
	{
		// Keep entries even if the name string is the raw id — UI still works.
		if ( GetPlaylistVarBool( playlist, "visible", true ) )
			visiblePlaylists.append( playlist )
	}

	if ( visiblePlaylists.len() == 0 )
	{
		visiblePlaylists.append( "survival_dev" )
		visiblePlaylists.append( "survival" )
	}

	return visiblePlaylists
}

void function SelectServerPlaylist( var button )
{
	if ( !( button in file.playlist_button_table ) )
		return

	EmitUISound( "menu_accept" )
	thread SetSelectedServerPlaylist( file.playlist_button_table[button] )
}

void function OnPlaylistHover( var button )
{
	if ( !( button in file.playlist_button_table ) )
		return

	Hud_SetText( Hud_GetChild( file.menu, "PlaylistInfoEdit" ), GetUIPlaylistName( file.playlist_button_table[button] ) )
}

void function OnPlaylistUnHover( var button )
{
	Hud_SetText( Hud_GetChild( file.menu, "PlaylistInfoEdit" ), GetUIPlaylistName( ServerSettings.svPlaylist ) )
}
