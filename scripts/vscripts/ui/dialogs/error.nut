global function InitErrorDialog
global function OpenErrorDialogThread

struct
{
	var menu
	var contentRui
	asset contextImage
	string headerText
	string messageText
	string SIDText
} file

void function InitErrorDialog( var newMenuArg ) 
{
	var menu = GetMenu( "ErrorDialog" )
	file.menu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	file.contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ErrorDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ErrorDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ErrorDialog_OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_CONTINUE", "#CONTINUE", Continue )

#if DEVELOPER
	AddMenuThinkFunc( menu, ErrorDialogAutomationThink )
#endif
}

#if DEVELOPER
void function ErrorDialogAutomationThink( var menu )
{
	if (AutomateUi())
	{
		printt("ErrorDialogAutomationThink Continue()")
		Continue(null)
	}
}
#endif

void function Continue( var button )
{
	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()
}

bool function ErrorDialog_IsModsPolicy( string errorMessage )
{
	if ( errorMessage.find( "SDK_MODS_POLICY" ) != -1 )
		return true

	string localized = Localize( "#SDK_MODS_POLICY" )
	if ( localized != "" && localized != "#SDK_MODS_POLICY" && errorMessage.find( localized ) != -1 )
		return true

	return false
}

void function ErrorDialog_OnOpen()
{
	RuiSetAsset( file.contentRui, "contextImage", file.contextImage )
	RuiSetString( file.contentRui, "headerText", file.headerText )

	string messageText = file.messageText
	if( !IsValid( messageText ) )
	{
		messageText = "ERROR MESSAGE TEXT WAS INVALID"
	}
	RuiSetString( file.contentRui, "messageText", messageText )

	var label = Hud_GetChild( file.menu, "ServerID" )
	Hud_SetText( label, file.SIDText )
}

void function ErrorDialog_OnClose()
{
}

void function ErrorDialog_OnNavigateBack()
{
	CloseActiveMenu()
}

void function OpenErrorDialogThread( string errorMessage )
{
	bool isIdleDisconnect = errorMessage.find( Localize( "#DISCONNECT_IDLE" ) ) == 0
	bool isModsPolicy = ErrorDialog_IsModsPolicy( errorMessage )

	if ( isModsPolicy )
		printt( "[MOD] disconnect: server refused client mod set" )

	file.contextImage = isIdleDisconnect ? $"ui/menu/common/dialog_notice" : $"ui/menu/common/dialog_error"
	file.headerText = ( isModsPolicy ? Localize( "#BRIDGE_MODS_POLICY_HEADER" ) : ( isIdleDisconnect ? Localize( "#DISCONNECTED_HEADER" ) : Localize( "#ERROR" ) ) ).toupper()
	file.messageText = isModsPolicy ? Localize( "#BRIDGE_MODS_POLICY_BODY" ) : errorMessage
	file.SIDText = "SID: " + GetServerDebugId() 

	while ( GetActiveMenu() != GetMenu( "MainMenu" ) )
		WaitSignal( uiGlobal.signalDummy, "OpenErrorDialog", "ActiveMenuChanged" )

	AdvanceMenu( file.menu )
}