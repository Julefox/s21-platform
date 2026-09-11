#if SERVER

global function SPL_Init
global function IsPositionGoodForAnEndRing
global function IsPositionGoodForAnEndRing_Internal
global function SPL_GetClosestPosition
global function SPL_GetRandomEndRingPosition_Slow
#if DEVELOPER
global function DEV_SPL_DrawWildLifeLocations
#endif

const GEYSER_MINIMUM_DISTANCE = 1500.0
const HARMFUL_AREA_MINIMUM_DISTANCE = 800.0
const WILDLIFE_MINIMUM_DISTANCE = 1500.0

const GEYSER_MINIMUM_DISTANCE_SQUARED = GEYSER_MINIMUM_DISTANCE * GEYSER_MINIMUM_DISTANCE
const WILDLIFE_MINIMUM_DISTANCE_SQUARED = WILDLIFE_MINIMUM_DISTANCE * WILDLIFE_MINIMUM_DISTANCE

// Scripted stand-in for the S21 engine SPL natives (no prebaked list on S3).
const int SPL_ENDRING_MAX_ATTEMPTS = 48
const float SPL_ENDRING_FALLBACK_RADIUS = 20000.0

const string EDITOR_CLASS_CAMP_ROOT_KEYWORD = "info_ai_camp_node"
const string EDITOR_CLASS_CAMP_ASSAULT_RADIUS_KEYWORD = "info_ai_camp_assaultradius"
const string EDITOR_CLASS_CAMP_TREASURE_CHEST_KEYWORD = "info_ai_camp_treasurechest"
const string EDITOR_CLASS_PROWLER_SPAWNPOINT_KEYWORD = "info_ai_spawnpoint_prowler"
const string EDITOR_CLASS_SPIDER_SPAWNPOINT_KEYWORD = "info_ai_spawnpoint_spider"

struct
{
	array< vector > wildlifeSpawns
	array< vector > geysers
} file

void function SPL_Init()
{
	AddSpawnCallbackEditorClass( "script_ref"   , EDITOR_CLASS_CAMP_ROOT_KEYWORD            , SPL_WildlifeSpawn )
	AddSpawnCallbackEditorClass( "script_ref"   , EDITOR_CLASS_CAMP_ASSAULT_RADIUS_KEYWORD  , SPL_WildlifeSpawn )
	AddSpawnCallbackEditorClass( "script_ref"   , EDITOR_CLASS_CAMP_TREASURE_CHEST_KEYWORD  , SPL_WildlifeSpawn )
	AddSpawnCallbackEditorClass( "info_target"  , EDITOR_CLASS_PROWLER_SPAWNPOINT_KEYWORD   , SPL_WildlifeSpawn )
	AddSpawnCallbackEditorClass( "info_target"  , EDITOR_CLASS_SPIDER_SPAWNPOINT_KEYWORD    , SPL_WildlifeSpawn )

	AddSpawnCallback_ScriptName( "geyser_jump", SPL_GeyserSpawn )
}

#if DEVELOPER
void function DEV_SPL_DrawWildLifeLocations()
{
	foreach ( vector wildlifePosition in file.wildlifeSpawns )
	{
		DebugDrawSphereRGB( wildlifePosition, WILDLIFE_MINIMUM_DISTANCE, int(COLOR_RED.x), int(COLOR_RED.y), int(COLOR_RED.z), true, 10000.0 )
	}
}
#endif

void function SPL_WildlifeSpawn( entity wildlifeEntity )
{
	file.wildlifeSpawns.append( wildlifeEntity.GetOrigin() )
}

void function SPL_GeyserSpawn( entity geyserEntity )
{
	file.geysers.append( geyserEntity.GetOrigin() )
}

// S21 engine name: clamp to navmesh (SDK NavMesh_GetClosestPoint).
vector function SPL_GetClosestPosition( vector position )
{
	return NavMesh_GetClosestPoint( position )
}

// S21 engine native was prebaked SPL; sample map disk + end-ring quality filter.
// ZERO_VECTOR = no candidate (deathfield falls through to procedural final ring).
vector function SPL_GetRandomEndRingPosition_Slow()
{
	vector center = SURVIVAL_GetCalculatedMapCenter()
	float radius = SURVIVAL_GetCalculatedMapRadiusBig()
	if ( radius <= 0.0 )
		radius = SPL_ENDRING_FALLBACK_RADIUS

	for ( int attempt = 0; attempt < SPL_ENDRING_MAX_ATTEMPTS; attempt++ )
	{
		vector candidate = GetRandomCenterDistributed( center, 0.0, radius )
		// Nudge up then clamp so TraceVertical / ground checks see a mesh point.
		vector onMesh = NavMesh_GetClosestPoint( candidate + < 0.0, 0.0, 128.0 > )

		if ( IsPositionGoodForAnEndRing( onMesh ) )
		{
			printt( "[SPL] end-ring candidate ok attempt=", attempt, "pos=", onMesh )
			return onMesh
		}
	}

	printt( "[SPL] no end-ring candidate after", SPL_ENDRING_MAX_ATTEMPTS, "attempts" )
	return ZERO_VECTOR
}

bool function IsPositionGoodForAnEndRing( vector position )
{
	return IsPositionGoodForAnEndRing_Internal( position, false )
}

bool function IsPositionGoodForAnEndRing_Internal( vector position, bool debug )
{
	if ( NavMesh_TraceVerticalLine_PolyCount( position ) > 1 )
		return false

	vector testPos = position + < 0.0, 0.0, 12.0 >
	vector traceEnd = position + < 0.0, 0.0, -100.0 >
	TraceResults traceResult = TraceLine( testPos, traceEnd, [], TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_NONE )

	// Position is mid-air? Not good for an end ring
	if ( traceResult.fraction >= 0.99 )
	{
		return false
	}
	else if ( IsValid( traceResult.hitEnt ) )
	{
		// If we hit player, that's fine (bot / local used for SPL gen)
		if ( traceResult.hitEnt.IsPlayer() == false )
		{
			// Dynamic entity instead of the world, not a good end ring
			if ( traceResult.hitEnt.IsWorld() == false )
				return false
		}
	}

	foreach ( vector wildlifePosition in file.wildlifeSpawns )
	{
		if ( DistanceSqr( position, wildlifePosition ) < WILDLIFE_MINIMUM_DISTANCE_SQUARED )
			return false
	}

	if ( NavMesh_HasHarmfulAreaWithinDistance( position, HARMFUL_AREA_MINIMUM_DISTANCE ) )
		return false

	foreach ( vector geyserPosition in file.geysers )
	{
		if ( DistanceSqr( position, geyserPosition ) < GEYSER_MINIMUM_DISTANCE_SQUARED )
			return false
	}

	int totalPoints = 0
	int validPoints = 0

	for ( int i = 4; i < 256; )
	{
		array< vector > points = GetPointsOnCircle( position, ZERO_VECTOR, i * 10.0, i )

		if ( debug )
			DebugDrawCircleRGB( position + < 0.0, 0.0, 100.0 >, ZERO_VECTOR, i * 10.0, int( COLOR_YELLOW.x ), int( COLOR_YELLOW.y ), int( COLOR_YELLOW.z ), false, 100.0, 24 )

		foreach ( vector point in points )
		{
			totalPoints++

			int polyHitCount = NavMesh_TraceVerticalLine_PolyCount( point )

			// Multi-level surface (building) near center rings
			if ( i <= 16 && polyHitCount > 1 )
			{
				if ( debug )
					DebugDrawCube( point + < 0.0, 0.0, 100.0 >, 16, int( COLOR_PURPLE.x ), int( COLOR_PURPLE.y ), int( COLOR_PURPLE.z ), true, 100.0 )

				return false
			}

			if ( polyHitCount > 0 )
			{
				validPoints++

				if ( debug )
					DebugDrawCube( point + < 0.0, 0.0, 100.0 >, 16, int( COLOR_GREEN.x ), int( COLOR_GREEN.y ), int( COLOR_GREEN.z ), true, 100.0 )
			}
			else
			{
				if ( debug )
					DebugDrawCube( point + < 0.0, 0.0, 100.0 >, 16, int( COLOR_RED.x ), int( COLOR_RED.y ), int( COLOR_RED.z ), true, 100.0 )
			}
		}

		if ( i < 32 )
			i *= 2
		else
			i += 16
	}

	if ( totalPoints <= 0 )
		return false

	float validPointsRatio = float( validPoints ) / float( totalPoints )

	if ( debug )
		printt( "Valid Points Ratio: ", validPointsRatio )

	return validPointsRatio > 0.8
}

#endif // SERVER
