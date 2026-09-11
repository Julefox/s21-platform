// Lab > Mods. The server mutator list.
// Slot labels come from the mod registry, so a new mod appears without an edit.

global function InitLabModsPanel
global function LabMods_SetBits

const int LAB_MOD_ROWS = 12

struct
{
	var panel
	var contentPanelParent
	var contentPanel
	var scrollBar
	var scrollFrame

	array<var> modRows
	array<string> modIds

	var buttonDisableAll
	var serverModsHeader
	var serverModsHeaderText

	int  modBits = 0

	bool applyingValues = false
} file

void function InitLabModsPanel( var panel )
{
	file.panel = panel

	file.contentPanelParent = Hud_GetChild( panel, "ModeOptionsPanel" )
	file.contentPanel = Hud_GetChild( file.contentPanelParent, "ContentPanel" )
	file.scrollBar = Hud_GetChild( file.contentPanelParent, "ScrollBar" )
	file.scrollFrame = Hud_GetChild( file.contentPanelParent, "ScrollFrame" )

	file.serverModsHeader = Hud_GetChild( file.contentPanel, "ServerModsHeader" )
	file.serverModsHeaderText = Hud_GetChild( file.contentPanel, "ServerModsHeaderText" )
	file.buttonDisableAll = Hud_GetChild( file.contentPanel, "ButtonDisableAllMods" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnLabModsPanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnLabModsPanel_Hide )

	for ( int i = 0; i < LAB_MOD_ROWS; i++ )
	{
		var row = Hud_GetChild( file.contentPanel, format( "SwitchMod%d", i ) )
		file.modRows.append( row )
		file.modIds.append( "" )

		Hud_Hide( row )
		Hud_SetEnabled( row, false )

		AddButtonEventHandler( row, UIE_CHANGE, LabMods_OnModChanged )
	}

	Lab_SetupRow( file.buttonDisableAll, "#LAB_MODS_DISABLEALL",
		"#LAB_MODS_DISABLEALL_DESC", true )

	AddButtonEventHandler( file.buttonDisableAll, UIE_CLICK, LabMods_OnDisableAll )

	SettingsPanel_SetContentPanelHeight( file.contentPanel )
	ScrollPanel_InitPanel( file.contentPanelParent )
	ScrollPanel_InitScrollBar( file.contentPanelParent, file.scrollBar )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )

	Lab_AddGateListener( LabMods_ApplyGates )
}

void function OnLabModsPanel_Show( var panel )
{
	ClientCommand( "cafemod sync" )

	LabMods_RebuildModRows()
	LabMods_ApplyGates()

	ScrollPanel_SetActive( file.contentPanelParent, true )
	SettingsPanel_SetContentPanelHeight( file.contentPanel )
	ScrollPanel_Refresh( file.contentPanelParent )
}

void function OnLabModsPanel_Hide( var panel )
{
	ScrollPanel_SetActive( file.contentPanelParent, false )
}

// One visible row per registered mod; the rest stay hidden and unfocusable.
void function LabMods_RebuildModRows()
{
	if ( file.modRows.len() == 0 )
		return

	int total = CafeMod_GetTotalCount()
	int shown = 0

	for ( int i = 0; i < total && shown < LAB_MOD_ROWS; i++ )
	{
		string id = CafeMod_GetId( i )
		if ( id == "" || id == "items_weapon" )
			continue

		string name = CafeMod_GetName( i )
		if ( name == "" )
			name = id

		var row = file.modRows[ shown ]

		// Row labels are wired once per slot; the registry only grows.
		if ( file.modIds[ shown ] != id )
		{
			file.modIds[ shown ] = id
			Lab_SetupRow( row, name, format( Localize( "#LAB_MODS_ROW_DESC_FMT" ), name ), true )
		}

		Hud_Show( row )

		file.applyingValues = true
		Hud_SetDialogListSelectionValue( row, CafeMod_IsBitSet( file.modBits, i ) ? "1" : "0" )
		file.applyingValues = false

		shown++
	}

	for ( int i = shown; i < LAB_MOD_ROWS; i++ )
	{
		file.modIds[ i ] = ""
		Hud_Hide( file.modRows[ i ] )
		Hud_SetEnabled( file.modRows[ i ], false )
	}

	if ( shown > 0 )
	{
		Hud_Show( file.serverModsHeader )
		Hud_Show( file.serverModsHeaderText )
	}
	else
	{
		Hud_Hide( file.serverModsHeader )
		Hud_Hide( file.serverModsHeaderText )
	}
}

void function LabMods_SetBits( int bitfield )
{
	file.modBits = bitfield
	LabMods_RebuildModRows()
	LabMods_ApplyGates()
}

void function LabMods_ApplyGates()
{
	if ( file.modRows.len() == 0 )
		return

	for ( int i = 0; i < LAB_MOD_ROWS; i++ )
	{
		if ( file.modIds[ i ] == "" )
			continue
		Lab_SetRowState( file.modRows[ i ], true )
	}

	Lab_SetRowState( file.buttonDisableAll, true )

	if ( Lab_GetCheats() && !Lab_IsHostSeat() )
		Lab_SetDetails( Localize( "#LAB_MODS_HOST_TITLE" ), Localize( "#LAB_MODS_HOST_DESC" ) )
}

void function LabMods_OnModChanged( var button )
{
	if ( file.applyingValues || !Lab_GetCheats() || !Lab_IsHostSeat() )
		return

	int index = file.modRows.find( button )
	if ( index < 0 || file.modIds[ index ] == "" )
		return

	ClientCommand( "cafemod toggle " + file.modIds[ index ] )
}

void function LabMods_OnDisableAll( var button )
{
	if ( !Lab_GetCheats() || !Lab_IsHostSeat() )
		return
	ClientCommand( "cafemod disable_all" )
}
