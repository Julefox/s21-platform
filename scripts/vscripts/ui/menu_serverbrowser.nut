// Main-menu server browser host. UI VM only. No presentation types, no Client.

global function InitServerBrowserMenu
global function InitMainMenuServerBrowserPanel
global function OpenMainMenuServerBrowser
global function ServerBrowser_EnsureMainMenu

struct
{
	var menu
	var panel
} file

void function InitServerBrowserMenu( var newMenuArg )
{
	var menu = GetMenu( "ServerBrowserMenu" )
	file.menu = menu

	SetGamepadCursorEnabled( menu, true )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ServerBrowserMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ServerBrowserMenu_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ServerBrowserMenu_OnNavBack )
	AddMenuEventHandler( menu, eUIEvent.MENU_GET_TOP_LEVEL, ServerBrowserMenu_OnGetTopLevel )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "#BRIDGE_SB_FOOTER_REFRESH", "#BRIDGE_SB_FOOTER_REFRESH", ServerBrowserMenu_FooterRefresh )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#BRIDGE_SB_FOOTER_CONNECT", "#BRIDGE_SB_FOOTER_CONNECT", ServerBrowserMenu_FooterConnect )
}

void function InitMainMenuServerBrowserPanel( var panel )
{
	file.panel = panel
	var menu = GetParentMenu( panel )

	ServerBrowserShared_WireControls( panel, menu )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, MainMenuServerBrowserPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, MainMenuServerBrowserPanel_OnHide )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#BRIDGE_SB_FOOTER_REFRESH", "#BRIDGE_SB_FOOTER_REFRESH", ServerBrowserMenu_FooterRefresh )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, true, "#BRIDGE_SB_FOOTER_CONNECT", "#BRIDGE_SB_FOOTER_CONNECT", ServerBrowserMenu_FooterConnect )
}

void function OpenMainMenuServerBrowser( var button )
{
	AdvanceMenu( GetMenu( "ServerBrowserMenu" ) )
}

void function ServerBrowserMenu_ForceBackdrop()
{
	if ( file.menu == null )
		return

	if ( Hud_HasChild( file.menu, "DarkenBackground" ) )
		Hud_SetVisible( Hud_GetChild( file.menu, "DarkenBackground" ), true )

	UpdateFooterOptions()
}

void function ServerBrowser_EnsureMainMenu()
{
	var mainMenu = GetMenu( "MainMenu" )

	while ( GetActiveMenu() != null && GetActiveMenu() != mainMenu )
		CloseActiveMenu( false )

	if ( GetActiveMenu() == mainMenu && IsMenuVisible( mainMenu ) )
	{
		SetMenuNavigationDisabled( true )
		return
	}

	if ( GetActiveMenu() == mainMenu )
		CloseActiveMenu( false )

	AdvanceMenu( mainMenu )
	SetMenuNavigationDisabled( true )
}

void function ServerBrowserMenu_OnOpen()
{
	// MainMenu show leaves nav disabled (blocks ESC/B). AdvanceMenu closes MainMenu
	// without running its closeFunc, so re-enable here like AccessibilityDialog.
	SetMenuNavigationDisabled( false )

	// Nested CNestedPanel does not paint or fire PANEL_SHOW until ShowPanel.
	// Same pattern as ADS/controls menus with a single child panel.
	var panel = file.panel
	if ( panel == null && Hud_HasChild( file.menu, "MainMenuServerBrowserPanel" ) )
		panel = Hud_GetChild( file.menu, "MainMenuServerBrowserPanel" )

	if ( panel == null )
	{
		printt( "[BRIDGE-SB] ServerBrowserMenu open: MainMenuServerBrowserPanel missing" )
		return
	}

	file.panel = panel
	printt( "[BRIDGE-SB] ServerBrowserMenu open: ShowPanel MainMenuServerBrowserPanel" )
	ShowPanel( panel )
	ServerBrowserMenu_ForceBackdrop()
}

void function ServerBrowserMenu_OnGetTopLevel()
{
	SetMenuNavigationDisabled( false )
	ServerBrowserMenu_ForceBackdrop()
}

void function ServerBrowserMenu_OnClose()
{
	if ( file.panel != null )
	{
		if ( IsPanelActive( file.panel ) )
			HidePanel( file.panel )
	}

	ServerBrowserShared_OnHide()

	// CloseActiveMenu already swapped active to the stack menu under us.
	// Restore MainMenu's stock "no ESC" gate if that is where we landed.
	if ( GetActiveMenu() == GetMenu( "MainMenu" ) )
		SetMenuNavigationDisabled( true )
}

void function ServerBrowserMenu_OnNavBack()
{
	CloseActiveMenu()
	ServerBrowser_EnsureMainMenu()
}

void function MainMenuServerBrowserPanel_OnShow( var panel )
{
	// Re-bind after hide released exclusive host.
	ServerBrowserShared_Bind( panel, GetParentMenu( panel ) )
	ServerBrowserShared_OnShow()
	ServerBrowserMenu_ForceBackdrop()
}

void function MainMenuServerBrowserPanel_OnHide( var panel )
{
	ServerBrowserShared_OnHide()
}

void function ServerBrowserMenu_FooterRefresh( var button )
{
	ServerBrowserShared_OnRefresh( button )
}

void function ServerBrowserMenu_FooterConnect( var button )
{
	ServerBrowserShared_OnConnect( button )
}
