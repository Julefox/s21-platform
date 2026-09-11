// Lobby Servers tab: thin host over serverbrowser_shared.nut.

global function InitServerBrowserPanel

struct
{
	var panel
	var menu
} file

void function InitServerBrowserPanel( var panel )
{
	SetPanelTabTitle( panel, "Servers" )
	file.panel = panel
	file.menu = GetParentMenu( panel )

	ServerBrowserShared_WireControls( panel, file.menu )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, ServerBrowser_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, ServerBrowser_OnHide )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

void function ServerBrowser_OnShow( var panel )
{
	// Lobby-only chrome. Shared lib must never call this.
	UI_SetPresentationType( ePresentationType.COLLECTION_EVENT )

	ServerBrowserShared_Bind( panel, GetParentMenu( panel ) )
	ServerBrowserShared_OnShow()
}

void function ServerBrowser_OnHide( var panel )
{
	ServerBrowserShared_OnHide()
}
