global function InitR5RMapPanel
global function RefreshUIMaps

struct
{
	var menu
	var panel
	var listPanel
	table<var, string> map_button_table
} file

void function InitR5RMapPanel( var panel )
{
	file.panel = panel
	file.menu = GetPanel( "CreatePanel" )
	file.listPanel = Hud_GetChild( panel, "MapList" )
}

void function RefreshUIMaps()
{
	if ( file.listPanel == null )
		return

	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )
	array<string> availableMapsForPlaylist = GetCreatePlaylistMaps( ServerSettings.svPlaylist )
	Hud_InitGridButtons( file.listPanel, availableMapsForPlaylist.len() )

	foreach ( int id, string map in availableMapsForPlaylist )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + id )
		var rui = Hud_GetRui( button )
		RuiSetString( rui, "buttonText", GetUIMapName( map ) )

		// Bind once per button instance; always refresh the map id mapping.
		if ( !( button in file.map_button_table ) )
		{
			Hud_AddEventHandler( button, UIE_CLICK, SelectServerMap )
			Hud_AddEventHandler( button, UIE_GET_FOCUS, OnMapHover )
			Hud_AddEventHandler( button, UIE_LOSE_FOCUS, OnMapUnHover )
			file.map_button_table[button] <- map
		}
		else
		{
			file.map_button_table[button] = map
		}
	}

	Hud_SetHeight( Hud_GetChild( file.panel, "PanelBG" ), Hud_GetHeight( file.listPanel ) + 1 )
}

void function SelectServerMap( var button )
{
	if ( !( button in file.map_button_table ) )
		return

	EmitUISound( "menu_accept" )
	SetSelectedServerMap( file.map_button_table[button] )
}

void function OnMapHover( var button )
{
	if ( !( button in file.map_button_table ) )
		return

	RuiSetImage( Hud_GetRui( Hud_GetChild( file.menu, "ServerMapImg" ) ), "basicImage", GetUIMapAsset( file.map_button_table[button] ) )
}

void function OnMapUnHover( var button )
{
	RuiSetImage( Hud_GetRui( Hud_GetChild( file.menu, "ServerMapImg" ) ), "basicImage", GetUIMapAsset( ServerSettings.svMapName ) )
}
