global function InitBridgeConnectDialog
global function OpenBridgeConnectDialog

struct
{
	var menu
	var host
	var port
	var key
	bool defaultsApplied = false
} file

void function InitBridgeConnectDialog( var newMenuArg )
{
	var menu = GetMenu( "BridgeConnectDialog" )
	file.menu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, true )

	file.host = Hud_GetChild( menu, "ConnectHost" )
	file.port = Hud_GetChild( menu, "ConnectPort" )
	file.key = Hud_GetChild( menu, "ConnectKey" )

	Hud_AddEventHandler( Hud_GetChild( menu, "ConnectButton" ), UIE_CLICK, BridgeConnectDialog_OnConnect )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, BridgeConnectDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, BridgeConnectDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, BridgeConnectDialog_OnNavBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#B_BUTTON_CANCEL" )
}

void function OpenBridgeConnectDialog()
{
	AdvanceMenu( file.menu )
}

void function BridgeConnectDialog_ApplyDefaults()
{
	if ( file.defaultsApplied )
		return

	Hud_SetUTF8Text( file.host, "127.0.0.1" )
	Hud_SetUTF8Text( file.port, "37015" )
	Hud_SetUTF8Text( file.key, "" )
	file.defaultsApplied = true
}

void function BridgeConnectDialog_ForceBackdrop()
{
	if ( file.menu == null || !Hud_HasChild( file.menu, "DarkenBackground" ) )
		return

	// UpdateMenuBlur hides DarkenBackground when not connected.
	Hud_SetVisible( Hud_GetChild( file.menu, "DarkenBackground" ), true )
}

void function BridgeConnectDialog_OnOpen()
{
	// MainMenu show leaves nav disabled (blocks ESC/B). Same restore as the server browser.
	SetMenuNavigationDisabled( false )
	BridgeConnectDialog_ApplyDefaults()
	BridgeConnectDialog_ForceBackdrop()
	RegisterButtonPressedCallback( KEY_ENTER, BridgeConnectDialog_OnConnect )
	printt( "[BRIDGE-UI] connect dialog open" )
}

void function BridgeConnectDialog_OnClose()
{
	DeregisterButtonPressedCallback( KEY_ENTER, BridgeConnectDialog_OnConnect )

	if ( GetActiveMenu() == GetMenu( "MainMenu" ) )
		SetMenuNavigationDisabled( true )
}

void function BridgeConnectDialog_OnNavBack()
{
	CloseActiveMenu()
}

void function BridgeConnectDialog_OnConnect( var button )
{
	string host = Hud_GetUTF8Text( file.host )
	string port = Hud_GetUTF8Text( file.port )
	string key = Hud_GetUTF8Text( file.key )

	if ( host.len() == 0 )
		host = "127.0.0.1"
	if ( port.len() == 0 )
		port = "37015"

	Bridge_SetConnectTarget( Bridge_BuildConnectAddress( host, port ) )
	Bridge_SetConnectKey( key )

	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()

	Bridge_MainMenuContinue()
}
