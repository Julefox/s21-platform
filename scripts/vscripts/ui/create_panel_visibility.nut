global function InitR5RVisPanel

struct
{
	var menu
	var panel
	var listPanel
	table<var, int> vis_button_table
	bool built = false
} file

array<int> createVisibilityOptions = [
	eServerVisibility.OFFLINE,
	eServerVisibility.HIDDEN,
	eServerVisibility.PUBLIC
]

void function InitR5RVisPanel( var panel )
{
	file.panel = panel
	file.menu = GetPanel( "CreatePanel" )
	file.listPanel = Hud_GetChild( panel, "VisList" )

	if ( file.built )
		return

	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )
	Hud_InitGridButtons( file.listPanel, createVisibilityOptions.len() )

	foreach ( int id, int vis in createVisibilityOptions )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + id )
		var rui = Hud_GetRui( button )
		RuiSetString( rui, "buttonText", GetUIVisibilityName( vis ) )

		Hud_AddEventHandler( button, UIE_CLICK, SelectServerVis )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnVisHover )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, OnVisUnHover )

		file.vis_button_table[button] <- vis
	}

	file.built = true
}

void function SelectServerVis( var button )
{
	if ( !( button in file.vis_button_table ) )
		return

	EmitUISound( "menu_accept" )
	SetSelectedServerVis( file.vis_button_table[button] )
}

void function OnVisHover( var button )
{
	if ( !( button in file.vis_button_table ) )
		return

	Hud_SetText( Hud_GetChild( file.menu, "VisInfoEdit" ), GetUIVisibilityName( file.vis_button_table[button] ) )
}

void function OnVisUnHover( var button )
{
	Hud_SetText( Hud_GetChild( file.menu, "VisInfoEdit" ), GetUIVisibilityName( ServerSettings.svVisibility ) )
}
