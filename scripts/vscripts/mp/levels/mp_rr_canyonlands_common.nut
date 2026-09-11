global function Canyonlands_MapInit_Common
global function CodeCallback_PlayerEnterUpdraftTrigger
global function CodeCallback_PlayerLeaveUpdraftTrigger

#if SERVER
#if DEVELOPER
	global function HoverTankTestPositions
	global function Dev_TestHoverTankIntro
#endif
#endif

#if SERVER
	global function HoverTank_DebugFlightPaths
	global function TestCreateTooManyLinks
	global function InitWaterLeviathans
	global function Canyonlands_UpdraftInit_Common
	global function InitOctaneTownTakeover
	global function PlaceOctaneTownTakeoverLoot

	// ported from mp_rr_canyonlands_mu1_common.nut / mu3_common.nut so hu can reach it too
	// (generic burn-trigger sound hookup, not actually Octane-TT-specific despite the name)
	const asset FX_OCTANE_TT_GUN_BG = $"chamber_dark_background"

	const int MAX_HOVERTANKS = 2
	const string HOVERTANK_START_NODE_NAME		= "hovertank_start_node"
	const string HOVERTANK_END_NODE_NAME		= "hovertank_end_node"
	const bool DEBUG_HOVERTANK_NODE_SELECTION	= false

	const string SIGNAL_HOVERTANK_AT_ENDPOINT = "HovertankAtEndpoint"

	const asset NESSY_MODEL = $"mdl/domestic/nessy_doll.rmdl"

	const asset ROCK_MODEL_FOR_CANYONLANDS_GEOFIX = $"mdl/rocks/rock_white_chalk_modular_flat_02.rmdl"

	//const asset HOVERTANK_PATH_FX = $"P_wpn_arcball_beam"
	//const asset HOVERTANK_END_FX = $"P_ar_call_beacon_ring_hovertank"

	const int HOVER_TANKS_DEFAULT_CIRCLE_INDEX = 1
	const int HOVER_TANKS_TYPE_INTRO = 0
	const int HOVER_TANKS_TYPE_MID = 1

	global enum eCanyonlandsMapUpdatePreviewPhases
	{
		MAP_UNCHANGED,
		LEVIATHANS_MOVE_CLOSER,
		LEVIATHANS_MOVE_MUCH_CLOSER,
		FLYERS_APPEAR,
		REPULSOR_TOWER_TURNS_ON,
		CRYPTO_TEASE,
	}
#endif

const int HOVER_TANKS_DEFAULT_COUNT_INTRO = 1
const int HOVER_TANKS_DEFAULT_COUNT_MID = 1
global const asset LEVIATHAN_MODEL = $"mdl/creatures/leviathan/leviathan_kingscanyon_preview_animated.rmdl"
const asset FLYER_SWARM_MODEL = $"mdl/Creatures/flyer/flyer_kingscanyon_animated.rmdl"
global const string CANYONLANDS_LEVIATHAN1_NAME = "leviathan1"
global const string CANYONLANDS_LEVIATHAN2_NAME= "leviathan2"
global const string CANYONLANDS_LEVIATHANBABY_NAME= "leviathan3"
const string HOVER_TANKS_ZIP_MOVER_SCRIPTNAME = "hovertank_zip_mover"

//Caustic TT
const asset CAUSTIC_TT_FOUNTAIN_FX = $"P_caustic_tt_geyser_idle"
const asset CAUSTIC_TT_WATER_SMOKE_FX = $"P_caustic_tt_env_steam_slow"
const asset CAUSTIC_TT_CANISTER_GLOW_FX = $"P_caustic_tt_canister"

//Crypto TT
const array< asset > CRYPTO_TT_MODELS = [
	$"mdl/levels_terrain/mp_rr_canyonlands/crypto_holo_map_01.rmdl",
	$"mdl/levels_terrain/mp_rr_canyonlands/crypto_holo_map_02.rmdl",
	$"mdl/levels_terrain/mp_rr_canyonlands/crypto_holo_map_03.rmdl",
	$"mdl/levels_terrain/mp_rr_canyonlands/crypto_holo_map_04.rmdl",
	$"mdl/levels_terrain/mp_rr_canyonlands/crypto_holo_map_05.rmdl"
	$"mdl/levels_terrain/mp_rr_canyonlands/crypto_holo_map_01_mu3.rmdl",
	$"mdl/levels_terrain/mp_rr_canyonlands/crypto_holo_map_02_mu3.rmdl",
	$"mdl/levels_terrain/mp_rr_canyonlands/crypto_holo_map_02_mu3_b.rmdl",
	$"mdl/levels_terrain/mp_rr_canyonlands/crypto_holo_map_03_mu3.rmdl",
	$"mdl/levels_terrain/mp_rr_canyonlands/crypto_holo_map_04_mu3.rmdl",
	$"mdl/levels_terrain/mp_rr_canyonlands/crypto_holo_map_05_mu3.rmdl"
	$"mdl/levels_terrain/mp_rr_canyonlands/crypto_holo_map_hu_01.rmdl",
	$"mdl/levels_terrain/mp_rr_canyonlands/crypto_holo_map_hu_02.rmdl",
	$"mdl/levels_terrain/mp_rr_canyonlands/crypto_holo_map_hu_03.rmdl",
	$"mdl/levels_terrain/mp_rr_canyonlands/crypto_holo_map_hu_04.rmdl",
	$"mdl/levels_terrain/mp_rr_canyonlands/crypto_holo_map_hu_05.rmdl"
]

const array< asset > CRYPTO_TT_PFX = [
	$"P_holo_ar_radius_pc64_CP_1x20",
	$"P_map_holo_ring_CP",
	$"P_map_player_pt_enemy",
	$"P_map_player_pt_team",
	$"P_crypto_holo_sat_scan"
]

struct
{
	#if SERVER
		array<HoverTank> hoverTanksIntro
		array<HoverTank> hoverTanksMid
		table<HoverTank, entity> hovertankEndpointMapObjects
		array<entity> hoverTankEndNodesIntro
		array<entity> hoverTankEndNodesMid

		table<HoverTank,SupplyShip> TEMP_hoverTankToSupplyShip
	#endif
	int numHoverTanksIntro = 0
	int numHoverTanksMid = 0

	#if CLIENT
		entity clientSideLeviathan1
		entity clientSideLeviathan2
		entity clientSideLeviathan3
		float lastLevAnimCycleChosen = -1.0
	#endif

} file

void function Canyonlands_MapInit_Common()
{
	printt( "Canyonlands_MapInit_Common" )

	FlagInit( "IntroHovertanksSet", false )

	PrecacheModel( LEVIATHAN_MODEL )
	PrecacheModel( FLYER_SWARM_MODEL )

	                        
		if ( GameMode_IsActive( eGameModes.CONTROL ) )
		{
			#if SERVER || CLIENT
				// ToDo: DSwieczko: Find a Level Ed solution for this
				Control_SetHomeBaseBadPlacesForMRBForAlliance( ALLIANCE_A, [ <3047.53906, -18727.1953, 2618.70728>, <126.41423, -17895.6758, 2813.13867>, <-2166.80151, -21425.0293, 3244.57471>, <-2173.26196, -24773.0664, 2709.64111>, <19063.1953, -26453.6426, 3033.4397> ] )
				Control_SetHomeBaseBadPlacesForMRBForAlliance( ALLIANCE_B, [ <12111.5732, -22695.7227, 1924.55103>, <17170.1094, -23047.2754, 1744.65686>, <19063.1953, -26453.6426, 3033.4397> ] )
			#endif // SERVER || CLIENT
		}
       

	file.numHoverTanksIntro = GetCurrentPlaylistVarInt( "hovertanks_count_intro", HOVER_TANKS_DEFAULT_COUNT_INTRO )
	#if SERVER
		printt( "HOVER TANKS INTRO MAX:", file.numHoverTanksIntro )
	#endif
	float chance = GetCurrentPlaylistVarFloat( "hovertanks_chance_intro", 1.0 ) * 100.0
	if ( RandomInt(100) > chance )
		file.numHoverTanksIntro = 0
	#if SERVER
		printt( "HOVER TANKS INTRO ACTUAL:", file.numHoverTanksIntro, "(was " + chance + "% chance)" )
	#endif

	file.numHoverTanksMid = GetCurrentPlaylistVarInt( "hovertanks_count_mid", HOVER_TANKS_DEFAULT_COUNT_MID )
	#if SERVER
		printt( "HOVER TANKS MID MAX:", file.numHoverTanksMid )
	#endif
	chance = GetCurrentPlaylistVarFloat( "hovertanks_chance_mid", 0.33 ) * 100.0
	if ( RandomInt(100) > chance )
		file.numHoverTanksMid = 0
	#if SERVER
		printt( "HOVER TANKS MID ACTUAL:", file.numHoverTanksMid, "(was " + chance + "% chance)" )
	#endif

	SupplyShip_Init()

	#if SERVER
		if ( NewSupplyShipEnabled() )
			SURVIVAL_AddLootGroupRemapping( "Bldg_Hovertank", "Bldg_SupplyShip" )

		FlagSet( "DisableDropships" )

		RegisterSignal( "NessyDamaged" )
		RegisterSignal( SIGNAL_HOVERTANK_AT_ENDPOINT )

		PrecacheModel( NESSY_MODEL )

		//SURVIVAL_AddOverrideCircleLocation_Nitro( <24744, 24462, 3980>, 2048 )

		AddCallback_EntitiesDidLoad( EntitiesDidLoad )
		AddCallback_AINFileBuilt( HoverTank_DebugFlightPaths )

		AddCallback_GameStateEnter( eGameState.Playing, HoverTanksOnGamestatePlaying )
		AddCallback_OnSurvivalDeathFieldStageChanged( HoverTanksOnDeathFieldStageChanged )

		SURVIVAL_SetPlaneHeight( 24000 )
		SURVIVAL_SetAirburstHeight( 8000 )
		SURVIVAL_SetMapCenter( <0, 0, 0> )

                       
                                                                                     
                             

		if( GetMapName().find("staging") == -1 )
			thread KillPlayersUnderMap_Thread( MAP_KILL_VOLUME_OFFSET_CANYONLANDS ) //-2048

		RegisterGeoFixAsset( ROCK_MODEL_FOR_CANYONLANDS_GEOFIX )
	#endif

	#if CLIENT
		// Doing this automatically since someone has to call InitWaterLeviathans() just to make the markers
		AddTargetNameCreateCallback( CANYONLANDS_LEVIATHAN1_NAME, OnLeviathanMarkerCreated ) //Created from the server to mark where the leviathans should be on the client
		AddTargetNameCreateCallback( CANYONLANDS_LEVIATHAN2_NAME, OnLeviathanMarkerCreated )
		AddTargetNameCreateCallback( CANYONLANDS_LEVIATHANBABY_NAME, OnLeviathanMarkerCreated )
		AddTargetNameCreateCallback( "leviathan_staging", OnLeviathanMarkerCreated )

		Freefall_SetPlaneHeight( 24000 )
		Freefall_SetDisplaySeaHeightForLevel( -956.0 )

		if ( file.numHoverTanksIntro > 0 || file.numHoverTanksMid > 0 )
			SetMapFeatureItem( 500, "#HOVER_TANK", "#HOVER_TANK_DESC", $"rui/hud/gametype_icons/survival/sur_hovertank_minimap" )

		if ( !IsPVEMode() )
			SetMapFeatureItem( 300, "#SUPPLY_DROP", "#SUPPLY_DROP_DESC", $"rui/hud/gametype_icons/survival/supply_drop" )

		SetMinimapBackgroundTileImage( $"overviews/mp_rr_canyonlands_bg" )

		RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.HOVERTANK, MINIMAP_OBJECT_RUI, MinimapPackage_HoverTank, FULLMAP_OBJECT_RUI, MinimapPackage_HoverTank )
		RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.HOVERTANK_DESTINATION, MINIMAP_OBJECT_RUI, MinimapPackage_HoverTankDestination, FULLMAP_OBJECT_RUI, MinimapPackage_HoverTankDestination )

                       
                                                             
                             
	#endif
}

#if SERVER

void function InitWaterLeviathans()
{
	AddSpawnCallback_ScriptName( CANYONLANDS_LEVIATHAN1_NAME, CreateClientSideLeviathanMarkers )
	AddSpawnCallback_ScriptName( CANYONLANDS_LEVIATHAN2_NAME, CreateClientSideLeviathanMarkers )
	AddSpawnCallback_ScriptName( CANYONLANDS_LEVIATHANBABY_NAME, CreateClientSideLeviathanMarkers )
	AddSpawnCallback_ScriptName( "leviathan_staging", CreateClientSideLeviathanMarkers )
}

void function EntitiesDidLoad()
{
	thread __EntitiesDidLoad()
}

void function __EntitiesDidLoad()
{
	waitthread FindHoverTankEndNodes()
	SpawnHoverTanks()
	if ( GetCurrentPlaylistVarInt( "enable_nessies", 1 ) == 1 )
		Nessies()
}

void function Canyonlands_UpdraftInit_Common( entity player )
{
	                        
		Control_PrintSkydiveDebug( player, " Canyonlands_UpdraftInit_Common going to trigger PlayerSkydiveFromCurrentPosition" )
                               
	ApplyUpdraftModUntilTouchingGround( player )
	thread PlayerSkydiveFromCurrentPosition( player )
}

void function CreateClientSideLeviathanMarkers( entity leviathan )
{
	leviathan.EndSignal( "OnDestroy" )

	vector leviathanOrigin = leviathan.GetOrigin()
	vector leviathanAngles = leviathan.GetAngles()

	if (  leviathan.GetScriptName() != "leviathan_staging" )
	{
		bool isLeviathan1 = leviathan.GetScriptName() == CANYONLANDS_LEVIATHAN1_NAME
		int previewPhase = GetCurrentPlaylistVarInt( "mu_preview_phase", eCanyonlandsMapUpdatePreviewPhases.MAP_UNCHANGED )
		switch ( previewPhase )
		{
			case eCanyonlandsMapUpdatePreviewPhases.LEVIATHANS_MOVE_CLOSER:
				leviathanOrigin = isLeviathan1 ? < 2599.376709, -48505.000000 , -1600 > : leviathanOrigin
				leviathanAngles = isLeviathan1 ? < 2.346743, 154.202164, 0 > : leviathanAngles
				break

			case eCanyonlandsMapUpdatePreviewPhases.LEVIATHANS_MOVE_MUCH_CLOSER:
				leviathanOrigin = isLeviathan1 ? < -44615.867188, -22612.208984, -1600 > : < 30792.123047, -45749.824219, -2784 >
				leviathanAngles = isLeviathan1 ? < 0, 70, 0 > : < 0, 117, 0 >
				break

			case eCanyonlandsMapUpdatePreviewPhases.FLYERS_APPEAR:
				leviathanOrigin = isLeviathan1 ? < -46599.632813, 561.130737, -1600 > : < 30792.123047, -45749.824219, -2784 >
				leviathanAngles = isLeviathan1 ? < 0, 22, 0 > : < 0, 117, 0 >
				break

			case eCanyonlandsMapUpdatePreviewPhases.REPULSOR_TOWER_TURNS_ON:
				leviathanOrigin = isLeviathan1 ? < -46599.632813, 561.130737, -1600 > : < 30792.123047, -45749.824219, -2784 >
				leviathanAngles = isLeviathan1 ? < 3.686208, 169.509933, 0.000000 > : < 6.670253, -146.874985, 0.000000 >
				break

			case eCanyonlandsMapUpdatePreviewPhases.CRYPTO_TEASE:
				leviathanOrigin = isLeviathan1 ? < -46599.632813, 561.130737, -1600 > : < 30792.123047, -45749.824219, -2784 >
				leviathanAngles = isLeviathan1 ? < 3.686208, 169.509933, 0.000000 > : < 6.670253, -146.874985, 0.000000 >
				break


			case eCanyonlandsMapUpdatePreviewPhases.MAP_UNCHANGED:
			default:
				break
		}
	}

	entity ent = CreatePropDynamic_NoDispatchSpawn( $"mdl/dev/empty_model.rmdl", leviathanOrigin, leviathanAngles )
	SetTargetName( ent, leviathan.GetScriptName() )
	DispatchSpawn( ent )

	leviathan.Destroy()

	ent.EndSignal( "OnDestroy" )

	wait 3.0

	ent.Destroy()
}

void function FindHoverTankEndNodes()
{
	FlagWait( "DeathFieldCalculationComplete" )

	// Arena modes FlagSet this without writing stages.
	if ( !SURVIVAL_HasDeathFieldStages( Survival_Loot_GetDefaultRealm() ) )
	{
		file.numHoverTanksIntro = 0
		file.numHoverTanksMid = 0
		HideUnusedHovertankSpecificGeo()
		return
	}

	file.hoverTankEndNodesMid = GetHoverTankEndNodes( file.numHoverTanksMid, HOVER_TANKS_TYPE_MID, [] )
	file.hoverTankEndNodesIntro = GetHoverTankEndNodes( file.numHoverTanksIntro, HOVER_TANKS_TYPE_INTRO, file.hoverTankEndNodesMid )

	printt( "HOVER TANK MID NODES:", file.hoverTankEndNodesMid.len() )
	printt( "HOVER TANK INTRO NODES:", file.hoverTankEndNodesIntro.len() )

	file.numHoverTanksIntro = int( min( file.numHoverTanksIntro, file.hoverTankEndNodesIntro.len() ) )
	file.numHoverTanksMid = int( min( file.numHoverTanksMid, file.hoverTankEndNodesMid.len() ) )

	HideUnusedHovertankSpecificGeo()
}

void function SpawnHoverTanks()
{
	// Spawn hover tanks at level load, even though they don't fly in yet, so they exist when loot is spawned.
	if ( file.numHoverTanksIntro == 0 && file.numHoverTanksMid == 0 )
		return

	if ( GetEntArrayByScriptName( "_hover_tank_mover" ).len() == 0 )
		return

	int numHoverTankSpawnersInMap = GetEntArrayByScriptName( "_hover_tank_mover" ).len()
	Assert( numHoverTankSpawnersInMap >= file.numHoverTanksIntro + file.numHoverTanksMid, "Playlist is trying to spawn too many hover tanks than the map can support. hovertanks_count_intro + hovertanks_count_mid must be <= " + numHoverTankSpawnersInMap )

	array<string> spawners = [ "HoverTank_1", "HoverTank_2" ]
	spawners.resize( file.numHoverTanksIntro + file.numHoverTanksMid )

	foreach( int i, string spawnerName in spawners )
	{
		HoverTank hoverTank = SpawnHoverTank_Cheap( spawnerName )
		hoverTank.playerRiding = true

		if ( i + 1 <= file.numHoverTanksIntro )
		{
			printt( "HOVER TANKS INTRO SPAWNER:", spawnerName )
			file.hoverTanksIntro.append( hoverTank )
			TEMP_TestNewSupplyShip( hoverTank )
		}
		else
		{
			printt( "HOVER TANKS MID SPAWNER:", spawnerName )
			file.hoverTanksMid.append( hoverTank )
		}
	}
}

bool function NewSupplyShipEnabled()
{
	return GetCurrentPlaylistVarBool( "enable_supply_ship_v2", false )
}

void function TEMP_TestNewSupplyShip( HoverTank hoverTank )
{
	if ( !NewSupplyShipEnabled() )
		return

	array<SupplyShip> ships = GetAllSupplyShips()
	SupplyShip ornull selected = null
	foreach ( ship in ships )
	{
		if ( IsValid( ship.mover.GetParent() ) )
			continue

		selected = ship
		break
	}

	if ( selected == null )
		return

	expect SupplyShip( selected )

	HideHoverTank( hoverTank )
	file.TEMP_hoverTankToSupplyShip[ hoverTank ] <- selected

	thread SupplyShipThink( hoverTank, selected )
}

void function SupplyShipThink( HoverTank hoverTank, SupplyShip ship )
{
	FlagWait( "Survival_LootSpawned" )

	WaitFrame()

	ship.mover.SetParent( hoverTank.flightMover, "", false )

	WaitSignal( hoverTank, SIGNAL_HOVERTANK_AT_ENDPOINT )

	SupplyShip_OpenDoors( ship )
}

void function HideHoverTank( HoverTank hoverTank )
{
	hoverTank.turret.NotSolid()
	hoverTank.turret.Hide()
	hoverTank.turretBarrelClip.NotSolid()
	hoverTank.turretBarrelClip.Hide()
	hoverTank.interiorModel.NotSolid()
	hoverTank.interiorModel.Hide()
	hoverTank.flightMover.NotSolid()
	hoverTank.flightMover.Hide()
	hoverTank.triggerVolume.Disable()
	foreach ( ent in hoverTank.linkedEnts )
	{
		ent.NotSolid()
		ent.Hide()
	}
}

void function HoverTanksOnGamestatePlaying()
{
	if ( file.numHoverTanksIntro == 0 )
		return

	thread HoverTanksOnGamestatePlaying_Thread()
}

void function HoverTanksOnGamestatePlaying_Thread()
{
	FlagWait( "Survival_LootSpawned" )

	if ( GetCurrentPlaylistVarInt( "canyonlands_hovertank_flyin", 1 ) == 1 )
	{
		// Fly to final nodes
		WaitFrame() // Perform this on a frame after other game state playing initialization to spread out the load
		FlyHoverTanksIntoPosition( file.hoverTanksIntro, HOVER_TANKS_TYPE_INTRO )
	}
	else if ( GetCurrentPlaylistVarInt( "canyonlands_hovertank_flyin", 1 ) == 2 )
	{
		//override behavior elsewhere
	}
	else
	{
		// Teleport to final nodes
		TeleportHoverTanksIntoPosition( file.hoverTanksIntro, HOVER_TANKS_TYPE_INTRO )
	}

	FlagSet( "IntroHovertanksSet" )
}

void function HoverTanksOnDeathFieldStageChanged( int stage, float nextCircleStartTime )
{
	if ( file.numHoverTanksMid == 0 )
		return

	if ( stage == GetCurrentPlaylistVarInt( "canyonlands_hovertanks_circle_index", HOVER_TANKS_DEFAULT_CIRCLE_INDEX ) )
	{
		thread FlyHoverTanksIntoPosition( file.hoverTanksMid, HOVER_TANKS_TYPE_MID )
		wait 7.0
		AddSurvivalCommentaryEvent( eSurvivalEventType.HOVER_TANK_INBOUND )
	}
}

#if DEVELOPER
void function Dev_TestHoverTankIntro()
{
	FlyHoverTanksIntoPosition( GetAllHoverTanks(), HOVER_TANKS_TYPE_INTRO )
}
#endif

void function FlyHoverTanksIntoPosition( array<HoverTank> hoverTanks, int hoverTanksType )
{
	// Get start nodes and end nodes. Playlist vars change how these are selected.
	array<entity> startNodes
	array<entity> endNodes
	if ( hoverTanksType == HOVER_TANKS_TYPE_INTRO )
	{
		Assert( file.hoverTankEndNodesIntro.len() == hoverTanks.len(), "Not enough hover tank end locations found!" )
		startNodes = GetHoverTankStartNodes( file.hoverTankEndNodesIntro )
		endNodes = file.hoverTankEndNodesIntro
	}
	else if ( hoverTanksType == HOVER_TANKS_TYPE_MID )
	{
		Assert( file.hoverTankEndNodesMid.len() == hoverTanks.len(), "Not enough hover tank end locations found!" )
		startNodes = GetHoverTankStartNodes( file.hoverTankEndNodesMid )
		endNodes = file.hoverTankEndNodesMid
	}
	else
	{
		Assert( false )
	}

	Assert( startNodes.len() == hoverTanks.len(), "Not enough hover tank start locations found!" )

	if ( endNodes.len() == 0 )
		return

	foreach( int i, HoverTank hoverTank in hoverTanks )
	{
		CreateHoverTankMinimapIconForPlayers( hoverTank )

		array<entity> nodeChain = GetEntityChainOfType( endNodes[ i ] )

		HoverTankTeleportToPosition( hoverTank, startNodes[i].GetOrigin(), startNodes[i].GetAngles() )
		//thread HoverTankDrawPathFX( hoverTank, nodeChain[ 0 ] )

		thread HoverTankAdjustSpeed( hoverTank )
		thread HoverTankForceBoost( hoverTank )
		thread HoverTankAttractLeviathans( hoverTank )

		thread HoverTankFlyNodeChain( hoverTank, nodeChain )
		thread HideMinimapEndpointsWhenHoverTankFinishesFlyin( hoverTank )
		CreateHoverTankEndpointIconForPlayers( nodeChain.top(), hoverTank )
	}
}

void function HoverTankAdjustSpeed( HoverTank hoverTank )
{
	EndSignal( hoverTank, "OnDestroy" )

	float startSlowTime = Time() + 10.0
	float decelEndTime = startSlowTime + 20.0
	float startSpeed = 1200.0
	float endSpeed = 300.0

	HoverTankSetCustomFlySpeed( hoverTank, startSpeed )

	while ( Time() < decelEndTime )
	{

		float speed = GraphCapped( Time(), startSlowTime, decelEndTime, startSpeed, endSpeed )
		HoverTankSetCustomFlySpeed( hoverTank, speed )
		WaitFrame()
	}

	HoverTankSetCustomFlySpeed( hoverTank, endSpeed )
}

void function HoverTankForceBoost( HoverTank hoverTank )
{
	EndSignal( hoverTank, "OnDestroy" )
	EndSignal( hoverTank, "PathFinished" )

	while ( true )
	{
		HoverTankEngineBoost( hoverTank )
		wait RandomFloatRange( 1.0 , 5.0 )
	}
}

void function HoverTankAttractLeviathans( HoverTank hoverTank )
{
	EndSignal( hoverTank, "OnDestroy" )
	EndSignal( hoverTank, "PathFinished" )

	while ( true )
	{
		Leviathan_ConsiderLookAtEnt( hoverTank.flightMover, RandomFloatRange( 5, 20 ), 0.25 )
		wait RandomFloatRange( 8.0, 20.0 )
	}
}

void function TeleportHoverTanksIntoPosition( array<HoverTank> hoverTanks, int hoverTanksType )
{
	array<entity> endNodes
	if ( hoverTanksType == HOVER_TANKS_TYPE_INTRO )
		endNodes = file.hoverTankEndNodesIntro
	else if ( hoverTanksType == HOVER_TANKS_TYPE_MID )
		endNodes = file.hoverTankEndNodesMid
	Assert( endNodes.len() == MAX_HOVERTANKS, "Not enough hover tank end locations found!" )

	foreach( int i, HoverTank hoverTank in hoverTanks )
	{
		entity teleportNode = GetLastLinkedEntOfType( endNodes[i] )
		HoverTankTeleportToPosition( hoverTank, teleportNode.GetOrigin(), teleportNode.GetAngles() )
		FireHoverTankZiplines( hoverTank, teleportNode )
	}
}

void function HideUnusedHovertankSpecificGeo()
{
	array<entity> hoverTankSpecificGeo
	array<entity> unusedEndNodes = GetAllHoverTankEndNodes()

	foreach( entity node in file.hoverTankEndNodesIntro )
		unusedEndNodes.fastremovebyvalue( node )

	foreach( entity node in file.hoverTankEndNodesMid )
		unusedEndNodes.fastremovebyvalue( node )

	foreach( entity node in unusedEndNodes )
	{
		entity lastNode = GetLastLinkedEntOfType( node )
		array<entity> endNodeLinkedEnts = lastNode.GetLinkEntArray()
		foreach( linkedEnt in endNodeLinkedEnts )
		{
			if ( linkedEnt.GetClassName() == "func_brush_lightweight" )
				linkedEnt.Destroy()
		}
	}
}

void function CreateHoverTankMinimapIconForPlayers( HoverTank hoverTank )
{
	vector hoverTankOrigin = hoverTank.interiorModel.GetOrigin()
	entity minimapObj = CreatePropScript( $"mdl/dev/empty_model.rmdl", hoverTankOrigin )
	minimapObj.Minimap_SetCustomState( eMinimapObject_prop_script.HOVERTANK )		// Minimap icon
	minimapObj.SetParent( hoverTank.interiorModel )
	minimapObj.SetLocalAngles( < 0, 0, 0 > )
	minimapObj.Minimap_SetZOrder( MINIMAP_Z_OBJECT + 10 ) // +10 to make it show up above the endpoint marker below
	SetTeam( minimapObj, TEAM_UNASSIGNED )
	SetTargetName( minimapObj, "hovertank" )		// Full map icon

	SetMinimapObjectVisibleToPlayers( minimapObj, true )
}

void function CreateHoverTankEndpointIconForPlayers( entity endpoint, HoverTank hoverTank )
{
	vector hoverTankOrigin = endpoint.GetOrigin()
	entity minimapObj = CreatePropScript( $"mdl/dev/empty_model.rmdl", hoverTankOrigin )
	minimapObj.Minimap_SetCustomState( eMinimapObject_prop_script.HOVERTANK_DESTINATION )		// Minimap icon
	minimapObj.Minimap_SetZOrder( MINIMAP_Z_OBJECT + 5 ) // +5 to make it show up above respawn beacons etc
	SetTeam( minimapObj, TEAM_UNASSIGNED )
	SetTargetName( minimapObj, "hovertankDestination" )		// Full map icon
	file.hovertankEndpointMapObjects[ hoverTank ] <- minimapObj

	SetMinimapObjectVisibleToPlayers( minimapObj, true )

	//foreach( entity player in GetPlayerArray_Alive() )
	//	Remote_CallFunction_NonReplay( player, "ServerCallback_SUR_PingMinimap", endpoint.GetOrigin(), 30.0, 500.0, 50.0, 2 )
}

void function HideHoverTankEndpointIconForPlayers( HoverTank hoverTank )
{
	if ( hoverTank in file.hovertankEndpointMapObjects )
	{
		entity endpoint = delete file.hovertankEndpointMapObjects[ hoverTank ]
		SetMinimapObjectVisibleToPlayers( endpoint, false )
	}
}

void function HideMinimapEndpointsWhenHoverTankFinishesFlyin( HoverTank hoverTank )
{
	EndSignal( hoverTank, "OnDestroy" )

	WaitSignal( hoverTank, SIGNAL_HOVERTANK_AT_ENDPOINT )

	HideHoverTankEndpointIconForPlayers( hoverTank )
}

void function SetMinimapObjectVisibleToPlayers( entity minimapObj, bool visible )
{
	foreach ( player in GetPlayerArray() )
	{
		if( visible )
			minimapObj.Minimap_AlwaysShow( 0, player )
		else
			minimapObj.Minimap_Hide( 0, player )
	}
}

#if NAVMESH_ALL_SUPPORTED
const int HULL_HOVERTANK = HULL_TITAN
#else
const int HULL_HOVERTANK = HULL_PROWLER
#endif

const int ZIP_ATTACH_RIGHT_IDX 		= 0
const int ZIP_ATTACH_LEFT_IDX 		= 1
const int ZIP_ATTACH_BACK_IDX 		= 2

const int NUM_ZIP_ATTACHMENTS		= 3
const float ZIPLINE_ATTACH_FOV		= 0.707
void function FireHoverTankZiplines( HoverTank hoverTank, entity endNode )
{
	bool hasSupplyShip = ( hoverTank in file.TEMP_hoverTankToSupplyShip )
	bool flattenVector = true

	if ( IsValid( hoverTank.flightMover ) )
	{
		hoverTank.flightMover.AllowZiplines()
		hoverTank.flightMover.AllowMantle()
	}

	array<entity> endNodeZiplineTargets = endNode.GetLinkEntArray()
	array<vector> endNodeZiplineTargetOrigins
	int numZiplineTargets
	foreach( targetEnt in endNodeZiplineTargets )
	{
		if ( targetEnt.GetClassName() != "info_target" )
			continue

		endNodeZiplineTargetOrigins.append( targetEnt.GetOrigin() )
		numZiplineTargets++
	}

	array<vector> hoverTankZiplineAttachOrigins
	array<vector> hoverTankZiplineAttachDirs

	if ( !hasSupplyShip )
	{
		entity extModel = hoverTank.flightMover
		int ziplineRAttach 	= extModel.LookupAttachment( "ZIPLINE_R" )
		int ziplineLAttach 	= extModel.LookupAttachment( "ZIPLINE_L" )
		int ziplineBAttach 	= extModel.LookupAttachment( "ZIPLINE_B" )
		hoverTankZiplineAttachOrigins.append( extModel.GetAttachmentOrigin( ziplineRAttach ) )
		hoverTankZiplineAttachDirs.append( extModel.GetRightVector() * -1 )
		hoverTankZiplineAttachOrigins.append( extModel.GetAttachmentOrigin( ziplineLAttach ) )
		hoverTankZiplineAttachDirs.append( extModel.GetRightVector() )
		hoverTankZiplineAttachOrigins.append( extModel.GetAttachmentOrigin( ziplineBAttach ) )
		hoverTankZiplineAttachDirs.append( extModel.GetForwardVector() * -1 )
	}
	else
	{
		SupplyShip ship = file.TEMP_hoverTankToSupplyShip[ hoverTank ]

		while ( !ship.frontDoorOpened || !ship.backDoorOpened )
			WaitFrame()

		endNodeZiplineTargetOrigins.clear()

		array<entity> startPoints = ship.ziplineNodes

		foreach ( ent in startPoints )
		{
			vector start = ent.GetOrigin()

			vector dir = <0,0,-1>

			hoverTankZiplineAttachOrigins.append( start )
			hoverTankZiplineAttachDirs.append( dir )

			TraceResults trace = TraceLine( start, start + (dir*8000), [], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
			vector org = trace.endPos

			vector ornull point = NavMesh_ClampPointForHullWithExtents( org, HULL_HOVERTANK, <100,100,100> )

			if ( point != null )
			{
				org = expect vector( point )
				endNodeZiplineTargetOrigins.append( org )
			}
		}

		flattenVector = false
	}

	array< array< vector > > zipAttachPairCandidates

	for( int i; i < hoverTankZiplineAttachOrigins.len(); i++ )
	{
		zipAttachPairCandidates.append( [] )
		vector attachDir = hoverTankZiplineAttachDirs[ i ]

		float maxDot = 0.0
		int indexToUse = -1

		vector attachOrigin = hoverTankZiplineAttachOrigins[ i ]

		for( int j; j < endNodeZiplineTargetOrigins.len() ; j++ )
		{
			vector fwd = flattenVector ? FlattenVec( endNodeZiplineTargetOrigins[ j ] - attachOrigin ) : ( endNodeZiplineTargetOrigins[ j ] - attachOrigin )
			vector hoverTankToPoint = Normalize( fwd )
			float dot2D             = DotProduct( hoverTankToPoint, attachDir )
			if ( dot2D > ZIPLINE_ATTACH_FOV && dot2D > maxDot )
			{
				maxDot = dot2D
				indexToUse = j
			}
		}

		if ( indexToUse != -1 )
		{
			int j = indexToUse
			vector ziplineEndOrigin = endNodeZiplineTargetOrigins[ j ]
			zipAttachPairCandidates[ i ].append( ziplineEndOrigin )
			array<entity> ziplineEnts = CreateHovertankZipline( attachOrigin, ziplineEndOrigin )
			thread HovertankZiplineLaunchSequence( ziplineEnts, attachOrigin, ziplineEndOrigin )
			endNodeZiplineTargetOrigins.remove( j )
		}
	}
}

void function HovertankZiplineLaunchSequence( array<entity> ziplineEnts, vector startPos, vector endPos )
{
	float time

	entity mover = CreateScriptMover( HOVER_TANKS_ZIP_MOVER_SCRIPTNAME, startPos )

	ziplineEnts[ 0 ].Zipline_Disable()
	ziplineEnts[ 1 ].SetOrigin( startPos )
	ziplineEnts[ 1 ].SetParent( mover )

	mover.NonPhysicsMoveTo( endPos, 0.5, 0, 0 )
	wait 0.5
	ziplineEnts[ 1 ].ClearParent()
	ziplineEnts[ 0 ].Zipline_Enable()
	mover.Destroy()
}

array<entity> function CreateHovertankZipline( vector startPos, vector endPos )
{
	return CreateZipline( startPos, endPos )
}

array<entity> function GetHoverTankStartNodes( array<entity> endNodes )
{
	if ( endNodes.len() == 1 )
	{
		array<entity> startNodes = GetEntArrayByScriptName( HOVERTANK_START_NODE_NAME )
		Assert( startNodes.len() >= 1 )
		startNodes.randomize()
		startNodes.resize(1)
		return startNodes
	}

	const vector DEV_APPROX_Z_OFFSET = < 0, 0, 8000 >
	const float NODE_TO_TARGET_DIR_DOT_TOLERANCE = cos( PI / 4 ) 			// Start nodes to be considered for selection must be within 45 degrees of target dir

	Assert( endNodes.len() == 2, "Hover tank start location chooser only works with 2 hover tanks!" )
	array<entity> startNodes = GetEntArrayByScriptName( HOVERTANK_START_NODE_NAME )
	Assert( startNodes.len() >= 2 )

	array<vector> endNodeOrigins = [ endNodes[ 0 ].GetOrigin(), endNodes[ 1 ].GetOrigin() ]
	array<vector> endNodeOrigins2D
	foreach( origin in endNodeOrigins )
	{
		vector origin2D = origin
		origin2D.z = 0
		endNodeOrigins2D.append( origin2D )
	}

	vector endNodeBToA = endNodeOrigins2D[ 1 ] - endNodeOrigins2D[ 0 ]
	vector endNodesMiddlePoint = endNodeOrigins2D[ 0 ] + ( endNodeBToA * 0.5 )
	vector dirBToA = Normalize( endNodeBToA )
	vector orthoBToA = CrossProduct( dirBToA, < 0, 0, 1 > )

	array< array< table > > startNodesSplitByEndNodes
	for( int i; i < endNodes.len(); i++ ) // Crashes if declared as [ [], [] ]
	{
		startNodesSplitByEndNodes.append( [] )
	}

	// Split nodes into two halves, separated by the line between end nodes. Save dot product values for later.
	foreach( node in startNodes)
	{
		vector nodeOrigin2D = node.GetOrigin()
		nodeOrigin2D.z = 0

		vector nodeToMidpointDir = Normalize( endNodesMiddlePoint - nodeOrigin2D )
		float mapHalfDot = DotProduct( nodeToMidpointDir, orthoBToA )
		if ( mapHalfDot < 0 )
			startNodesSplitByEndNodes[ 1 ].append( { ent = node, dot = mapHalfDot } )		// Negative half
		else
			startNodesSplitByEndNodes[ 0 ].append( { ent = node, dot = mapHalfDot } )		// Positive half
	}

	// Pick a random half of the map to fly in from (using splits above). If not enough nodes in given half, use other half.
	int startNodeSplitToUse = RandomIntRangeInclusive( 0, 1 )

	if ( GetBugReproNum() == 31493 )
		startNodeSplitToUse = 0

	if ( startNodesSplitByEndNodes[ startNodeSplitToUse ].len() < 2 )
		startNodeSplitToUse = 1 - startNodeSplitToUse

	// Find the two start nodes closest to the vector orthogonal to vector connecting end nodes, stemming from the midpoint between both nodes.
	entity closestNode
	entity secondClosestNode
	float smallestDot = -1
	float secondSmallestDot = -1

	foreach( nodeData in startNodesSplitByEndNodes[ startNodeSplitToUse ] )
	{
		if ( DEBUG_HOVERTANK_NODE_SELECTION )
			DebugDrawCircleRGB( expect entity(nodeData.ent).GetOrigin(), < 0, 0, 0 >, 1300.0, int(COLOR_GREEN.x), int(COLOR_GREEN.y), int(COLOR_GREEN.z), true, 10 )

		float nodeDot = expect float( nodeData.dot )
		nodeDot = fabs( nodeDot )	// Since using a split half of the nodes, no issues if abs value this
		entity nodeEnt = expect entity( nodeData.ent )

		if ( (smallestDot < 0) || (nodeDot > smallestDot) )
		{
			secondSmallestDot = smallestDot
			secondClosestNode = closestNode
			smallestDot = nodeDot
			closestNode = nodeEnt
		}
		else if ( (secondSmallestDot < 0) || (nodeDot > secondSmallestDot) )
		{
			secondSmallestDot = nodeDot
			secondClosestNode = nodeEnt
		}
	}

	// Order the chosen start nodes to match end nodes. Make sure start node is paired with correct end node. If paths intersect, flip start -> node assignment
	array< entity > retArray		= [ secondClosestNode, closestNode ]
	bool intersect           = Do2DLinesIntersect( retArray[ 0 ].GetOrigin(), endNodes[ 0 ].GetOrigin(), retArray[ 1 ].GetOrigin(), endNodes[ 1 ].GetOrigin() )
	if ( intersect )
		retArray.reverse()

	if ( DEBUG_HOVERTANK_NODE_SELECTION )
	{
		DebugDrawCircleRGB( closestNode.GetOrigin() + < 0, 0, 64 >, < 0, 0, 0 >, 1300.0, int(COLOR_MAGENTA.x), int(COLOR_MAGENTA.y), int(COLOR_MAGENTA.z), true, 10 )
		DebugDrawCircleRGB( secondClosestNode.GetOrigin() + < 0, 0, 64 >, < 0, 0, 0 >, 1300.0, int(COLOR_MAGENTA.x), int(COLOR_MAGENTA.y), int(COLOR_MAGENTA.z), true, 10 )
		DebugDrawCircleRGB( endNodeOrigins2D[ 0 ] + DEV_APPROX_Z_OFFSET, < 0, 0, 0 >, 1300.0, int(COLOR_CYAN.x), int(COLOR_CYAN.y), int(COLOR_CYAN.z), true, 10 )
		DebugDrawCircleRGB( endNodeOrigins2D[ 1 ] + DEV_APPROX_Z_OFFSET, < 0, 0, 0 >, 1300.0, int(COLOR_CYAN.x), int(COLOR_CYAN.y), int(COLOR_CYAN.z), true, 10 )

		DebugDrawLineRGB( endNodeOrigins2D[ 0 ] + DEV_APPROX_Z_OFFSET, endNodeOrigins2D[ 1 ] + DEV_APPROX_Z_OFFSET, int(COLOR_YELLOW.x), int(COLOR_YELLOW.y), int(COLOR_YELLOW.z), true, 10 )
		DebugDrawLineRGB( endNodesMiddlePoint + (orthoBToA * 96000) + DEV_APPROX_Z_OFFSET, endNodesMiddlePoint + (orthoBToA * -96000) + DEV_APPROX_Z_OFFSET, 255, 120, 0, true, 10 )

		DebugDrawLineRGB( retArray[ 0 ].GetOrigin(), endNodes[ 0 ].GetOrigin(), int(COLOR_RED.x), int(COLOR_RED.y), int(COLOR_RED.z), true, 10 )
		DebugDrawLineRGB( retArray[ 1 ].GetOrigin(), endNodes[ 1 ].GetOrigin(), int(COLOR_RED.x), int(COLOR_RED.y), int(COLOR_RED.z), true, 10 )
		DebugDrawLineRGB( closestNode.GetOrigin(), endNodesMiddlePoint + DEV_APPROX_Z_OFFSET, int(COLOR_RED.x), int(COLOR_RED.y), int(COLOR_RED.z), true, 10 )
		DebugDrawLineRGB( secondClosestNode.GetOrigin(), endNodesMiddlePoint + DEV_APPROX_Z_OFFSET, int(COLOR_YELLOW.x), int(COLOR_YELLOW.y), int(COLOR_YELLOW.z), true, 10 )

		DebugDrawSphereRGB( endNodesMiddlePoint + DEV_APPROX_Z_OFFSET, 32, int(COLOR_MAGENTA.x), int(COLOR_MAGENTA.y), int(COLOR_MAGENTA.z), true, 10 )
		DebugDrawSphereRGB( endNodeOrigins2D[ 0 ] + DEV_APPROX_Z_OFFSET, 32, int(COLOR_MAGENTA.x), int(COLOR_MAGENTA.y), int(COLOR_MAGENTA.z), true, 10 )
		DebugDrawSphere( endNodeOrigins2D[ 1 ] + DEV_APPROX_Z_OFFSET, 32, <125, 125, 255>, true, 10 )
	}

	return retArray
}


array<entity> function GetHoverTankEndNodes( int count, int endNodeType, array<entity> excludeNodes )
{
	Assert( endNodeType == HOVER_TANKS_TYPE_INTRO || endNodeType == HOVER_TANKS_TYPE_MID )
	array<entity> potentialEndNodes = GetAllHoverTankEndNodes()

	// Remove exclude nodes
	foreach( entity node in excludeNodes )
		potentialEndNodes.fastremovebyvalue( node )

	if ( GetCurrentPlaylistVarInt( "canyonlands_dynamic_hovertank_locations", 1 ) != 1 )
	{
		// Don't use random locations, only use original end locations
		for ( int i = potentialEndNodes.len() - 1; i >= 0; i-- )
		{
			if ( !potentialEndNodes[i].HasKey( "original_tank_location" ) || (int( expect string( potentialEndNodes[i].kv.original_tank_location ) ) != 1) )
				potentialEndNodes.remove( i )
		}
	}
	potentialEndNodes.randomize()

	if ( !SURVIVAL_HasDeathFieldStages( Survival_Loot_GetDefaultRealm() ) )
	{
		array<entity> nodesNoRing
		foreach( entity node in potentialEndNodes )
		{
			if ( nodesNoRing.len() >= count )
				break
			nodesNoRing.append( node )
		}
		return nodesNoRing
	}

	// Don't allow hover tank positions that will be within one of the final circles because they are OP positions for end game
	array<entity> nodesNotInFinalCircles
	int deathFieldStageIndexSmall = GetCurrentPlaylistVarInt( "canyonlands_hovertanks_circle_index", HOVER_TANKS_DEFAULT_CIRCLE_INDEX ) + 1
	if ( deathFieldStageIndexSmall >= SURVIVAL_GetDeathFieldStages( Survival_Loot_GetDefaultRealm() ).len() )
	{
		Warning( "Hovertank playlist var 'canyonlands_hovertanks_circle_index' has bad death field stage: %d", deathFieldStageIndexSmall )
		deathFieldStageIndexSmall = SURVIVAL_GetDeathFieldStages( Survival_Loot_GetDefaultRealm() ).len() - 1
	}
	DeathFieldStageData deathFieldStageDataSmall = GetDeathFieldStage( Survival_Loot_GetDefaultRealm(), deathFieldStageIndexSmall )
	float invalidRadius = deathFieldStageDataSmall.endRadius + HOVER_TANK_RADIUS
	for ( int i = potentialEndNodes.len() - 1; i >= 0; i-- )
	{
		if ( Distance2D( deathFieldStageDataSmall.endPos, potentialEndNodes[i].GetOrigin() ) <= invalidRadius )
			potentialEndNodes.remove( i )
	}

	if ( endNodeType == HOVER_TANKS_TYPE_MID )
	{
		// Exclude end nodes that are outside the current safe circle
		int deathFieldStageIndexLarge = GetCurrentPlaylistVarInt( "canyonlands_hovertanks_circle_index", HOVER_TANKS_DEFAULT_CIRCLE_INDEX )
		if ( deathFieldStageIndexLarge >= SURVIVAL_GetDeathFieldStages( Survival_Loot_GetDefaultRealm() ).len() )
		{
			Warning( "Hovertank playlist var 'canyonlands_hovertanks_circle_index' has bad death field stage: %d", deathFieldStageIndexLarge )
			deathFieldStageIndexLarge = SURVIVAL_GetDeathFieldStages( Survival_Loot_GetDefaultRealm() ).len() - 1
		}
		DeathFieldStageData deathFieldStageDataLarge = GetDeathFieldStage( Survival_Loot_GetDefaultRealm(), deathFieldStageIndexLarge )
		for ( int i = potentialEndNodes.len() - 1; i >= 0; i-- )
		{
			if ( Distance2D( deathFieldStageDataLarge.endPos, potentialEndNodes[i].GetOrigin() ) >= deathFieldStageDataLarge.endRadius )
				potentialEndNodes.remove( i )
		}
	}

	if ( potentialEndNodes.len() > 1 )
		potentialEndNodes.randomize()

	// Pick randomly from what we have left
	array<entity> endNodesToUse
	foreach( entity node in potentialEndNodes )
	{
		if ( endNodesToUse.len() >= count )
			break
		endNodesToUse.append( node )
	}
	return endNodesToUse
}

void function HoverTankFlyNodeChain( HoverTank hoverTank, array<entity> nodes )
{
	EndSignal( hoverTank, "OnDestroy" )
	EndSignal( hoverTank.flightMover, "OnDestroy" )

	int numNodes = nodes.len()
	for ( int i = 0; i < numNodes; i++ )
	{
		waitthread HoverTankFlyToNode( hoverTank, nodes[ i ] )
	}

	Signal( hoverTank, SIGNAL_HOVERTANK_AT_ENDPOINT )

	FireHoverTankZiplines( hoverTank, nodes.top() )
}

array<entity> function GetAllHoverTankEndNodes()
{
	return GetEntArrayByScriptName( HOVERTANK_END_NODE_NAME )
}

void function HoverTank_DebugFlightPaths()
{
	thread HoverTank_DebugFlightPaths_Thread()
}

void function HoverTank_DebugFlightPaths_Thread()
{
	printt( "++++--------------------------------------------------------------------------------------------------------------------------++++" )
	printt( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>> DEBUGGING HOVERTANK FLIGHT PATH PERMUTATIONS ON CANYONLANDS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" )
	printt( "++++--------------------------------------------------------------------------------------------------------------------------++++" )

	array<entity> endNodes = GetAllHoverTankEndNodes()
	array<entity> startNodes = GetEntArrayByScriptName( HOVERTANK_START_NODE_NAME )
	int numEndNodes = endNodes.len()
	int numStartNodes = startNodes.len()
	int numChecksPerFrame = 10
	int numChecksDone = 0

	for( int i = 0; i < numStartNodes; i++ )
	{
		entity currentStartNode = startNodes[ i ]

		for( int j = 0; j < numEndNodes; j++ )
		{
			entity currentEndNode = endNodes[ j ]
			if ( !HoverTankCanFlyPath( currentStartNode.GetOrigin(), currentEndNode ) )
			{
				Warning( "HoverTank can't fly from " + currentStartNode.GetOrigin() + " to " + currentEndNode.GetOrigin() + " because the path is broken" )
				DebugDrawLineRGB( currentStartNode.GetOrigin(), currentEndNode.GetOrigin(), int(COLOR_RED.x), int(COLOR_RED.y), int(COLOR_RED.z), true, 20.0 )
			}
			numChecksDone++
			if ( numChecksDone >= numChecksPerFrame )
			{
				numChecksDone = 0
				WaitFrame()
			}
		}
	}
	printt( "++++--------------------------------------------------------------------------------------------------------------------------++++" )
	printt( "++++--------------------------------------------------------------------------------------------------------------------------++++" )
}

#if SERVER
#if DEVELOPER
void function HoverTankTestPositions()
{
	entity player = GetPlayerArray()[0]

	HoverTank hoverTank = SpawnHoverTank_Cheap( "HoverTank_1" )
	hoverTank.playerRiding = true
	//file.hoverTanksMid.append( hoverTank )

	array<entity> endNodes = GetAllHoverTankEndNodes()

	foreach( entity node in endNodes )
	{
		//DebugDrawSphere( node.GetOrigin(), 1024, COLOR_RED, true, 9999.0 )
		entity teleportNode = GetLastLinkedEntOfType( node )
		HoverTankTeleportToPosition( hoverTank, teleportNode.GetOrigin(), teleportNode.GetAngles() )
		FireHoverTankZiplines( hoverTank, teleportNode )

		player.SetOrigin( teleportNode.GetOrigin() + < 0, 0, 1024 > )
		player.SetAngles( teleportNode.GetAngles() )

		while( player.IsInputCommandHeld( IN_SPEED ) || player.IsInputCommandHeld( IN_ZOOM ) )
			WaitFrame()

		while( !player.IsInputCommandHeld( IN_SPEED ) || !player.IsInputCommandHeld( IN_ZOOM ) )
			WaitFrame()
	}
}
#endif
#endif

void function TestCreateTooManyLinks()
{
	wait 1
	entity fromEntity = GetEntByIndex( 1 );
	if ( IsValid( fromEntity ) )
	{
		for ( int i = 0; i < 100; ++i )
		{
			for ( int j = 0; j < 100; ++j )
			{
				int index = (i * 100) + j + 1
				entity toEntity = GetEntByIndex( index )
				if ( IsValid( toEntity ) )
				{
					if ( !fromEntity.IsLinkedToEnt( toEntity ) )
					{
						printt( "Linking " + fromEntity + " to " + toEntity )
						fromEntity.LinkToEnt( toEntity )
					}
				}
			}
			wait 0
		}
	}
}

void function Nessies()
{
	entity skyboxCam = GetEnt( "skybox_cam_level" )
	if ( !IsValid( skyboxCam ) )
		return

	array<entity> nessies
	int i = 1
	while( true )
	{
		array<entity> ents = GetEntArrayByScriptName( "nessy" + i )
		if ( ents.len() != 1 )
			break
		entity nessy = ents.pop()
		nessy.Hide()
		nessy.NotSolid()
		nessies.append( nessy )
		i++
	}

	if ( nessies.len() == 0 )
		return

	int nessiesRequired = GetCurrentPlaylistVarInt( "nessies_required", nessies.len() )

	foreach( entity nessy in nessies )
	{
		nessy.Show()
		nessy.Solid()
		AddEntityCallback_OnDamaged( nessy, NessyDamageCallback )

		WaitSignal( nessy, "NessyDamaged" )
		nessy.Destroy()

		nessiesRequired--
		if ( nessiesRequired <= 0 )
			break

		foreach( entity player in GetPlayerArray() )
			Remote_CallFunction_NonReplay( player, "ServerCallback_NessyMessage", 0 )
	}

	foreach( entity player in GetPlayerArray() )
		Remote_CallFunction_NonReplay( player, "ServerCallback_NessyMessage", 1 )

	entity nessy = CreateScriptMoverModel( NESSY_MODEL, skyboxCam.GetOrigin() + <90,10,-20>, <0,90,0> )
	nessy.NonPhysicsMoveTo( skyboxCam.GetOrigin() + <60,10,-4>, 30.0, 4.0, 4.0 )
	nessy.NonPhysicsRotateTo( <0,110,0>, 15, 5, 5 )
	wait 15.0
	nessy.NonPhysicsRotateTo( <0,90,0>, 20, 5, 5 )
	wait 20.0
	nessy.NonPhysicsMoveTo( skyboxCam.GetOrigin() + <60,10,-20>, 20.0, 4.0, 4.0 )
	nessy.NonPhysicsRotateTo( <0,-90,0>, 20, 8, 8 )
	wait 20.0
	nessy.Destroy()
}

void function NessyDamageCallback( entity ent, var damageInfo )
{
	entity attacker = DamageInfo_GetAttacker( damageInfo )
	if ( IsValid( attacker ) && attacker.IsPlayer() )
	{
		Signal( ent, "NessyDamaged" )
		PlayerDamageFeedback( ent, damageInfo, 0 )
	}
}
#endif

#if CLIENT

void function OnLeviathanMarkerCreated( entity marker )
{
	string markerTargetName = marker.GetTargetName()
	printt( "OnLeviathanMarkerCreated, targetName: " + markerTargetName  )
	#if DEVELOPER
		if ( IsValid( file.clientSideLeviathan1 ) && markerTargetName == CANYONLANDS_LEVIATHAN1_NAME )
		{
			printt( "Destroying clientSideLeviathan1 with markerName: " + markerTargetName  )
			file.clientSideLeviathan1.Destroy()
		}

		if ( IsValid( file.clientSideLeviathan2 ) && markerTargetName == CANYONLANDS_LEVIATHAN2_NAME )
		{
			printt( "Destroying clientSideLeviathan2 with markerName: " +  markerTargetName )
			file.clientSideLeviathan2.Destroy()
		}

		if ( IsValid( file.clientSideLeviathan3 ) && markerTargetName == CANYONLANDS_LEVIATHANBABY_NAME )
		{
			printt( "Destroying clientSideLeviathan3 with markerName: " +  markerTargetName )
			file.clientSideLeviathan3.Destroy()
		}

	#endif

	entity leviathan = CreateClientSidePropDynamic( marker.GetOrigin(), marker.GetAngles(), LEVIATHAN_MODEL )

	if ( markerTargetName == CANYONLANDS_LEVIATHAN1_NAME )
		file.clientSideLeviathan1 = leviathan
	else if ( markerTargetName == CANYONLANDS_LEVIATHAN2_NAME )
		file.clientSideLeviathan2 = leviathan
	else if ( markerTargetName ==  CANYONLANDS_LEVIATHANBABY_NAME )
	{
		file.clientSideLeviathan3 = leviathan
		file.clientSideLeviathan3.SetModelScale( 0.5 )
	}

	bool stagingOnly = markerTargetName == "leviathan_staging"
	if ( stagingOnly  )
		SetAnimateInStaticShadow( leviathan, false )
	else
		SetAnimateInStaticShadow( leviathan, true )

	thread LeviathanThink( marker, leviathan, stagingOnly )
}

void function LeviathanThink( entity marker, entity leviathan, bool stagingOnly )
{
	marker.EndSignal( "OnDestroy" )
	leviathan.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function () : ( leviathan )
		{
			if ( IsValid( leviathan ) )
			{
				leviathan.Destroy()
			}
		}
	)

	leviathan.Anim_Play( "ACT_IDLE"  )

	// Prevent rare bug where leviathan anims sync up
	const float CYCLE_BUFFER_DIST = 0.3
	Assert( CYCLE_BUFFER_DIST < 0.5, "Warning! Impossible to get second leviathan random animation cycle if cycle buffer distance is 0.5 or greater!" )

	float randCycle
	if ( file.lastLevAnimCycleChosen < 0 )
		randCycle = RandomFloat( 1.0 )
	else
	{
		// Get the range that remains when the full buffer range is subtracted, then roll within that range.
		// Add that roll to the buffer top end (last chosen val + buffer), use modulo to clamp within 0 - 1
		float randomRoll = RandomFloat( 1.0 - ( CYCLE_BUFFER_DIST * 2 ) )
		float adjustedRandCycle = ( file.lastLevAnimCycleChosen + CYCLE_BUFFER_DIST + randomRoll ) % 1.0
		randCycle = adjustedRandCycle
	}

	file.lastLevAnimCycleChosen = randCycle

	leviathan.SetCycle( randCycle )
	WaitForever()

}

array<entity> function GetClientSideLeviathans()
{
	return [ file.clientSideLeviathan1, file.clientSideLeviathan2  ]
}

entity function GetClientSideLeviathan1()
{
	return file.clientSideLeviathan1

}

entity function GetClientSideLeviathan2()
{
	return file.clientSideLeviathan2

}
#endif

void function CodeCallback_PlayerEnterUpdraftTrigger( entity trigger, entity player )
{
	float entZ = player.GetOrigin().z
	OnEnterUpdraftTrigger( trigger, player, entZ + 100 )
}


void function CodeCallback_PlayerLeaveUpdraftTrigger( entity trigger, entity player )
{
	OnLeaveUpdraftTrigger( trigger, player )
}
#if CLIENT

void function MinimapPackage_HoverTank( entity ent, var rui )
{
	if ( MINIMAP_DEBUG )
		printt( "Adding 'rui/hud/gametype_icons/survival/sur_hovertank_minimap' icon to minimap" )

	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/survival/sur_hovertank_minimap" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}


void function MinimapPackage_HoverTankDestination( entity ent, var rui )
{
	if ( MINIMAP_DEBUG )
		printt( "Adding 'rui/hud/gametype_icons/survival/sur_hovertank_minimap_destination' icon to minimap" )

	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/survival/sur_hovertank_minimap_destination" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}
#endif

#if SERVER
// ported from mp_rr_canyonlands_mu1_common.nut / mu3_common.nut (identical bodies there) so
// hu can reach it too -- generic burn-trigger sound hookup, not actually Octane-TT-specific
void function InitOctaneTownTakeover()
{
	PrecacheParticleSystem( FX_OCTANE_TT_GUN_BG )
	AddDamageCallbackSourceID( eDamageSourceId.burn, PlayerTookBurnTriggerDamage )
}

void function PlayerTookBurnTriggerDamage( entity ent, var damageInfo )
{
	if ( !ent.IsPlayer() )
		return

	entity attacker = DamageInfo_GetAttacker( damageInfo )

	if ( !IsValid( attacker ) )
		return

	if ( attacker.GetClassName() != "trigger_hurt" )
		return

	EmitSoundOnEntityOnlyToPlayer( ent, ent, "flesh_thermiteburn_3p_vs_1p" )
}

// ported from mp_rr_canyonlands_mu1_common.nut so hu can reach it too -- self-guards on the
// "octane_tt_hanging_item_spawn" POI entity, no-ops harmlessly if the map doesn't have one
void function PlaceOctaneTownTakeoverLoot()
{
	array<entity> itemSpawn = GetEntArrayByScriptName( "octane_tt_hanging_item_spawn" )
	if ( itemSpawn.len() != 1 )
		return

	entity target  = itemSpawn[ 0 ]
	string itemRef = SURVIVAL_GetWeightedItemFromGroup( "POI_OctaneTT" )

	entity spawnedItem = SpawnGenericLoot( itemRef, target.GetOrigin(), < -1, -1, -1 > )
	spawnedItem.RemoveUsableValue( USABLE_USE_VERTICAL_LINE )
	spawnedItem.RemoveUsableValue( USABLE_HORIZONTAL_FOV )
	spawnedItem.AddUsableValue( USABLE_USE_DISTANCE_OVERRIDE )
	spawnedItem.SetUsableDistanceOverride( 300.0 )

	//FACING DIRECTION
	spawnedItem.SetAngles( < 0, 90, 0 > )

	vector boundingSize = spawnedItem.GetBoundingMaxs() - spawnedItem.GetBoundingMins()
	float originOffset  = boundingSize.z * 0.8
	if ( boundingSize.x > boundingSize.z )
	{
		//FLAT VS STANDING DIRECTION
		vector angles = spawnedItem.GetAngles()
		spawnedItem.SetAngles( < angles.x + 90, angles.y, angles.z > )
		originOffset = boundingSize.x * 0.5
	}

	vector targetToCenter = spawnedItem.GetCenter() - target.GetOrigin()
	spawnedItem.SetOrigin( target.GetOrigin() - < 0, 0, boundingSize.z * 0.5 > )

	int bgFxId = GetParticleSystemIndex( FX_OCTANE_TT_GUN_BG )
	StartParticleEffectOnEntityWithPos( spawnedItem, bgFxId, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID, < -45, 0, 0 >, < 0, 0, 0 > )
}
#endif // SERVER
