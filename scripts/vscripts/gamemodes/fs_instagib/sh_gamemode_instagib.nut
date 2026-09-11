// Instagib location table. P0: existing S21 arenas, no AyeZee prop maps.

global function Sh_GamemodeInstagib_Init
#if SERVER || CLIENT
global function FS_Instagib_ApplyMovement
#endif
#if SERVER
global function FS_Instagib_GetSpawnsForMap
global function FS_Instagib_HasSpawns
#endif

// Movement tuning on the class-var block. Both engines apply this table locally -- nothing is sent over the wire.
const array<string> INSTAGIB_MOVEMENT_KEYS = [
	"acceleration",
	"airAcceleration",
	"airSpeed",
	"gravityScale",
	"jumpHeight",
	"doubleJump",
	"wallrun",
	"slideDecel",
	"slideVelocityDecay",
	"landSlowdownDuration",
	"antiMultiJumpHeightFrac",
	"superjumpMinHeight",
	"superjumpMaxHeight"
]

const array<string> INSTAGIB_MOVEMENT_VALUES = [
	"550",
	"1000",
	"150",
	"0.85",
	"120",
	"0",
	"0",
	"50",
	"0.7",
	"0",
	"1.0",
	"60",
	"60"
]

struct
{
	bool inited = false
	bool poiCached = false
	array<LocPair> cachedPoiSpawns
} file

void function Sh_GamemodeInstagib_Init()
{
	if ( file.inited )
		return
	file.inited = true

	#if SERVER || CLIENT
		Clickweapon_Init()
		InstagibRailjump_Init()
		printt( "[FS-IG] Sh_GamemodeInstagib_Init map=" + GetMapName() )
	#endif
}

#if SERVER
bool function FS_Instagib_HasSpawns()
{
	return FS_Instagib_GetSpawnsForMap().len() > 0
}

bool function FS_Instagib_MapPrefersPoiSpawns( string map )
{
	switch ( map )
	{
		case "mp_rr_district":
		case "mp_rr_district_mu1":
			return true
	}
	return false
}

array<LocPair> function FS_Instagib_CollectNativeSpawns()
{
	array<LocPair> spawns
	array<entity> spawnpoints = SpawnPoints_GetPilot()
	foreach ( entity sp in spawnpoints )
	{
		if ( !IsValid( sp ) )
			continue
		LocPair loc
		loc.origin = sp.GetOrigin()
		loc.angles = sp.GetAngles()
		spawns.append( loc )
	}
	return spawns
}

array<LocPair> function FS_Instagib_CollectPoiSpawns()
{
	if ( file.poiCached )
		return file.cachedPoiSpawns

	array<LocPair> spawns
	array<int> zoneIds = MapZones_GetAllZoneIDs()
	foreach ( int zoneId in zoneIds )
	{
		string name = MapZones_GetNameForZone( zoneId )
		if ( name.len() < 1 )
			continue
		entity trigger = MapZones_GetTriggerForZone( zoneId )
		if ( !IsValid( trigger ) )
			continue

		vector origin = trigger.GetCenter()
		vector onMesh = NavMesh_GetClosestPoint( origin )
		if ( onMesh.x != 0.0 || onMesh.y != 0.0 || onMesh.z != 0.0 )
			origin = onMesh

		bool tooClose = false
		foreach ( existing in spawns )
		{
			if ( Distance( existing.origin, origin ) < 800.0 )
			{
				tooClose = true
				break
			}
		}
		if ( tooClose )
			continue

		spawns.append( NewLocPair( origin, <0, RandomFloat( 360.0 ), 0> ) )
		printt( "[FS-IG] POI spawn zone=" + name + " origin=" + string( origin ) )
	}

	if ( spawns.len() > 0 )
	{
		file.cachedPoiSpawns = spawns
		file.poiCached = true
		printt( "[FS-IG] cached " + string( spawns.len() ) + " POI spawns" )
	}
	return spawns
}

array<LocPair> function FS_Instagib_GetHardcodedSpawns( string map )
{
	array<LocPair> spawns
	switch ( map )
	{
		case "mp_rr_arena_composite":
			spawns.append( NewLocPair( <-3592, 1081, 258>, <0, 37, 0> ) )
			spawns.append( NewLocPair( <3592, 1081, 258>, <0, 142, 0> ) )
			spawns.append( NewLocPair( <-1315, 4113, 71>, <0, -43, 0> ) )
			spawns.append( NewLocPair( <1315, 4113, 71>, <0, -136, 0> ) )
			spawns.append( NewLocPair( <-1374, 1, 259>, <0, 35, 0> ) )
			spawns.append( NewLocPair( <1374, 1, 259>, <0, 140, 0> ) )
			spawns.append( NewLocPair( <-12.95, 3344.24, -34>, <0, -92.35, 0> ) )
			spawns.append( NewLocPair( <1705.3, 3284.08, 210>, <0, -142.56, 0> ) )
			spawns.append( NewLocPair( <692.37, 1771.12, -50>, <0, 51.63, 0> ) )
			spawns.append( NewLocPair( <-358.17, 1723.92, -50>, <0, 45.09, 0> ) )
			spawns.append( NewLocPair( <-912.22, 2789.48, 10>, <0, -53.74, 0> ) )
			spawns.append( NewLocPair( <-2388, 2758, 259>, <0, -102.01, 0> ) )
			break

		case "mp_rr_arena_phase_runner":
			spawns.append( NewLocPair( <26118.46, 16751.30, -1279.97>, <0, 89.41, 0> ) )
			spawns.append( NewLocPair( <23497.59, 20112.51, -1151.97>, <0, -45.11, 0> ) )
			spawns.append( NewLocPair( <25032.32, 21795.03, -927.97>, <0, -13.00, 0> ) )
			spawns.append( NewLocPair( <27145.82, 21711.41, -927.97>, <0, -155.03, 0> ) )
			spawns.append( NewLocPair( <30564.78, 17781.61, -895.97>, <0, -154.64, 0> ) )
			spawns.append( NewLocPair( <24197.93, 14329.34, -1027.36>, <0, -5.09, 0> ) )
			spawns.append( NewLocPair( <26418.97, 13381.13, -1023.97>, <0, 41.63, 0> ) )
			spawns.append( NewLocPair( <28780.25, 16014.90, -1033.48>, <0, 171.62, 0> ) )
			spawns.append( NewLocPair( <30562.04, 13306.34, -906.32>, <0, 115.21, 0> ) )
			spawns.append( NewLocPair( <21345.25, 13560.70, -448.97>, <0, 40.85, 0> ) )
			break

		case "mp_rr_aqueduct":
			spawns.append( NewLocPair( <3863.79, -3262.96, 282.03>, <0, -135.07, 0> ) )
			spawns.append( NewLocPair( <4169.18, -5555.22, 410.03>, <0, 146.24, 0> ) )
			spawns.append( NewLocPair( <-620.38, -6611.73, 410.03>, <0, 29.94, 0> ) )
			spawns.append( NewLocPair( <-1859.05, -3355.55, 282.03>, <0, -51.35, 0> ) )
			spawns.append( NewLocPair( <817.22, -3503.38, 482.03>, <0, 44.79, 0> ) )
			break

		case "mp_rr_party_crasher":
			spawns.append( NewLocPair( <1729.17, -3585.65, 601.74>, <0, 103.17, 0> ) )
			spawns.append( NewLocPair( <345.11, -3769.66, 583.29>, <0, 78.53, 0> ) )
			spawns.append( NewLocPair( <-1315.07, -2856.40, 999.13>, <0, 39.90, 0> ) )
			spawns.append( NewLocPair( <-2243.00, -1911.61, 1231.47>, <0, 35.25, 0> ) )
			spawns.append( NewLocPair( <-2805.87, -650.60, 1272.09>, <0, 32.20, 0> ) )
			spawns.append( NewLocPair( <262.27, 2781.46, 710.57>, <0, -139.14, 0> ) )
			spawns.append( NewLocPair( <-3970.97, 2639.46, 583.29>, <0, -35.21, 0> ) )
			spawns.append( NewLocPair( <-2711.53, 4067.46, 601.74>, <0, -46.90, 0> ) )
			spawns.append( NewLocPair( <-934.58, 4998.19, 583.28>, <0, -90.82, 0> ) )
			spawns.append( NewLocPair( <1259.38, 3572.83, 633.24>, <0, -112.70, 0> ) )
			spawns.append( NewLocPair( <2623.15, 2661.18, 940.03>, <0, -99.61, 0> ) )
			spawns.append( NewLocPair( <3843.69, -595.50, 583.00>, <0, 172.50, 0> ) )
			break

		case "mp_rr_arena_habitat":
			spawns.append( NewLocPair( <-1162.25, -1529.05, 2243.07>, <0, -9.71, 0> ) )
			spawns.append( NewLocPair( <-110.08, -1664.34, 2340.24>, <0, 178.90, 0> ) )
			spawns.append( NewLocPair( <5151.25, -3378.79, 1840.04>, <0, 90, 0> ) )
			spawns.append( NewLocPair( <-600, -1600, 2243>, <0, 0, 0> ) )
			spawns.append( NewLocPair( <-800, -1800, 2243>, <0, 45, 0> ) )
			spawns.append( NewLocPair( <-400, -1400, 2243>, <0, -90, 0> ) )
			spawns.append( NewLocPair( <200, -1700, 2340>, <0, 180, 0> ) )
			spawns.append( NewLocPair( <-200, -1500, 2243>, <0, 120, 0> ) )
			break

		case "mp_rr_arena_skygarden":
			spawns.append( NewLocPair( <4284.88, -103.00, 2680.03>, <0, -179.45, 0> ) )
			spawns.append( NewLocPair( <-4282.63, -94.06, 2680.03>, <0, -1.49, 0> ) )
			spawns.append( NewLocPair( <-4016.35, -2984.97, 2723.83>, <0, 97.36, 0> ) )
			spawns.append( NewLocPair( <-3202.32, -3163.42, 2863.03>, <0, 91.06, 0> ) )
			spawns.append( NewLocPair( <11.42, -3441.22, 2836.03>, <0, 92.01, 0> ) )
			spawns.append( NewLocPair( <2008.17, -3265.22, 2863.03>, <0, 114.80, 0> ) )
			spawns.append( NewLocPair( <4112.67, -2757.43, 2717.97>, <0, 108.54, 0> ) )
			spawns.append( NewLocPair( <2756.43, 2774.65, 2664.19>, <0, -106.52, 0> ) )
			spawns.append( NewLocPair( <1610.47, 3414.87, 2786.25>, <0, -85.77, 0> ) )
			spawns.append( NewLocPair( <-1641.52, 3283.95, 2785.32>, <0, -90.70, 0> ) )
			break

		case "mp_rr_district":
		case "mp_rr_district_mu1":
			spawns.append( NewLocPair( <5000, 9000, 2000>, <0, 0, 0> ) )
			spawns.append( NewLocPair( <0, 9000, 2000>, <0, 90, 0> ) )
			spawns.append( NewLocPair( <10000, 9000, 2000>, <0, 180, 0> ) )
			spawns.append( NewLocPair( <5000, 4000, 2000>, <0, -90, 0> ) )
			spawns.append( NewLocPair( <5000, 14000, 2000>, <0, 45, 0> ) )
			break
	}

	return spawns
}

array<LocPair> function FS_Instagib_GetSpawnsForMap()
{
	string map = GetMapName()
	if ( FS_Instagib_MapPrefersPoiSpawns( map ) )
	{
		array<LocPair> poiSpawns = FS_Instagib_CollectPoiSpawns()
		if ( poiSpawns.len() > 0 )
			return poiSpawns

		array<LocPair> tableSpawns = FS_Instagib_GetHardcodedSpawns( map )
		if ( tableSpawns.len() > 0 )
		{
			printt( "[FS-IG] POI empty, using table spawns map=" + map )
			return tableSpawns
		}
		printt( "[FS-IG] POI+table empty map=" + map )
	}

	array<LocPair> nativeSpawns = FS_Instagib_CollectNativeSpawns()
	if ( nativeSpawns.len() > 0 )
		return nativeSpawns

	return FS_Instagib_GetHardcodedSpawns( map )
}
#endif // SERVER

#if SERVER || CLIENT
void function FS_Instagib_ApplyMovement( entity player )
{
	if ( !IsValid( player ) || !player.IsPlayer() )
		return

	if ( !GetCurrentPlaylistVarBool( "instagib_movement", true ) )
		return

	for ( int i = 0; i < INSTAGIB_MOVEMENT_KEYS.len(); i++ )
	{
		#if SERVER
			bool applied = Player_SetClassVar( player, INSTAGIB_MOVEMENT_KEYS[i], INSTAGIB_MOVEMENT_VALUES[i] )
		#elseif CLIENT
			bool applied = SetLocalClassVar( INSTAGIB_MOVEMENT_KEYS[i], INSTAGIB_MOVEMENT_VALUES[i] )
		#endif

		if ( !applied )
			printt( "[FS-IG] movement key refused: " + INSTAGIB_MOVEMENT_KEYS[i] )
	}
}
#endif
