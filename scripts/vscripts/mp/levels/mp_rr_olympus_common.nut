global function Olympus_MapInit_Common

#if SERVER
global function Olympus_SetRiftParams
#endif

const float RIFT_INNER_RADIUS = 850.0
const float RIFT_OUTER_RADIUS = 1200.0
const float RIFT_REDUCE_SPEED_INNER = 250.0
const float RIFT_REDUCE_SPEED_OUTER = 500.0
const float RIFT_PULL_SPEED = 1500.0
const float RIFT_SWIRL_ACCEL = 1200.0
const float RIFT_TRIGGER_BOX_SIZE = 350.0

global struct OlympusRiftParams
{
	float innerRadius = RIFT_INNER_RADIUS
	float outerRadius = RIFT_OUTER_RADIUS
	float reduceSpeedInner = RIFT_REDUCE_SPEED_INNER
	float reduceSpeedOuter = RIFT_REDUCE_SPEED_OUTER
	float pullSpeed = RIFT_PULL_SPEED
	float swirlAccel = RIFT_SWIRL_ACCEL
	float triggerBoxSize = RIFT_TRIGGER_BOX_SIZE
}

const string LIFELINETT_PLAYLIST_ENABLE_MEDKIT_SPAWNS = "lifeline_tt_medkit_spawns"
const string LIFELINETT_LOOT_KEYWORD = "lifeline_tt_loot"

struct
{
	table< entity, int > riftHandles
	OlympusRiftParams &riftParams
} file

void function Olympus_MapInit_Common()
{
	printf( "%s()", FUNC_NAME() )

	ShPrecacheSkydiveLauncherAssets()

	                        
		if ( GameMode_IsActive( eGameModes.CONTROL ) )
		{
			#if SERVER || CLIENT
				// ToDo: DSwieczko: Find a Level Ed solution for this
				Control_SetHomeBaseBadPlacesForMRBForAlliance( ALLIANCE_A, [ <4974.02686, 1975.41541, -4458.56885>, <1061.4856, 6256.33154, -5323.96875>, <-3439.14258, 7960.45068, -5095.95801>, <3797.76172, 8994.75, -5087.31396>, <-3947.23169, 6873.3335, -5095.96875>, <2989.89453, 4081.48608, -4804.11621>, <-890.098938, 6173.85254, -5263.30566> ] )
				Control_SetHomeBaseBadPlacesForMRBForAlliance( ALLIANCE_B, [ <-16851.3535, -7533.10938, -5167.93262>, <-17533.2793, -5086.30225, -5117.9248>, <-15849.4941, 788.421082, -5450.62695>, <-15126.8623, -9503.92285, -4598.41455>, <-20152.125, -6325.14648, -5248.32715>, <-17877.4824, 2665.34277, -5367.86133>, <-16494.5742, -2241.39136, -5163.96875> ] )
			#endif // SERVER || CLIENT
		}
       

	#if CLIENT
		Freefall_SetPlaneHeight( 12500 )
		Freefall_SetDisplaySeaHeightForLevel( -11500 )
	#endif

	#if SERVER
		InitVehicleARBarriers()

		if ( GetCurrentPlaylistVarBool( "olympus_rift_enabled", true ) )
		{
			AddSpawnCallback( "info_target", Rift_Init )
		}

		thread KillPlayersUnderMap_Thread( MAP_KILL_VOLUME_OFFSET_OLYMPUS ) //-28320

                       
                                                                                      
                             
	#endif

	#if CLIENT
                       
                                                              
                             
	#endif

	#if SERVER
	#if DEVELOPER
		AddCallback_EntitiesDidLoad( EntitiesDidLoad )
	#endif
	#endif

	#if CLIENT
		SetMinimapBackgroundTileImage( $"overviews/mp_rr_olympus_bg" )
	#endif
}

#if SERVER
#if DEVELOPER
void function EntitiesDidLoad()
{
	// JFS: Create phase runner pings

	                   
		thread LifelineTT_SpawnMedKits()
       
}
#endif
#endif


#if SERVER

void function InitVehicleARBarriers()
{
	AddSpawnCallback( "func_brush", void function ( entity brush )
	{
		//printf( "Vehicle AR Barriers - tn:'%s', ec:'%s'", brush.GetTargetName(), GetEditorClass( brush ) )
		if ( brush.GetScriptName() != "vehicle_fence_01" )
			return

		brush.NotSolid()
	} )
}

///// Olympus rift /////

void function Rift_Init( entity ent )
{
	if ( ent.GetTargetName() != "z4_antigrav" )
		return

	entity trigger = CreateEntity( "trigger_point_gravity" )
	trigger.SetOrigin( ent.GetOrigin() )
	trigger.SetAngles( ent.GetAngles() )
	trigger.SetParams( file.riftParams.innerRadius, file.riftParams.outerRadius, file.riftParams.reduceSpeedInner, file.riftParams.reduceSpeedOuter, file.riftParams.swirlAccel, file.riftParams.pullSpeed )
	trigger.SetEnterCallback( OnEntityEnterRiftTrigger )
	trigger.SetLeaveCallback( OnEntityLeaveRiftTrigger )
	trigger.kv.triggerFilterPlayer = "all"
	trigger.kv.triggerFilterPhaseShift = "any"

	DispatchSpawn( trigger )

	//trigger.SetHasConstantPullStregnth( true )
	//trigger.SetAndEnableTriggerSize( file.riftParams.triggerBoxSize )

	trigger.Enable()
}

void function OnEntityEnterRiftTrigger( entity trigger, entity ent )
{
	printf( "Rift: Entity entered" )

	// PreparePlayerForPositionReset here and in sh_warp_gates.gnut

//	if ( IsValid( ent ) && ent.IsPlayerVehicle() && ent.VehicleGetType() == VEHICLE_FLYING_CAMERA )
	//	ent.TakeDamage( ent.GetMaxHealth(), svGlobal.worldspawn, svGlobal.worldspawn, { damageSourceId = eDamageSourceId.crushed, scriptType =  DF_BYPASS_SHIELD | DF_SKIPS_DOOMED_STATE }   )

	if ( IsValidPlayer( ent ) )
		GravityAirControl( ent )
}

void function OnEntityLeaveRiftTrigger( entity trigger, entity ent )
{
	printf( "Rift: Entity leaving" )

	if ( IsValidPlayer( ent ) )
		DisableGravityAirControl( ent )
}

void function GravityAirControl( entity player )
{
	file.riftHandles[player] <- StatusEffect_AddEndless(player, eStatusEffect.in_olympus_rift, 1.0)
	player.kv.airSpeed = 500
	player.kv.airAcceleration = 10000
}

void function DisableGravityAirControl( entity player )
{
	StatusEffect_Stop(player, file.riftHandles[player] )
	player.kv.airSpeed = player.GetPlayerSettingFloat( "airSpeed" )
	player.kv.airAcceleration = player.GetPlayerSettingFloat( "airAcceleration" )
}

void function Olympus_SetRiftParams( OlympusRiftParams params )
{
	file.riftParams = params
}

                   
void function LifelineTT_SpawnMedKits()
{
	if ( !GetCurrentPlaylistVarBool( LIFELINETT_PLAYLIST_ENABLE_MEDKIT_SPAWNS, true ) )
		return

	ResourceCollection rc = ORS_Find_( ORS_GetGlobalGroup(), eSearchFlags.NONE, [eORType.LOOT_SPAWN], [LIFELINETT_LOOT_KEYWORD], [] )
	printt ("medkit spawns are :" + rc.lootSpawns.len())
	foreach ( lootSpawn in rc.lootSpawns )
	{
		if ( lootSpawn.spawned )
			return

		string lootRef = lootSpawn.lootRef
		LootData data  = SURVIVAL_Loot_GetLootDataByRef( lootRef )
		entity loot    = SpawnGenericLoot( lootRef, lootSpawn.core.spawnOrigin, lootSpawn.core.spawnAngles, data.countPerDrop )
		lootSpawn.spawned = true
	}
}
                         

#endif
