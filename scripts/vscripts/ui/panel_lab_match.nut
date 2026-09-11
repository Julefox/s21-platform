// Lab > Match. Tools that change the match for everyone on the server.
// Every row here needs the host seat, and the ones that move or revive other
// players ask for confirmation first.

global function InitLabMatchPanel

struct
{
	var panel
	var contentPanelParent
	var contentPanel
	var scrollBar
	var scrollFrame

	table< string, var > rows

	bool mapTriggers = true
	bool devAlerts = false

	bool applyingValues = false
} file

void function InitLabMatchPanel( var panel )
{
	file.panel = panel

	file.contentPanelParent = Hud_GetChild( panel, "ModeOptionsPanel" )
	file.contentPanel = Hud_GetChild( file.contentPanelParent, "ContentPanel" )
	file.scrollBar = Hud_GetChild( file.contentPanelParent, "ScrollBar" )
	file.scrollFrame = Hud_GetChild( file.contentPanelParent, "ScrollFrame" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnLabMatchPanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnLabMatchPanel_Hide )

	LabMatch_BindRows()

	SettingsPanel_SetContentPanelHeight( file.contentPanel )
	ScrollPanel_InitPanel( file.contentPanelParent )
	ScrollPanel_InitScrollBar( file.contentPanelParent, file.scrollBar )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )

	Lab_AddGateListener( LabMatch_ApplyGates )
}

var function LabMatch_Row( string name )
{
	return file.rows[ name ]
}

void function LabMatch_BindRows()
{
	array<string> names = [
		"ButtonRingStart", "ButtonRingPause", "ButtonRingHere",
		"SwitchMapTriggers", "SwitchDevAlerts", "ButtonSkydive", "ButtonSummon",
		"ButtonCareR1", "ButtonCareR2", "ButtonCareR3",
		"ButtonRespawnAllDead", "ButtonRespawnAll", "ButtonRespawnBots",
		"ButtonRespawnAllies", "ButtonRespawnEnemies"
	]

	foreach ( string name in names )
		file.rows[ name ] <- Hud_GetChild( file.contentPanel, name )

	Lab_SetupRow( LabMatch_Row( "ButtonRingStart" ), "#LAB_MATCH_RINGSTART",
		"#LAB_MATCH_RINGSTART_DESC", true )
	Lab_SetupRow( LabMatch_Row( "ButtonRingPause" ), "#LAB_MATCH_RINGPAUSE",
		"#LAB_MATCH_RINGPAUSE_DESC", true )
	Lab_SetupRow( LabMatch_Row( "ButtonRingHere" ), "#LAB_MATCH_RINGHERE",
		"#LAB_MATCH_RINGHERE_DESC", true )
	Lab_SetupRow( LabMatch_Row( "SwitchMapTriggers" ), "#LAB_MATCH_MAPTRIGGERS",
		"#LAB_MATCH_MAPTRIGGERS_DESC", true )
	Lab_SetupRow( LabMatch_Row( "SwitchDevAlerts" ), "#LAB_MATCH_DEVALERTS",
		"#LAB_MATCH_DEVALERTS_DESC", true )
	Lab_SetupRow( LabMatch_Row( "ButtonSkydive" ), "#LAB_MATCH_SKYDIVE",
		"#LAB_MATCH_SKYDIVE_DESC", true )
	Lab_SetupRow( LabMatch_Row( "ButtonSummon" ), "#LAB_MATCH_SUMMON",
		"#LAB_MATCH_SUMMON_DESC", true )
	Lab_SetupRow( LabMatch_Row( "ButtonCareR1" ), "#LAB_MATCH_CARER1",
		"#LAB_MATCH_CARER1_DESC", true )
	Lab_SetupRow( LabMatch_Row( "ButtonCareR2" ), "#LAB_MATCH_CARER2",
		"#LAB_MATCH_CARER2_DESC", true )
	Lab_SetupRow( LabMatch_Row( "ButtonCareR3" ), "#LAB_MATCH_CARER3",
		"#LAB_MATCH_CARER3_DESC", true )
	Lab_SetupRow( LabMatch_Row( "ButtonRespawnAllDead" ), "#LAB_MATCH_RESPAWNDEAD",
		"#LAB_MATCH_RESPAWNDEAD_DESC", true )
	Lab_SetupRow( LabMatch_Row( "ButtonRespawnAll" ), "#LAB_MATCH_RESPAWNALL",
		"#LAB_MATCH_RESPAWNALL_DESC", true )
	Lab_SetupRow( LabMatch_Row( "ButtonRespawnBots" ), "#LAB_MATCH_RESPAWNBOTS",
		"#LAB_MATCH_RESPAWNBOTS_DESC", true )
	Lab_SetupRow( LabMatch_Row( "ButtonRespawnAllies" ), "#LAB_MATCH_RESPAWNALLIES",
		"#LAB_MATCH_RESPAWNALLIES_DESC", true )
	Lab_SetupRow( LabMatch_Row( "ButtonRespawnEnemies" ), "#LAB_MATCH_RESPAWNENEMIES",
		"#LAB_MATCH_RESPAWNENEMIES_DESC", true )

	AddButtonEventHandler( LabMatch_Row( "ButtonRingStart" ), UIE_CLICK, LabMatch_ClickRingStart )
	AddButtonEventHandler( LabMatch_Row( "ButtonRingPause" ), UIE_CLICK, LabMatch_ClickRingPause )
	AddButtonEventHandler( LabMatch_Row( "ButtonRingHere" ), UIE_CLICK, LabMatch_ClickRingHere )
	AddButtonEventHandler( LabMatch_Row( "ButtonSkydive" ), UIE_CLICK, LabMatch_ClickSkydive )
	AddButtonEventHandler( LabMatch_Row( "ButtonSummon" ), UIE_CLICK, LabMatch_ClickSummon )
	AddButtonEventHandler( LabMatch_Row( "ButtonCareR1" ), UIE_CLICK, LabMatch_ClickCareR1 )
	AddButtonEventHandler( LabMatch_Row( "ButtonCareR2" ), UIE_CLICK, LabMatch_ClickCareR2 )
	AddButtonEventHandler( LabMatch_Row( "ButtonCareR3" ), UIE_CLICK, LabMatch_ClickCareR3 )
	AddButtonEventHandler( LabMatch_Row( "ButtonRespawnAllDead" ), UIE_CLICK, LabMatch_ClickRespawnAllDead )
	AddButtonEventHandler( LabMatch_Row( "ButtonRespawnAll" ), UIE_CLICK, LabMatch_ClickRespawnAll )
	AddButtonEventHandler( LabMatch_Row( "ButtonRespawnBots" ), UIE_CLICK, LabMatch_ClickRespawnBots )
	AddButtonEventHandler( LabMatch_Row( "ButtonRespawnAllies" ), UIE_CLICK, LabMatch_ClickRespawnAllies )
	AddButtonEventHandler( LabMatch_Row( "ButtonRespawnEnemies" ), UIE_CLICK, LabMatch_ClickRespawnEnemies )

	AddButtonEventHandler( LabMatch_Row( "SwitchMapTriggers" ), UIE_CHANGE, LabMatch_OnMapTriggers )
	AddButtonEventHandler( LabMatch_Row( "SwitchDevAlerts" ), UIE_CHANGE, LabMatch_OnDevAlerts )
}

void function OnLabMatchPanel_Show( var panel )
{
	file.applyingValues = true
	Hud_SetDialogListSelectionValue( LabMatch_Row( "SwitchMapTriggers" ), file.mapTriggers ? "1" : "0" )
	Hud_SetDialogListSelectionValue( LabMatch_Row( "SwitchDevAlerts" ), file.devAlerts ? "1" : "0" )
	file.applyingValues = false

	LabMatch_ApplyGates()

	ScrollPanel_SetActive( file.contentPanelParent, true )
	SettingsPanel_SetContentPanelHeight( file.contentPanel )
	ScrollPanel_Refresh( file.contentPanelParent )
}

void function OnLabMatchPanel_Hide( var panel )
{
	ScrollPanel_SetActive( file.contentPanelParent, false )
}

void function LabMatch_ApplyGates()
{
	if ( file.rows.len() == 0 )
		return

	foreach ( string name, var button in file.rows )
		Lab_SetRowState( button, true )

	if ( Lab_GetCheats() && !Lab_IsHostSeat() )
		Lab_SetDetails( Localize( "#LAB_MATCH_HOST_TITLE" ), Localize( "#LAB_MATCH_HOST_DESC" ) )
}

bool function LabMatch_Blocked()
{
	return !Lab_GetCheats() || !Lab_IsHostSeat()
}

void function LabMatch_Run( string command )
{
	if ( LabMatch_Blocked() )
		return
	ClientCommand( command )
}

// Anything that moves or revives other players confirms first.
void function LabMatch_Confirm( string header, string message, string command )
{
	if ( LabMatch_Blocked() )
		return

	ConfirmDialogData data
	data.headerText = header
	data.messageText = message
	data.resultCallback = void function ( int result ) : ( command )
	{
		if ( result == eDialogResult.YES )
			ClientCommand( command )
	}
	OpenConfirmDialogFromData( data )
}

void function LabMatch_ClickRingStart( var button ) { LabMatch_Run( "dev_deathfield 1" ) }
void function LabMatch_ClickRingPause( var button ) { LabMatch_Run( "dev_deathfield 0" ) }
void function LabMatch_ClickRingHere( var button ) { LabMatch_Run( "dev_deathfield here" ) }
void function LabMatch_ClickRespawnBots( var button ) { LabMatch_Run( "respawn deadbots" ) }
void function LabMatch_ClickRespawnAllies( var button ) { LabMatch_Run( "respawn allies" ) }
void function LabMatch_ClickRespawnEnemies( var button ) { LabMatch_Run( "respawn enemies" ) }
void function LabMatch_ClickCareR1( var button ) { LabMatch_Run( "lab_carepackage 0" ) }
void function LabMatch_ClickCareR2( var button ) { LabMatch_Run( "lab_carepackage 1" ) }
void function LabMatch_ClickCareR3( var button ) { LabMatch_Run( "lab_carepackage 2" ) }

void function LabMatch_ClickSkydive( var button )
{
	if ( LabMatch_Blocked() )
		return
	ClientCommand( "dev_aimtrainer skydive" )
	CloseAllMenus()
}

void function LabMatch_ClickSummon( var button )
{
	LabMatch_Confirm( Localize( "#LAB_MATCH_CONFIRM_SUMMON_TITLE" ),
		Localize( "#LAB_MATCH_CONFIRM_SUMMON_DESC" ), "lab_summon" )
}

void function LabMatch_ClickRespawnAllDead( var button )
{
	LabMatch_Confirm( Localize( "#LAB_MATCH_CONFIRM_RESPAWNDEAD_TITLE" ),
		Localize( "#LAB_MATCH_CONFIRM_RESPAWNDEAD_DESC" ), "respawn alldead" )
}

void function LabMatch_ClickRespawnAll( var button )
{
	LabMatch_Confirm( Localize( "#LAB_MATCH_CONFIRM_RESPAWNALL_TITLE" ),
		Localize( "#LAB_MATCH_CONFIRM_RESPAWNALL_DESC" ), "respawn all" )
}

void function LabMatch_OnMapTriggers( var button )
{
	if ( file.applyingValues || LabMatch_Blocked() )
		return
	file.mapTriggers = !file.mapTriggers
	ClientCommand( "toggle_map_triggers" )
}

void function LabMatch_OnDevAlerts( var button )
{
	if ( file.applyingValues || LabMatch_Blocked() )
		return
	file.devAlerts = !file.devAlerts
	ClientCommand( "toggle_dev_alerts" )
}
