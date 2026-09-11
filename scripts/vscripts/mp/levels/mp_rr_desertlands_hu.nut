global function CodeCallback_PreMapInit
global function CodeCallback_MapInit
global function CodeCallback_OnPlayerUpdraftLift

const string SILO_PANEL_SCRIPTNAME = "silo_doors_panel"
const string SILO_PANEL_MDL = $"mdl/beacon/crane_room_monitor_console.rmdl"
const string SILO_MOVER_SCRIPTNAME = "silo_platform_mover"
const string SILO_PATH_SCRIPTNAME = "silo_platform_mover_path_end"
const string SILO_DOOR_FLAG_END = "drillsite_bunker_1_complete"
const string SILO_DOOR_LEFT_SCRIPTNAME = "silo_door_left"
const string SILO_DOOR_LEFT_MOVER_SCRIPTNAME = "silo_door_left_mover"
const string SILO_DOOR_RIGHT_SCRIPTNAME = "silo_door_right"
const string SILO_DOOR_RIGHT_MOVER_SCRIPTNAME = "silo_door_right_mover"
const string SILO_PLATFORM_SCRIPTNAME = "silo_rising_platform"
const string WAYPOINTTYPE_SILO_DOORS = "desertlands_silo_doors_waypoint"

const string SILO_PANEL_ACTIVATE_SFX = "Desertlands_MU2_Silo_Open"
const string SILO_DOORS_OPEN_SFX = "Desertlands_Fortress_Interactive_Panel"
const string SILO_ELEVATOR_LOOP_SFX = "Desertlands_MU2_Silo_Ascend_LP"
const string SILO_ELEVATOR_STOP_SFX = "Desertlands_MU2_Silo_Ascend_End"

const asset MUSEUM_PROP_1 = $"mdl/desertlands/display_branthium_canister_01.rmdl"
const asset MUSEUM_PROP_2 = $"mdl/hall_of_fame/octane_heirloom_prop_01.rmdl"
const asset MUSEUM_PROP_3 = $"mdl/desertlands/display_forge_medallion_01.rmdl"
const asset MUSEUM_PROP_4 = $"mdl/titans/titan_battery/titan_battery_broken_b1.rmdl"
const asset MUSEUM_PROP_5 = $"mdl/props/jack_gauntlet_ts/jack_gauntlet_01.rmdl"

const asset MUSEUM_PROP_1_CARD = $"mdl/hall_of_fame/hall_of_fame_displaycase_01_cards_branthium.rmdl"
const asset MUSEUM_PROP_2_CARD = $"mdl/hall_of_fame/hall_of_fame_displaycase_01_cards_octane_heirloom.rmdl"
const asset MUSEUM_PROP_3_CARD = $"mdl/hall_of_fame/hall_of_fame_displaycase_01_cards_forge_medallion.rmdl"
const asset MUSEUM_PROP_4_CARD = $"mdl/hall_of_fame/hall_of_fame_displaycase_01_cards_battery.rmdl"
const asset MUSEUM_PROP_5_CARD = $"mdl/hall_of_fame/hall_of_fame_displaycase_01_cards_gauntlet.rmdl"

const asset MUSEUM_PROP_STAND_1 = $"mdl/hall_of_fame/heirloom_stand_prop_01.rmdl"
const asset MUSEUM_PROP_STAND_2 = $"mdl/hall_of_fame/gear_stand_prop_01.rmdl"


struct
{
	bool siloDoorHasBeenActivated = false
	bool museumKioskInUse = false
	table< string, array<string> > kioskAudioByScriptNameTable
	array< entity > kiosks
} file

void function CodeCallback_PreMapInit()
{
	Desertlands_PreMapInit_Common()
}

void function CodeCallback_MapInit()
{
	RunMySurvivalPreprocess()
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
	Desertlands_SetTrainEnabled( false )
	Desertlands_MU1_MapInit_Common()
	MapZones_RegisterDataTable( $"datatable/map_zones/zones_mp_rr_desertlands_hu.rpak" )

	ShPrecacheBreachAndClearAssets()
	ShPrecacheTreasureExtractionAssets()
	ShPrecacheSkydiveLauncherAssets()

	PrecacheModel( SILO_PANEL_MDL )

	PrecacheModel( MUSEUM_PROP_1 )
	PrecacheModel( MUSEUM_PROP_2 )
	PrecacheModel( MUSEUM_PROP_3 )
	PrecacheModel( MUSEUM_PROP_4 )
	PrecacheModel( MUSEUM_PROP_5 )

	PrecacheModel( MUSEUM_PROP_1_CARD )
	PrecacheModel( MUSEUM_PROP_2_CARD )
	PrecacheModel( MUSEUM_PROP_3_CARD )
	PrecacheModel( MUSEUM_PROP_4_CARD )
	PrecacheModel( MUSEUM_PROP_5_CARD )

	PrecacheModel( MUSEUM_PROP_STAND_1 )
	PrecacheModel( MUSEUM_PROP_STAND_2 )

	CommonStoryEvents_Init()
	DesertlandsStoryEvents_Init()

	IntroCameraSettings view
	//CONTROL INTRO CAMERA
	if( GameMode_IsActive( eGameModes.CONTROL ) )
	{
		//LAVA SIPHON
		view.origin = < 15005.646484, -20310.257813, -1666.273438 >
		view.angles = < 3.060948, 169.910934, 0 >
		view.fov = 90
	}
	else //SURVIVAL INTRO CAMERAS
	{
		int randChoice = RandomInt( 5 )
		switch( randChoice )
		{
			// Monument
			case 0:
				// OG - reenable post anniversary event
				//view.origin = < 6279.081055, 11202.436523, -1774.146851 >
				//view.angles = < 13.980016, -138.600937, 0 >
				view.origin = < 4266.105469, 7190.746094, -1692.321411 >
				view.angles = < 5.389855, 58.178555, 0 >
				view.fov = 85
				break

			// Monument - Museum
			case 1:
				// OG - reenable post anniversary event
				// view.origin = < 3721.239990, 8561.594727, -4227.915039 >
				// view.angles = < -18.580067, 50.478390, 0 >
				view.origin = < 7885.869141, 9567.136719, -3929.921143 >
				view.angles = < -22.770126, 138.038818, 0 >
			
				view.fov = 90
				break

			// Lava Siphon
			case 2:
				view.origin = < 15005.646484, -20310.257813, -1666.273438 >
				view.angles = < 3.060948, 169.910934, 0 >
				view.fov = 90
				break

			// Stacks
			case 3:
				// OG - reenable post anniversary event
				//view.origin = < 30516.003906, -24979.783203, -1759.950806 >
				//view.angles = < 3.344765, -169.564850, 0 >
				view.origin = < 30979.089844, -27541.609375, 1246.649414 >
				view.angles = < 16.609846, -162.151459, 0 >
				view.fov = 90
				break

			// Rampart TT
			case 4:
				view.origin = < 24203.601563, -20966.960938, -2515.553711 >
				view.angles = < 6.999793, -7.990623, 0 >
				view.fov = 70
				break
		}
	}

	SetIntroCameraSettings( view )

	if ( GetCurrentPlaylistVarInt( "deathfield_end_on_script_locations", 0 ) == 1 )
		AddCircleOverrideLocations()

	file.kioskAudioByScriptNameTable[ "screen_1_prop_scriptname" ] <- ["diag_mp_aiNotify_bc_billboardObjectW_01a_3p", "diag_mp_aiNotify_bc_billboardObjectW_01b_3p", "diag_mp_aiNotify_bc_billboardObjectW_01c_3p" ]
	file.kioskAudioByScriptNameTable[ "screen_2_prop_scriptname" ] <- ["diag_mp_aiNotify_bc_billboardObjectW_02a_3p", "diag_mp_aiNotify_bc_billboardObjectW_02b_3p" ]
	file.kioskAudioByScriptNameTable[ "screen_3_prop_scriptname" ] <- ["diag_mp_aiNotify_bc_billboardObjectW_03a_3p", "diag_mp_aiNotify_bc_billboardObjectW_03b_3p" ]
	file.kioskAudioByScriptNameTable[ "screen_4_prop_scriptname" ] <- ["diag_mp_aiNotify_bc_billboardObjectW_04a_3p", "diag_mp_aiNotify_bc_billboardObjectW_04b_3p", "diag_mp_aiNotify_bc_billboardObjectW_04c_3p" ]
	AddSpawnCallback( "prop_dynamic_lightweight", PropDynamicSpawned )
	AddSpawnCallback( "prop_dynamic", PropDynamicSpawned )

                      
                                                          

             
                                                                           

             
                                                                              
                                                                            
                                                                           

             
                                                                         
                                                                              
                                                                           

             
                                                                                                                
                                                                                                                     
                                                                        
                                                                           

             
                                                                                  
                                                                            
                                                                          
                                                                                                           
                                                                              
                                                                             
                                                                                         
                                                                                         
                                                                     

                       
                                                                          
                                                                             
                                                                                   
                            

	                         
		ForcedSpawn_AddSpawnPoint( "skyhook_east", < -7223, 28994, -173 > ) //1
		ForcedSpawn_AddSpawnPoint( "skyhook_west", < -22736, 22326, -2253 > ) //2
		ForcedSpawn_AddSpawnPoint( "countdown", < -18433, 12366, -3615 > ) //3
		ForcedSpawn_AddSpawnPoint( "lava_fissure", < -29659, 9026, -2066 > ) //4
		ForcedSpawn_AddSpawnPoint( "landslide", < -14103, 3654, -84 > ) //5
		ForcedSpawn_AddSpawnPoint( "mirage_a_trios", < -29506, -2645, -3573 > ) //6
		ForcedSpawn_AddSpawnPoint( "staging", < -17006, -8991, -3988 > ) //7
		ForcedSpawn_AddSpawnPoint( "thermal_station", < -23790, -22738, -4280 > ) //8
		ForcedSpawn_AddSpawnPoint( "harvester", < 1334, -7590, -3828 > ) //9
		ForcedSpawn_AddSpawnPoint( "the_tree", < -5980, -31250, -3581 > ) //10
		ForcedSpawn_AddSpawnPoint( "siphon_west", < 240, -25566, -3640> ) //11
		ForcedSpawn_AddSpawnPoint( "siphon_east", < 12364, -14720, -3718 > ) //12
		ForcedSpawn_AddSpawnPoint( "launch_site", < 4200, -36259, -807 > ) //13
		ForcedSpawn_AddSpawnPoint( "the_dome", < 19444, -38229, -2304 > ) //14
		ForcedSpawn_AddSpawnPoint( "stacks", < 20769, -29496, -2937 > ) //15
		ForcedSpawn_AddSpawnPoint( "big_maude", < 26468, -16880, -2037 > ) //16
		ForcedSpawn_AddSpawnPoint( "the_geyser", < 23435, -8815, -3615 > ) //17
		ForcedSpawn_AddSpawnPoint( "fragment", < 15350, 1195, -3967 > ) //18
		ForcedSpawn_AddSpawnPoint( "monument", < -621, 6880, -2688 > ) //19
		ForcedSpawn_AddSpawnPoint( "survey_camp", < 1851, 24928, -2900 > ) //20
		ForcedSpawn_AddSpawnPoint( "the_epicenter", < 14183, 18073, -4404 > ) //21
		ForcedSpawn_AddSpawnPoint( "climatizer_west", < 13361, 34157, -2774 > ) //22
		ForcedSpawn_AddSpawnPoint( "climatizer_east", < 27727, 20264, -3189 > ) //23
		ForcedSpawn_AddSpawnPoint( "overlook", < 29313, 10387, -3046 > ) //24
                                
}

void function EntitiesDidLoad()
{
	Desertlands_MU1_EntitiesLoaded_Common()

	SetupSiloPanels()
	MuseumSetupCenterProp()
}


void function CodeCallback_OnPlayerUpdraftLift( entity player )
{
	Desertlands_MU1_UpdraftInit_Common( player )
}


void function SetupSiloPanels()
{
	array<string> flagsToSet
	array<entity> newPanels
	foreach ( entity oldPanel in GetEntArrayByScriptName( SILO_PANEL_SCRIPTNAME ) )
	{
		entity panel = CreatePropDynamic( SILO_PANEL_MDL, oldPanel.GetOrigin(), oldPanel.GetAngles(), SOLID_VPHYSICS )
		newPanels.append( panel )

		if ( oldPanel.HasKey( "scr_flagToggle" ) )
		{
			string flagRequired = expect string( oldPanel.kv.scr_flagToggle )
			flagsToSet.append( flagRequired )
		}

		oldPanel.Destroy()
	}

	foreach ( string flagToSet in flagsToSet )
	{
		if ( !FlagExists( flagToSet ) )
			FlagInit( flagToSet )
	}

	foreach ( entity panel in newPanels )
	{
		panel.AllowMantle()
		panel.SetForceVisibleInPhaseShift( true )
		panel.SetUsable()
		panel.AddUsableValue( USABLE_CUSTOM_HINTS | USABLE_BY_OWNER | USABLE_BY_PILOTS | USABLE_BY_ENEMIES )
		panel.SetUsablePriority( USABLE_PRIORITY_LOW )
		panel.SetSkin( 1 )
		panel.SetUsePrompts( "#SILO_DOOR_PANEL_HINT", "#SILO_DOOR_PANEL_HINT" )
		AddCallback_OnUseEntity_ServerOnly( panel, CreateSiloPanelFunc( flagsToSet, newPanels ) )
	}

	// Make sure panels exist before trying to set up doors
	// TODO: MegC: this is temporary fix to allow art team to compile Desertlands without Zone 1
	if ( newPanels.len() > 0 )
	{
		// character abilities on the doors
		array<entity> siloDoors
		siloDoors.append( GetEntByScriptName( SILO_DOOR_LEFT_SCRIPTNAME ) )
		siloDoors.append( GetEntByScriptName( SILO_DOOR_RIGHT_SCRIPTNAME ) )

		array<entity> siloDoorMovers
		siloDoorMovers.append( GetEntByScriptName( SILO_DOOR_LEFT_MOVER_SCRIPTNAME ) )
		siloDoorMovers.append( GetEntByScriptName( SILO_DOOR_RIGHT_MOVER_SCRIPTNAME ) )

		foreach ( entity mover in siloDoorMovers )
			thread WaitForLootInitFinishedAndSetupDoors( mover )
	}
}


void function WaitForLootInitFinishedAndSetupDoors( entity mover )
{
	FlagWait( "Survival_LootSpawned" )

	if ( IsValid( mover ) )
	{
		mover.AllowZiplines()
	}
}


void functionref( entity activePanel, entity player, int useInputFlags ) function CreateSiloPanelFunc( array<string> flagsToSet, array<entity> allPanels )
{
	return void function( entity activePanel, entity player, int useInputFlags ) : ( flagsToSet, allPanels )
	{
		thread OnSiloPanelActivate( activePanel, allPanels, flagsToSet )
	}
}


void function OnSiloPanelActivate( entity activePanel, array<entity> allPanels, array<string> flagsToSet )
{
	if ( file.siloDoorHasBeenActivated )
		return

	file.siloDoorHasBeenActivated = true

	entity siloPlatform = GetEntByScriptName( SILO_PLATFORM_SCRIPTNAME )
	entity platformMover   = GetEntByScriptName( SILO_MOVER_SCRIPTNAME )
	entity pathEnd = GetEntByScriptName( SILO_PATH_SCRIPTNAME )

	array<entity> siloDoors
	siloDoors.append( GetEntByScriptName( SILO_DOOR_LEFT_SCRIPTNAME ) )
	siloDoors.append( GetEntByScriptName( SILO_DOOR_RIGHT_SCRIPTNAME ) )

	array<entity> siloDoorMovers
	siloDoorMovers.append( GetEntByScriptName( SILO_DOOR_LEFT_MOVER_SCRIPTNAME ) )
	siloDoorMovers.append( GetEntByScriptName( SILO_DOOR_RIGHT_MOVER_SCRIPTNAME ) )

	// panels
	foreach ( entity panel in allPanels )
	{
		if ( IsValid( panel ) )
		{
			panel.UnsetUsable()
			panel.SetSkin( 2 )
		}
	}

	// handle objects on the doors and lift
	platformMover.SetPusher( true )
	platformMover.DisallowZiplines()

	foreach ( entity doorMover in siloDoorMovers )
	{
		doorMover.SetPusher( true )
		doorMover.DisallowZiplines()
		doorMover.DisallowObjectPlacement()
	}

	entity wp = CreateWaypoint_Custom( WAYPOINTTYPE_SILO_DOORS )

	foreach ( entity door in siloDoors )
	{
		CleanUpPermanentsParentedToDynamicEnt( door )
		AddEntToInvalidEntsForPlacingPermanentsOnto( door )
		AddEntityDestroyedCallback( door,
			void function( entity ent ) : ( door )
			{
				RemoveEntFromInvalidEntsForPlacingPermanentsOnto( ent )
			}
		)
	}

	// move the doors and lift
	foreach	( string flagToSet in flagsToSet )
		FlagSet( flagToSet )

	EmitSoundAtPosition( TEAM_ANY, activePanel.GetOrigin(), SILO_PANEL_ACTIVATE_SFX, activePanel )
	EmitSoundAtPosition( TEAM_ANY, pathEnd.GetOrigin(), SILO_DOORS_OPEN_SFX, pathEnd )
	EmitSoundOnEntity( platformMover, SILO_ELEVATOR_LOOP_SFX )

	FlagWait( SILO_DOOR_FLAG_END )

	EmitSoundOnEntity( platformMover, SILO_ELEVATOR_STOP_SFX )

	// handle abilities on lift
	wp.SetWaypointInt( 0, 1 )

	platformMover.AllowZiplines()
	AddToAllowedAirdropDynamicEntities( siloPlatform )
}

void function AddCircleOverrideLocations()
{
	{
		//Thermal Locations #0
		switch ( RandomInt( 9 ) )
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <-20085, -23399, -4312>, 50, true )   // Thermal Station
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <-11986, -19561, -3536>, 50, true )   // Thermal Train Station
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <-22008, -15458, -3480>, 50, true )   // North Thermal House
				break

			case 3:
				SURVIVAL_AddOverrideCircleLocation( <-25875, -19581, -4360>, 50, true )   // West Thermal Solo House
				break

			case 4:
				SURVIVAL_AddOverrideCircleLocation( <-23816, -27221, -4248>, 50, true )   // South Thermal lower zip House
				break

			case 5:
				SURVIVAL_AddOverrideCircleLocation( <-27107, -24075, -4595>, 50, true )   // South Thermal in-between rocks
				break

			case 6:
				SURVIVAL_AddOverrideCircleLocation( <-17999, -27125, -3332>, 50, true )   // South east Thermal upper zip
				break

			case 7:
				SURVIVAL_AddOverrideCircleLocation( <-18812, -29665, -3702>, 50, true )   // East Thermal no-name
				break

			case 8:
				SURVIVAL_AddOverrideCircleLocation( <-22476, -18988, -4273>, 50, true )   // Thermal in-between pipes
				break
		}
	}
	{
		//Launch Site + Tree Locations #1
		switch ( RandomInt( 9 ) )
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <-6898, -31510, -3580>, 50, true )    // Tree
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <2749, -36250, -3297>, 50, true )     // Launch Site
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <11527, -32397, -2800>, 50, true )    // North East Launch Site
				break

			case 3:
				SURVIVAL_AddOverrideCircleLocation( <-5778, -27001, -4307>, 50, true )    // North tree by houses
				break

			case 4:
				SURVIVAL_AddOverrideCircleLocation( <-11915, -29723, -3258>, 50, true )    // West tree by choke
				break

			case 5:
				SURVIVAL_AddOverrideCircleLocation( <-4704, -31822, -3642>, 50, true )    // east tree by choke
				break

			case 6:
				SURVIVAL_AddOverrideCircleLocation( <-7462, -29380, -3564>, 50, true )    // center tree
				break

			case 7:
				SURVIVAL_AddOverrideCircleLocation( <5765, -36631, -2850>, 50, true )    // Launch Site by Big base
				break

			case 8:
				SURVIVAL_AddOverrideCircleLocation( <6387, -33670, -3093>, 50, true )    // Launch Site by in N pit
				break
		}
	}
	{
		//Lava Siphon Locations #2
		switch ( RandomInt( 11 ) )
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <1512, -23448, -3712>, 50, true )     // Lava Shipon 1 South West
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <5947, -19867, -3635>, 50, true )     // Lava Shipon 2 Middle
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <10180, -24125, -3715>, 50, true )    // Lava Shipon South
				break

			case 3:
				SURVIVAL_AddOverrideCircleLocation( <12981, -18071, -3718>, 50, true )   // Lava Shipon North East
				break

			case 4:
				SURVIVAL_AddOverrideCircleLocation( <5514, -23411, -4056>, 50, true )   // Inbetween lave buldings westside!!!MIGHT BE BAD
				break

			case 5:
				SURVIVAL_AddOverrideCircleLocation( <12776, -20711, -3910>, 50, true )   // 3 pills
				break

			case 6:
				SURVIVAL_AddOverrideCircleLocation( <9292, -15304, -3774>, 50, true )   // NE by dozer
				break

			case 7:
				SURVIVAL_AddOverrideCircleLocation( <4994, -27922, -3773>, 50, true )   // S by launch site
				break

			case 8:
				SURVIVAL_AddOverrideCircleLocation( <7639, -18416, -3767>, 50, true )   // NE inbetween right side buildings
				break

			case 9:
				SURVIVAL_AddOverrideCircleLocation( <10171, -9447, -3948>, 50, true )   // NE inbetween right side buildings
				break

			case 10:
				SURVIVAL_AddOverrideCircleLocation( <13629, -24534, -4393>, 50, true )   // South by Geyser lift
				break
		}
	}
	{
		//Dome + Lava City + Big M #3
		switch ( RandomInt( 11 ) )
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <20816, -39491, -2304>, 50, true )    // Dome by cylinders
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <16801, -36311, -2350>, 50, true )    // Dome NE side
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <22650, -36272, -2359>, 50, true )    // Dome by Van
				break

			case 3:
				SURVIVAL_AddOverrideCircleLocation( <24350, -26243, -3336>, 50, true )    // Stacks
				break

			case 4:
				SURVIVAL_AddOverrideCircleLocation( <21999, -31094, -2874>, 50, true )    // S Stacks
				break

			case 5:
				SURVIVAL_AddOverrideCircleLocation( <28960, -28185, -3319>, 50, true )    // E Stacks
				break

			case 6:
				SURVIVAL_AddOverrideCircleLocation( <24683, -29827, -3336>, 50, true )    // SE Stacks
				break

			case 7:
				SURVIVAL_AddOverrideCircleLocation( <24898, -20436, -3538>, 50, true )    // front maude
				break

			case 8:
				SURVIVAL_AddOverrideCircleLocation( <22732, -29012, -3336>, 50, true )    // center stacks
				break

			case 9:
				SURVIVAL_AddOverrideCircleLocation( <30024, -22881, -3697>, 50, true )    // back maude
				break

			case 10:
				SURVIVAL_AddOverrideCircleLocation( <23034, -22698, -3203>, 50, true )    // in small dome
				break
		}
	}
	{
		//Gyser + House on Hill + Bins + no name #4
		switch ( RandomInt( 5 ) )
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <25612, -9180, -4215>, 50, true )     // Geyser
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <20169, -10836, -4266>, 50, true )    // W Geyser
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <14711, -3103, -3173>, 50, true )   // Bins - South of Fragment East
				break

			case 3:
				SURVIVAL_AddOverrideCircleLocation( <20848, 2402, -4196>, 50, true )      // East of... Fragment East
				break

			case 4:
				SURVIVAL_AddOverrideCircleLocation( <19105, 2406, -3729>, 50, true )      // East of... Fragment East Respawn Hill
				break
		}
	}
	{
		//Epicenter + Broken Train #5
		switch ( RandomInt( 5 ) )
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <14001, 21816, -4163>, 50, true )     // N Epi ... on pills
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <12469, 16211, -4852>, 50, true )     // S Epi
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <9439, 21111, -4966>, 50, true )     // W Epi
				break

			case 3:
				SURVIVAL_AddOverrideCircleLocation( <15480, 16968, -4028>, 50, true )     // E Epi
				break

			case 4:
				SURVIVAL_AddOverrideCircleLocation( <15151, 23630, -3472>, 50, true )     // N EPI on Bridge
				break
		}
	}
	{
		//Climatizer #6
		switch ( RandomInt( 6 ) )
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <26570, 24830, -4609>, 50, true )     // Climatizer South
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <18619, 32975, -5072>, 50, true )     // Climatizer North needs work
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <14781, 30033, -4736>, 50, true )     // W Climatizer
				break

			case 3:
				SURVIVAL_AddOverrideCircleLocation( <15622, 34652, -4640>, 50, true )     // Far NW Climatizer
				break

			case 4:
				SURVIVAL_AddOverrideCircleLocation( <20409, 24214, -5072>, 50, true )     // S Epicenter
				break

			case 5:
				SURVIVAL_AddOverrideCircleLocation( <18541, 28402, -5634>, 50, true )     // Epicenter pit
				break
		}
	}
	{
		//Survey Camp + Train Station #7
		switch ( RandomInt( 5 ) )
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <5350, 27034, -4569>, 50, true )      // Survey Camp
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <-168, 20089, -2896>, 50, true )     // Train station -  West of Fragment West
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <6343, 28887, -4284>, 50, true )     // Survey Camp by respawn
				break

			case 3:
				SURVIVAL_AddOverrideCircleLocation( <8307, 32422, -4098>, 50, true )     // Far north Train
				break

			case 4:
				SURVIVAL_AddOverrideCircleLocation( <-2352, 21443, -2849>, 50, true )     // Train station -  West of Fragment West
				break
		}
	}
	{
		//Harvester #8
		switch ( RandomInt( 4 ) )
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <-8150, -8022, -3522>, 50, true )     // Staging -> Harvester
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <-3707, -12611, -4096>, 50, true )    // Harvester
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <-6366, -20529, -3850>, 50, true )    // North of Tree
				break

			case 3:
				SURVIVAL_AddOverrideCircleLocation( <560, -10142, -4278>, 50, true )    // North Harvester
				break
		}
	}
	{
		//Staging + Landslide + Hazzard #9
		switch ( RandomInt( 5 ) )
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <-16559, -9078, -4394>, 50, true )    // Staging
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <-19041, 3511, -3231>, 50, true )      // E of Landslide
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <-13975, 5556, -3555>, 50, true )  // Landslide
				break

			case 3:
				SURVIVAL_AddOverrideCircleLocation( <-21463, -7901, -2816>, 50, true )  // Staging by hut
				break

			case 4:
				SURVIVAL_AddOverrideCircleLocation( <-24295, -4635, -3652>, 50, true )  // No-name by Mirage
				break
		}
	}
	{
		//Coutdown + East Feild + Lava Fisure + South Trials #10
		switch ( RandomInt( 6 ) )
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <-10221, 12939, -3437>, 50, true )    // North of Trainyard
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <-17919, 13858, -3615>, 50, true )    // Center of countdown
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <-22865, 13558, -3456>, 50, true )    // between coutdown and fisure
				break

			case 3:
				SURVIVAL_AddOverrideCircleLocation( <-29874, 10875, -3056>, 50, true )    // Lava fissure
				break

			case 4:
				SURVIVAL_AddOverrideCircleLocation( <-24531, 17744, -3439>, 50, true )    // NW of Countdown
				break

			case 5:
				SURVIVAL_AddOverrideCircleLocation( <-20316, 17778, -3012>, 50, true )    // NW of Countdown closer to Skyhook
				break
		}
	}
	{
		//Skyhook #11
		switch ( RandomInt( 9 ) )
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <-18257, 26116, -4068>, 50, true )    // West Skyhook
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <-12030, 30689, -4155>, 50, true )    // Skyhook North
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <-8546, 28446, -4032>, 50, true )    // Skyhook South East
				break

			case 3:
				SURVIVAL_AddOverrideCircleLocation( <-9566, 24875, -4040>, 50, true )    // Skyhook South East
				break

			case 4:
				SURVIVAL_AddOverrideCircleLocation( <-5746, 28783, -3591>, 50, true )    // Skyhook South East by tower
				break

			case 5:
				SURVIVAL_AddOverrideCircleLocation( <-15455, 24462, -4000>, 50, true )    // Skyhook South East by tower
				break

			case 6:
				SURVIVAL_AddOverrideCircleLocation( <-21022, 29591, -3644>, 50, true )    // NE Skyhook by Climate tower
				break

			case 7:
				SURVIVAL_AddOverrideCircleLocation( <-12379, 21982, -4040>, 50, true )    // S Skyhook near tunnel
				break

			case 8:
				SURVIVAL_AddOverrideCircleLocation( <-14568, 30119, -4145>, 50, true )    // N Skyhook near Train & Market
				break
		}
	}
	{
		//Monument #12
		switch ( RandomInt( 5 ) )
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <5033, 9027, -4074>, 50, true )      // Monument center
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <1505, 4762, -4296>, 50, true )       // SW Monument
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <1997, 12673, -4072>, 50, true )       // NW Monument
				break

			case 3:
				SURVIVAL_AddOverrideCircleLocation( <5935, 11564, -4080>, 50, true )       // NE Monument
				break

			case 4:
				SURVIVAL_AddOverrideCircleLocation( <3558, 2474, -3982>, 50, true )       // S Monument by train tracks
				break
		}
	}
	{
		//Fragment East #13
		switch ( RandomInt( 5 ) )
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <12953, 4817, -4296>, 50, true )      // Fragment East South Train
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <10382, 7314, -4307>, 50, true )      // Fragment East W Train
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <14125, 6341, -4296>, 50, true )      // Fragment East inbetween buildings
				break

			case 3:
				SURVIVAL_AddOverrideCircleLocation( <16839, 6568, -3967>, 50, true )      // Fragment East by Broken tracks
				break

			case 4:
				SURVIVAL_AddOverrideCircleLocation( <8929, 4736, -4307>, 50, true )      // Fragment East by stramer building
				break
		}
	}
	{
		//Over Look #14
		switch ( RandomInt( 5 ) )
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <30306, 9055, -3501>, 50, true )        // Overlook Silo
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <26960, 13531, -3272>, 50, true )      // OverLook Houses
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <21615, 15849, -4531>, 50, true )      // broken train
				break

			case 3:
				SURVIVAL_AddOverrideCircleLocation( <27359, 5903, -3057>, 50, true )      // Feild S of overlook
				break

			case 4:
				SURVIVAL_AddOverrideCircleLocation( <28407, 10424, -3542>, 50, true )      // Overlook Center
				break
		}
	}
}

void function PropDynamicSpawned( entity ent )
{
	if ( ent.GetScriptName() in file.kioskAudioByScriptNameTable )
		SetMuseumKiosk( ent )
}

void function SetMuseumKiosk( entity ent )
{
	if ( !IsValid ( ent ) )
		return

	ent.SetUsable()
	ent.AddUsableValue( USABLE_BY_ALL | USABLE_CUSTOM_HINTS )
	ent.SetUsablePriority( USABLE_PRIORITY_LOW )
	ent.SetUsePrompts( "#S17CR_INTERACT", "#S17CR_INTERACT" )
	SetCallback_CanUseEntityCallback( ent, MuseumKioskCanUse )
	AddCallback_OnUseEntity_ClientServer( ent, MuseumKioskOnUse )
	file.kiosks.append( ent )
}

bool function MuseumKioskCanUse( entity playerUser, entity kiosk, int useFlags )
{
	if ( !IsValid (playerUser) )
		return false

	if ( Bleedout_IsBleedingOut( playerUser ) )
		return false

	if ( file.museumKioskInUse )
		return false

	return true
}

void function MuseumKioskOnUse( entity ent, entity player, int useInputFlags )
{
	ent.UnsetUsable()
	thread MuseumKioskPlayAudioThread( ent )
}

void function MuseumKioskPlayAudioThread( entity ent )
{
	if ( !IsValid ( ent ) )
		return

	OnThreadEnd(
		function() : ( ent )
		{
			ent.SetUsable()
		}
	)

	if ( !( ent.GetScriptName() in file.kioskAudioByScriptNameTable ) )
		return

	vector audioPosition = ent.GetOrigin() + < 0, 0, 45 >

	EmitSoundAtPosition( TEAM_ANY, audioPosition, "Desertlands_HU_Scr_Fragment_MuseumButton", ent )

	wait 0.5

	foreach ( audio in file.kioskAudioByScriptNameTable[ ent.GetScriptName() ])
	{
		if ( audio == "" )
			continue

		float timeVal = EmitSoundAtPosition( TEAM_ANY, audioPosition, audio, ent )

		wait timeVal
	}

	wait 2.0
}

void function MuseumSetupCenterProp()
{
	int latestMissionIndex = SeasonQuestMission_GetLatestTimeUnlockedMission()

	array<entity> relicStands = GetEntArrayByScriptName("relic_stand_script_name")
	if ( relicStands.len() != 1 )
		return

	array<entity> relics = GetEntArrayByScriptName("relic_script_name")
	if ( relics.len() != 1 )
		return

	array<entity> relicCards = GetEntArrayByScriptName("relic_card_scriptname")
	if ( relicCards.len() != 1 )
		return

	entity relicStand = relicStands[0]
	entity relic = relics[0]
	entity relicCard = relicCards[0]


	switch ( latestMissionIndex )
	{
		case 0:
			CreatePropScript( MUSEUM_PROP_1_CARD, relicCard.GetOrigin(), relicCard.GetAngles() )
			entity prop = CreatePropScript( MUSEUM_PROP_1, relic.GetOrigin() + <0,0,-5>, <0,0,0> )
			relic.Destroy()
			relicCard.Destroy()
			relicStand.Destroy()
			break
		case 2:
			CreatePropScript( MUSEUM_PROP_3_CARD, relicCard.GetOrigin(), relicCard.GetAngles() )
			entity prop = CreatePropScript( MUSEUM_PROP_3, <5829.9, 9921.9, -4416>, <0,-128,0> )
			prop.SetModelScale( 1.3 )
			entity prop2 = CreatePropScript( MUSEUM_PROP_STAND_2, relicStand.GetOrigin(), <0,140,0> )
			relic.Destroy()
			relicCard.Destroy()
			relicStand.Destroy()
			break
		case 3:
			CreatePropScript( MUSEUM_PROP_4_CARD, relicCard.GetOrigin(), relicCard.GetAngles() )
			entity prop = CreatePropScript( MUSEUM_PROP_4, relic.GetOrigin() + <0, 0.5,-6> , <0,0,0> )
			relic.Destroy()
			relicCard.Destroy()
			relicStand.Destroy()
			break
		case 4:
			CreatePropScript( MUSEUM_PROP_5_CARD, relicCard.GetOrigin(), relicCard.GetAngles() )
			entity prop = CreatePropScript( MUSEUM_PROP_5, <5830.3, 9921.5, -4420>, <0,-128,90> )
			prop.SetModelScale( 1.5 )
			entity prop2 = CreatePropScript( MUSEUM_PROP_STAND_2, relicStand.GetOrigin(), <0,140,0> )
			relic.Destroy()
			relicCard.Destroy()
			relicStand.Destroy()
			break
		case 1:
		default:
			break
	}
}