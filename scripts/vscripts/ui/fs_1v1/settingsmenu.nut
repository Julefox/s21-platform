// Flowstate 1v1 settings menu.
// Menu name "1v1_SetttingsMenu" keeps the original spelling; AddMenu registers it that way.

untyped

global function Init_1v1_SettingsMenu
global function FS_1v1_SettingsMenu_Open
global function FS_1v1_SettingsMenu_Close
global function Gamemode1v1_CloseLegendMenu

const int SLIDER_FILL_W = 172

struct ToggleRow
{
	string name
	string convar
	void functionref() onChange
}

struct StepperRow
{
	string name
	string convar
	int minValue
	int maxValue
	int step
	string suffix
	void functionref() onChange
}

struct
{
	var menu
	array<ToggleRow> toggles
	array<StepperRow> steppers
} file

const array<string> CAMO_NAMES = [ "Base", "Red", "White", "Yellow", "Blue", "Pink", "Dark Green", "Teal Blue", "Green", "Random" ]


void function Init_1v1_SettingsMenu( var newMenuArg )
{
	var menu = newMenuArg
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, On1v1Settings_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, On1v1Settings_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, On1v1Settings_Close )

	RuiSetImage( Hud_GetRui( Hud_GetChild( menu, "TitleBadge" ) ), "basicImage", $"rui/flowstatecustom/1v1" )

	Hud_AddEventHandler( Hud_GetChild( menu, "GoBackButton" ), UIE_CLICK, GoBackButtonFunct )

	var findMatch = Hud_GetChild( menu, "ToggleRestButton" )
	Hud_AddEventHandler( findMatch, UIE_CLICK, ToggleRestButton )
	Hud_AddEventHandler( findMatch, UIE_GET_FOCUS, FindMatchFocus )
	Hud_AddEventHandler( findMatch, UIE_LOSE_FOCUS, FindMatchLoseFocus )

	AddToggle( "StartInRest", "fs_1v1_startinrest", StartInRestChanged )
	AddToggle( "IBMM", "fs_1v1_ibmm", IBMMChanged )
	AddToggle( "AcceptChallenges", "fs_1v1_acceptchallenges", AcceptChallengesChanged )
	AddToggle( "ShowInputBanner", "fs_1v1_showinputbanner", ShowInputBannerChanged )
	AddToggle( "VsUI", "fs_1v1_showvsui", ShowVsUIChanged )

	AddStepper( "IBMMWaitTime", "fs_1v1_maxibmmtime", 0, 30, 1, " s", MaxIBMMTimeChanged )
	AddStepper( "MaxLatencyAllowed", "fs_1v1_maxenemylatency", 5, 999, 25, "", MaxEnemyLatencyChanged )
	AddStepper( "CamoColor", "fs_1v1_camo", 0, CAMO_NAMES.len() - 1, 1, "", CamoColorChanged )

	SetMenuReceivesCommands( menu, false )
	SetGamepadCursorEnabled( menu, true )

	printt( "[FS-1V1-UI] settings menu init" )
}


void function AddToggle( string name, string convar, void functionref() onChange )
{
	ToggleRow row
	row.name = name
	row.convar = convar
	row.onChange = onChange
	file.toggles.append( row )

	Hud_AddEventHandler( Hud_GetChild( file.menu, name + "Off" ), UIE_CLICK, void function( var button ) : ( row ) { SetToggle( row, 0 ) } )
	Hud_AddEventHandler( Hud_GetChild( file.menu, name + "On" ), UIE_CLICK, void function( var button ) : ( row ) { SetToggle( row, 1 ) } )
}


void function AddStepper( string name, string convar, int minValue, int maxValue, int step, string suffix, void functionref() onChange )
{
	StepperRow row
	row.name = name
	row.convar = convar
	row.minValue = minValue
	row.maxValue = maxValue
	row.step = step
	row.suffix = suffix
	row.onChange = onChange
	file.steppers.append( row )

	Hud_AddEventHandler( Hud_GetChild( file.menu, name + "Dec" ), UIE_CLICK, void function( var button ) : ( row ) { StepValue( row, -1 ) } )
	Hud_AddEventHandler( Hud_GetChild( file.menu, name + "Inc" ), UIE_CLICK, void function( var button ) : ( row ) { StepValue( row, 1 ) } )
}


void function SetToggle( ToggleRow row, int value )
{
	if ( GetConVarInt( row.convar ) == value )
		return

	SetConVarInt( row.convar, value )
	row.onChange()
	RefreshAll()
}


void function StepValue( StepperRow row, int dir )
{
	int value = GetConVarInt( row.convar ) + dir * row.step
	if ( row.name == "CamoColor" )
		value = ( value + CAMO_NAMES.len() ) % CAMO_NAMES.len()
	value = ClampInt( value, row.minValue, row.maxValue )

	if ( value == GetConVarInt( row.convar ) )
		return

	SetConVarInt( row.convar, value )
	row.onChange()
	RefreshAll()
}


void function RefreshAll()
{
	foreach ( ToggleRow row in file.toggles )
	{
		bool on = GetConVarInt( row.convar ) != 0
		Hud_SetVisible( Hud_GetChild( file.menu, row.name + "OnFill" ), on )
		Hud_SetVisible( Hud_GetChild( file.menu, row.name + "OffFill" ), !on )
		SetSegmentText( Hud_GetChild( file.menu, row.name + "OnText" ), on )
		SetSegmentText( Hud_GetChild( file.menu, row.name + "OffText" ), !on )
	}

	foreach ( StepperRow row in file.steppers )
	{
		int value = GetConVarInt( row.convar )
		var valueLabel = Hud_GetChild( file.menu, row.name + "Value" )

		if ( row.name == "CamoColor" )
		{
			Hud_SetText( valueLabel, CAMO_NAMES[ ClampInt( value, 0, CAMO_NAMES.len() - 1 ) ] )
			continue
		}

		Hud_SetText( valueLabel, value.tostring() + row.suffix )

		float span = float( row.maxValue - row.minValue )
		int fillW = int( SLIDER_FILL_W * ( float( ClampInt( value, row.minValue, row.maxValue ) - row.minValue ) / span ) )
		var fill = Hud_GetChild( file.menu, row.name + "Fill" )
		Hud_SetWidth( fill, fillW )
		Hud_SetVisible( fill, fillW > 0 )
	}
}


void function SetSegmentText( var label, bool active )
{
	if ( active )
		Hud_SetColor( label, 6, 20, 13, 255 )
	else
		Hud_SetColor( label, 169, 184, 175, 255 )
}


void function FindMatchFocus( var button )
{
	Hud_SetVisible( Hud_GetChild( file.menu, "FindMatchHover" ), true )
}


void function FindMatchLoseFocus( var button )
{
	Hud_SetVisible( Hud_GetChild( file.menu, "FindMatchHover" ), false )
}


void function On1v1Settings_Open()
{
	RefreshAll()
	Hud_SetVisible( Hud_GetChild( file.menu, "FindMatchHover" ), false )
}


void function FS_1v1_SettingsMenu_Open()
{
	if ( file.menu == null )
	{
		printt( "[FS-1V1-UI] SettingsMenu_Open: menu not inited" )
		return
	}

	CloseAllMenus()
	EmitUISound( "UI_Menu_FriendInspect" )
	AdvanceMenu( file.menu )
}


void function FS_1v1_SettingsMenu_Close()
{
	CloseAllMenus()
	EmitUISound( "UI_Menu_FriendInspect" )
}


void function Gamemode1v1_CloseLegendMenu()
{
	CloseAllMenus()
}


void function GoBackButtonFunct( var button )
{
	CloseAllMenus()

	if ( IsConnected() )
		RunClientScript( "FS_1v1_DisplayHints", -1 )
}


void function On1v1Settings_Close()
{
	GoBackButtonFunct( null )
}


void function ToggleRestButton( var button )
{
	ClientCommand( "rest" )
}


void function StartInRestChanged()
{
	ClientCommand( "CC_1v1_StartInRest " + GetConVarInt( "fs_1v1_startinrest" ).tostring() )
}


void function IBMMChanged()
{
	ClientCommand( "CC_1v1_IBMM " + GetConVarInt( "fs_1v1_ibmm" ).tostring() )

	if ( GetConVarInt( "fs_1v1_ibmm" ) == 0 )
		SetConVarInt( "fs_1v1_maxibmmtime", 0 )
	else
		SetConVarInt( "fs_1v1_maxibmmtime", 3 )

	ClientCommand( "CC_1v1_MaxIBMMTime " + GetConVarInt( "fs_1v1_maxibmmtime" ).tostring() )
}


void function AcceptChallengesChanged()
{
	ClientCommand( "CC_1v1_AcceptChallenges " + GetConVarInt( "fs_1v1_acceptchallenges" ).tostring() )
}


void function ShowInputBannerChanged()
{
	ClientCommand( "CC_1v1_ShowInputBanner " + GetConVarInt( "fs_1v1_showinputbanner" ).tostring() )
}


void function ShowVsUIChanged()
{
	ClientCommand( "CC_1v1_ShowVsUI " + GetConVarInt( "fs_1v1_showvsui" ).tostring() )
	RunClientScript( "SetShow1v1Scoreboard", GetConVarInt( "fs_1v1_showvsui" ).tostring() )
}


void function CamoColorChanged()
{
	ClientCommand( "CC_1v1_CamoColor " + GetConVarInt( "fs_1v1_camo" ).tostring() )
}


void function MaxEnemyLatencyChanged()
{
	ClientCommand( "CC_1v1_MaxEnemyLatency " + GetConVarInt( "fs_1v1_maxenemylatency" ).tostring() )
}


void function MaxIBMMTimeChanged()
{
	ClientCommand( "CC_1v1_MaxIBMMTime " + GetConVarInt( "fs_1v1_maxibmmtime" ).tostring() )

	if ( GetConVarInt( "fs_1v1_maxibmmtime" ) <= 0 )
	{
		SetConVarInt( "fs_1v1_ibmm", 0 )
		ClientCommand( "CC_1v1_IBMM 0" )
	}
	else if ( GetConVarInt( "fs_1v1_ibmm" ) == 0 )
	{
		SetConVarInt( "fs_1v1_ibmm", 1 )
		ClientCommand( "CC_1v1_IBMM 1" )
	}
}
