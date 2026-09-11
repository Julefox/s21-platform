// Credits — modern vertical scroll list + hover tooltips + detail pane.
// Rumble reference for this feel: cup overview / cups list (vertical rows + RTK tooltips).
// Horizontal page-carousel backup: lobby_panel_credits2.nutui + credits2.res

global function InitCreditPanel

struct CreditEntry
{
	string name
	string role
	string body
	string tooltipTitle
	string tooltipBody
	asset  image
	int    quality
}

struct
{
	var panel
	var listPanel

	array<CreditEntry> entries
	table<var, int> buttonIndexTable
	int selectedIndex = 0
	bool hasLoaded = false
} file

void function InitCreditPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "CreditsList" )

	SetPanelTabTitle( panel, "Credits" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CreditsPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CreditsPanel_OnHide )
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

void function CreditsPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.BATTLE_PASS_3 )

	if ( !file.hasLoaded )
	{
		Credits_BuildEntries()
		Credits_PopulateList()
		file.hasLoaded = true
	}

	Credits_Select( file.selectedIndex, true )
}

void function CreditsPanel_OnHide( var panel )
{
}

void function Credits_BuildEntries()
{
	file.entries.clear()

	CreditEntry a
	a.name = "CafeFPS"
	a.role = "S21 Bridge"
	a.body = "Client / dedi bridge, systems work, and shipping the stack that makes this lobby run."
	a.tooltipTitle = "CafeFPS"
	a.tooltipBody = Localize( "#BRIDGE_CREDITS_LEAD_DESC" )
	a.image = $"rui/menu/apex_rumble/about_rumble_enter"
	a.quality = 4
	file.entries.append( a )

	CreditEntry b
	b.name = "R5Reloaded"
	b.role = "SDK Foundation"
	b.body = "Original r5sdk, lobby browser patterns, and the tooling base the bridge stands on."
	b.tooltipTitle = "R5Reloaded"
	b.tooltipBody = "SDK / lobby browser DNA this project builds on."
	b.image = $"rui/menu/apex_rumble/about_rumble_points"
	b.quality = 3
	file.entries.append( b )

	CreditEntry c
	c.name = Localize( "#BRIDGE_CREDITS_CONTRIBUTORS" )
	c.role = Localize( "#BRIDGE_CREDITS_COMMUNITY" )
	c.body = "Everyone who tested, documented, and shipped pieces of this stack."
	c.tooltipTitle = Localize( "#BRIDGE_CREDITS_CONTRIBUTORS" )
	c.tooltipBody = "Testing, docs, assets — the people who made shipping possible."
	c.image = $"rui/menu/apex_rumble/about_rumble_rewards"
	c.quality = 2
	file.entries.append( c )
}

void function Credits_PopulateList()
{
	file.buttonIndexTable.clear()

	int numRows = file.entries.len()
	Hud_InitGridButtons( file.listPanel, numRows )

	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	for ( int i = 0; i < numRows; i++ )
	{
		CreditEntry entry = file.entries[i]
		var button = Hud_GetChild( scrollPanel, "GridButton" + i )
		file.buttonIndexTable[button] <- i

		var rui = Hud_GetRui( button )
		// "Name  —  Role" reads like modern cup / reward rows
		RuiSetString( rui, "buttonText", entry.name + "  ·  " + entry.role )
		RuiSetInt( rui, "quality", entry.quality )
		Hud_SetEnabled( button, true )

		// Cool native tooltip (Rumble overview energy)
		ToolTipData tt
		tt.titleText = entry.tooltipTitle
		tt.descText = entry.tooltipBody
		Hud_SetToolTipData( button, tt )

		AddButtonEventHandler( button, UIE_CLICK, Credits_OnClick )
		AddButtonEventHandler( button, UIE_GET_FOCUS, Credits_OnHover )
		AddButtonEventHandler( button, UIE_LOSE_FOCUS, Credits_OnUnHover )
	}
}

void function Credits_OnClick( var button )
{
	if ( !( button in file.buttonIndexTable ) )
		return
	Credits_Select( file.buttonIndexTable[button], false )
}

void function Credits_OnHover( var button )
{
	if ( !( button in file.buttonIndexTable ) )
		return
	// Preview detail without pinning selection
	Credits_ApplyDetail( file.buttonIndexTable[button] )
}

void function Credits_OnUnHover( var button )
{
	// Snap detail back to pinned selection
	Credits_ApplyDetail( file.selectedIndex )
}

void function Credits_Select( int index, bool silent )
{
	if ( index < 0 || index >= file.entries.len() )
		return

	file.selectedIndex = index
	Credits_ApplyDetail( index )

	if ( !silent )
		EmitUISound( "UI_Menu_Accept" )
}

void function Credits_ApplyDetail( int index )
{
	if ( index < 0 || index >= file.entries.len() )
		return

	CreditEntry entry = file.entries[index]

	Hud_SetText( Hud_GetChild( file.panel, "DetailName" ), entry.name )
	Hud_SetText( Hud_GetChild( file.panel, "DetailRole" ), entry.role )
	Hud_SetText( Hud_GetChild( file.panel, "DetailBody" ), entry.body )
	RuiSetImage( Hud_GetRui( Hud_GetChild( file.panel, "DetailImage" ) ), "basicImage", entry.image )

	// Keep legacy hidden labels in sync if anything still reads them
	Hud_SetText( Hud_GetChild( file.panel, "Name" ), entry.name )
	Hud_SetText( Hud_GetChild( file.panel, "DescriptionShort" ), entry.role )
	Hud_SetText( Hud_GetChild( file.panel, "Description" ), entry.body )
}
