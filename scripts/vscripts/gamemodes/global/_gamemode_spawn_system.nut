// SpawnSystem for bridge fs_1v1. Disk CSV: datatable/fs_spawns_<playlist>_<map>_set_N.csv
// S21 squirrel: compound LocPair cannot be assigned as a whole -- set .origin/.angles.

global function SpawnSystem_Init
global function SpawnSystem_InitGamemodeOptions
global function SpawnSystem_ReturnAllSpawnLocations
global function SpawnSystem_SortSpawnsByMetaData
global function AddCallback_SpawnsSettings
global function AddCallback_SpawnsPostInit
global function SpawnSystem_CreateLocPairObject
global function SpawnSystem_SetOffset
global function SpawnSystem_SetCustomPak
global function SpawnSystem_SetCustomPlaylist
global function SpawnSystem_SetPreferredPak
global function SpawnSystem_SetRunCallbacks
global function SpawnSystem_SetPanelLocation
global function SpawnSystem_SetMetaDataHandler
global function SpawnSystem_GetCurrentSpawnSet
global function SpawnSystem_GetCurrentSpawnAsset
global function SpawnSystem_CreateSpawnObject
global function SpawnSystem_CreateSpawnObjectArray
global function SpawnSystem_GenerateRandomSpawns
global function SpawnSystem_FindBaseMapForPak
global function SpawnSystem_UseNavMeshCorrection
global function SpawnSystem_SetValidateSpawnsOnLoad
global function SpawnSystem_CheckSpawn
global function SpawnSystem_GetPakInfoForKey

global function NewLocPair

global LocPair g_waitingRoomPanelLocation

const vector SPAWN_CHECK_HULL_MINS = <-16, -16, 0>
const vector SPAWN_CHECK_HULL_MAXS = <16, 16, 72>
const float SPAWN_CHECK_GROUND_DROP = 96.0
const int GENERATE_SPAWN_ATTEMPTS_PER_SPOT = 20

global struct LocPairData
{
	array<LocPair> spawns
	LocPair ornull waitingRoom = null
	LocPair ornull panels = null
	bool bOverrideSpawns = false
	array<table> metaData
}

global struct SpawnData
{
	LocPair spawn
	string info
	int id = -1
}

struct
{
	bool inited = false
	bool gamemodeOptionsInited = false
	bool useNavMeshCorrection = false
	bool validateOnLoad = false
	bool runCallbacks = true
	int preferredPak = 0
	string customPlaylist = ""
	string customPak = ""
	string currentSpawnSet = "trivial"
	asset currentSpawnAsset = $""
	table<string, string> pakInfo
	vector mapOffsetOrigin = <0, 0, 0>
	vector mapOffsetAngles = <0, 0, 0>
	array<void functionref()> settingsCallbacks
	array<LocPairData functionref()> postInitCallbacks
	void functionref( SpawnData ) metaHandler = null
	bool useDiskSpawns = true
} file

LocPair function NewLocPair( vector origin, vector angles )
{
	LocPair p
	p.origin = origin
	p.angles = angles
	return p
}

void function LocPair_SetFields( LocPair dest, vector origin, vector angles )
{
	dest.origin = origin
	dest.angles = angles
}

void function SpawnSystem_Init()
{
	if ( file.inited )
		return

	file.inited = true
	file.mapOffsetOrigin = <0, 0, 0>
	file.mapOffsetAngles = <0, 0, 0>
	LocPair_SetFields( g_waitingRoomPanelLocation, <0, 0, 0>, <0, 0, 0> )
	file.pakInfo[ "teamCount" ] <- "2"
	file.pakInfo[ "playlist" ] <- "fs_1v1"
	file.pakInfo[ "map" ] <- ""
	file.pakInfo[ "spawnsCount" ] <- "0"
	file.pakInfo[ "devAutoSave" ] <- "0"
	printt( "[SpawnSystem] init" )
}

void function SpawnSystem_InitGamemodeOptions()
{
	SpawnSystem_Init()

	// Default ON: disk CSV under platform/datatable/. Set 0 to force TRIVIAL grid.
	file.useDiskSpawns = GetCurrentPlaylistVarBool( "fs_spawns_use_rpak", true )
	file.customPlaylist = GetCurrentPlaylistVarString( "custom_playlist_spawnpak", "" )
	file.preferredPak = GetCurrentPlaylistVarInt( "spawnpaks_preferred_pak", 0 )
	file.customPak = GetCurrentPlaylistVarString( "custom_spawnpak", "" )

	foreach ( cb in file.settingsCallbacks )
		cb()

	file.gamemodeOptionsInited = true

	string mode = file.useDiskSpawns ? "DISK" : "TRIVIAL"
	printt( "[SpawnSystem] gamemode options ready map=" + GetMapName() + " playlist=" + GetCurrentPlaylistName() + " mode=" + mode )
}

void function AddCallback_SpawnsSettings( void functionref() callbackFunc )
{
	file.settingsCallbacks.append( callbackFunc )
}

void function AddCallback_SpawnsPostInit( LocPairData functionref() callbackFunc )
{
	file.postInitCallbacks.append( callbackFunc )
}

void function SpawnSystem_SetOffset( LocPair offset )
{
	file.mapOffsetOrigin = offset.origin
	file.mapOffsetAngles = offset.angles
}

bool function SpawnSystem_SetCustomPak( string custom_rpak )
{
	file.customPak = custom_rpak
	return true
}

void function SpawnSystem_SetCustomPlaylist( string playlistref )
{
	file.customPlaylist = playlistref
}

void function SpawnSystem_SetPreferredPak( int preference )
{
	file.preferredPak = preference
}

void function SpawnSystem_SetRunCallbacks( bool setting )
{
	file.runCallbacks = setting
}

void function SpawnSystem_SetPanelLocation( vector origin, vector angles )
{
	LocPair_SetFields( g_waitingRoomPanelLocation, origin, angles )
}

void function SpawnSystem_SetMetaDataHandler( void functionref( SpawnData ) processFunc )
{
	file.metaHandler = processFunc
}

string function SpawnSystem_GetCurrentSpawnSet()
{
	return file.currentSpawnSet
}

asset function SpawnSystem_GetCurrentSpawnAsset()
{
	return file.currentSpawnAsset
}

void function SpawnSystem_UseNavMeshCorrection( bool setting )
{
	file.useNavMeshCorrection = setting
}

void function SpawnSystem_SetValidateSpawnsOnLoad( bool setting )
{
	file.validateOnLoad = setting
}

// A generated spot is usable only if a standing player hull fits there AND there is
// floor under it. Without both tests a synthetic ring drops players into walls, props
// and open air on any map whose waiting room was never surveyed.
bool function SpawnSystem_CheckSpawn( vector origin, vector mins = <0, 0, 0>, vector maxs = <0, 0, 0> )
{
	if ( mins == <0, 0, 0> && maxs == <0, 0, 0> )
	{
		mins = SPAWN_CHECK_HULL_MINS
		maxs = SPAWN_CHECK_HULL_MAXS
	}

	array<entity> ignoreNone = []

	TraceResults clear = TraceHull( origin, origin, mins, maxs, ignoreNone, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER )
	if ( clear.startSolid || clear.fraction < 1.0 )
		return false

	TraceResults ground = TraceHull( origin, origin - <0, 0, SPAWN_CHECK_GROUND_DROP>, mins, maxs, ignoreNone, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_PLAYER )
	return !ground.startSolid && ground.fraction < 1.0
}

string function SpawnSystem_GetPakInfoForKey( string key )
{
	if ( key in file.pakInfo )
		return file.pakInfo[key]
	return "_NOTFOUND"
}

string function SpawnSystem_FindBaseMapForPak( string mapName )
{
	return mapName
}

SpawnData function SpawnSystem_CreateSpawnObject( LocPair spawn, string info, int id = -1 )
{
	SpawnData d
	d.spawn.origin = spawn.origin
	d.spawn.angles = spawn.angles
	d.info = info
	d.id = id
	if ( file.metaHandler != null )
		file.metaHandler( d )
	return d
}

array<SpawnData> function SpawnSystem_CreateSpawnObjectArray( array<LocPair> spawns, array<table> ornull propertiesOrNull = null, int coreSpawnsLen = -1 )
{
	array<SpawnData> out
	for ( int i = 0; i < spawns.len(); i++ )
	{
		string info = ""
		if ( propertiesOrNull != null )
		{
			array<table> props = expect array<table>( propertiesOrNull )
			if ( i < props.len() && ( "info" in props[i] ) )
				info = expect string( props[i]["info"] )
		}
		out.append( SpawnSystem_CreateSpawnObject( spawns[i], info, i ) )
	}
	return out
}

LocPairData function SpawnSystem_CreateLocPairObject( array<LocPair> spawns, bool bOverrideSpawns = false, LocPair ornull waitingRoom = null, LocPair ornull panels = null, array<table> ornull propertiesOrNull = null )
{
	LocPairData data
	data.spawns = spawns
	data.bOverrideSpawns = bOverrideSpawns
	data.waitingRoom = waitingRoom
	data.panels = panels
	if ( propertiesOrNull != null )
		data.metaData = expect array<table>( propertiesOrNull )
	return data
}

table<string, array<SpawnData> > function SpawnSystem_SortSpawnsByMetaData( array<SpawnData> spawns )
{
	table<string, array<SpawnData> > out
	foreach ( s in spawns )
	{
		string key = s.info
		if ( !( key in out ) )
			out[key] <- []
		out[key].append( s )
	}
	return out
}

// Even number of LocPairs: consecutive pairs are duel sides (p0 vs p1, p2 vs p3, ...).
array<LocPair> function SpawnSystem_BuildTrivialArenaPairs()
{
	array<LocPair> spawns
	vector base = <0, 0, 128> + file.mapOffsetOrigin

	// 8 arenas, 16 spawns (pairs face each other ~800 units apart)
	for ( int i = 0; i < 8; i++ )
	{
		float ox = float( ( i % 4 ) * 2000 )
		float oy = float( ( i / 4 ) * 2000 )
		vector center = base + <ox, oy, 0>
		spawns.append( NewLocPair( center + <-400, 0, 0>, <0, 0, 0> ) )
		spawns.append( NewLocPair( center + <400, 0, 0>, <0, 180, 0> ) )
	}

	return spawns
}

string function SpawnSystem_BuildAssetPath( string map, int setIndex )
{
	if ( file.customPak != "" )
	{
		string custom = file.customPak
		if ( custom.find( "datatable/" ) == 0 )
		{
			if ( custom.find( ".rpak" ) < 0 )
				return custom + ".rpak"
			return custom
		}
		if ( custom.find( ".rpak" ) < 0 )
			return "datatable/" + custom + ".rpak"
		return "datatable/" + custom
	}

	string playlist = file.customPlaylist
	if ( playlist == "" )
		playlist = GetCurrentPlaylistName()

	int setN = setIndex
	if ( setN < 1 )
		setN = 1

	// platform/datatable/fs_spawns_<playlist>_<map>_set_N.csv
	// -> datatable/fs_spawns_<playlist>_<map>_set_N.rpak
	return "datatable/fs_spawns_" + playlist + "_" + map + "_set_" + string( setN ) + ".rpak"
}

// Parse one disk/rpak spawn table. Empty array = miss / hard fail.
array<SpawnData> function SpawnSystem_LoadSpawnsFromAssetPath( string assetPath )
{
	array<SpawnData> out

	var dt = null
	try
	{
		asset tableAsset = GetKeyValueAsAsset( { kn = assetPath }, "kn" )
		dt = GetDataTable( tableAsset )
	}
	catch ( eLoad )
	{
		printt( "[SpawnSystem] GetDataTable failed path=" + assetPath + " err=" + eLoad )
		return out
	}

	if ( dt == null )
	{
		printt( "[SpawnSystem] GetDataTable null path=" + assetPath )
		return out
	}

	int colOrigin = GetDataTableColumnByName( dt, "origin" )
	int colAngles = GetDataTableColumnByName( dt, "angles" )
	int colInfo = GetDataTableColumnByName( dt, "info" )
	if ( colOrigin < 0 || colAngles < 0 || colInfo < 0 )
	{
		printt( "[SpawnSystem] missing origin/angles/info columns path=" + assetPath )
		return out
	}

	int rows = GetDataTableRowCount( dt )
	int spawnId = 0

	for ( int r = 0; r < rows; r++ )
	{
		string info = ""
		try
		{
			info = GetDataTableString( dt, r, colInfo )
		}
		catch ( eInfo )
		{
			continue
		}

		// Meta rows: pakData.key:value (origin usually 0)
		if ( info.len() >= 8 && info.find( "pakData." ) == 0 )
		{
			string rest = info.slice( 8 )
			int colon = rest.find( ":" )
			if ( colon > 0 )
			{
				string key = rest.slice( 0, colon )
				string val = rest.slice( colon + 1 )
				file.pakInfo[ key ] <- val
			}
			continue
		}

		vector origin
		vector angles
		try
		{
			origin = GetDataTableVector( dt, r, colOrigin )
			angles = GetDataTableVector( dt, r, colAngles )
		}
		catch ( eVec )
		{
			printt( "[SpawnSystem] vector read fail row=" + string( r ) + " path=" + assetPath )
			continue
		}

		// Skip empty residual rows
		if ( info == "" && origin.x == 0.0 && origin.y == 0.0 && origin.z == 0.0 )
			continue

		LocPair loc = NewLocPair( origin + file.mapOffsetOrigin, angles + file.mapOffsetAngles )
		out.append( SpawnSystem_CreateSpawnObject( loc, info, spawnId ) )
		spawnId++
	}

	printt( "[SpawnSystem] loaded path=" + assetPath + " rows=" + string( rows ) + " spawns=" + string( out.len() ) )
	return out
}

array<SpawnData> function SpawnSystem_TryLoadDiskSpawns( string map )
{
	array<SpawnData> out

	array<int> setOrder = []
	if ( file.preferredPak > 0 )
		setOrder.append( file.preferredPak )
	// Always try set_1 (and set_2) as fallbacks for common packs.
	if ( !setOrder.contains( 1 ) )
		setOrder.append( 1 )
	if ( !setOrder.contains( 2 ) )
		setOrder.append( 2 )

	foreach ( int setN in setOrder )
	{
		string path = SpawnSystem_BuildAssetPath( map, setN )
		out = SpawnSystem_LoadSpawnsFromAssetPath( path )
		if ( out.len() > 0 )
		{
			file.currentSpawnSet = path
			file.currentSpawnAsset = GetKeyValueAsAsset( { kn = path }, "kn" )
			return out
		}
	}

	if ( out.len() == 0 && map == "mp_rr_district" )
	{
		string aliasPath = SpawnSystem_BuildAssetPath( "mp_rr_district_mu1", 1 )
		out = SpawnSystem_LoadSpawnsFromAssetPath( aliasPath )
		if ( out.len() > 0 )
		{
			file.currentSpawnSet = aliasPath
			file.currentSpawnAsset = GetKeyValueAsAsset( { kn = aliasPath }, "kn" )
			printt( "[SpawnSystem] aliased mp_rr_district -> mp_rr_district_mu1 set" )
			return out
		}
	}

	// Bare custom stems without set_N (e.g. fs_spawns_lgduels)
	if ( file.customPak == "" )
	{
		string playlist = file.customPlaylist
		if ( playlist == "" )
			playlist = GetCurrentPlaylistName()
		string alt = "datatable/fs_spawns_" + playlist + ".rpak"
		out = SpawnSystem_LoadSpawnsFromAssetPath( alt )
		if ( out.len() > 0 )
		{
			file.currentSpawnSet = alt
			file.currentSpawnAsset = GetKeyValueAsAsset( { kn = alt }, "kn" )
			return out
		}
	}

	return out
}

array<SpawnData> function SpawnSystem_ReturnAllSpawnLocations( string mapName = "", table<string, bool> options = {} )
{
	SpawnSystem_Init()
	if ( !file.gamemodeOptionsInited )
		SpawnSystem_InitGamemodeOptions()

	string map = mapName
	if ( map == "" )
		map = GetMapName()

	file.pakInfo[ "map" ] <- map

	array<SpawnData> out

	if ( file.useDiskSpawns )
	{
		out = SpawnSystem_TryLoadDiskSpawns( map )
		if ( out.len() == 0 )
			printt( "[SpawnSystem] disk load empty map=" + map + " -- falling back to TRIVIAL" )
	}

	if ( out.len() == 0 )
	{
		file.currentSpawnSet = "trivial:" + map
		file.currentSpawnAsset = $""
		array<LocPair> raw = SpawnSystem_BuildTrivialArenaPairs()
		out = SpawnSystem_CreateSpawnObjectArray( raw )
		printt( "[SpawnSystem] ReturnAllSpawnLocations TRIVIAL count=" + string( out.len() ) + " map=" + map )
	}
	else
	{
		printt( "[SpawnSystem] ReturnAllSpawnLocations DISK count=" + string( out.len() ) + " set=" + file.currentSpawnSet )
	}

	// Post-init callbacks may override / append
	if ( file.runCallbacks )
	{
		array<LocPair> rawFromDisk = []
		foreach ( s in out )
			rawFromDisk.append( s.spawn )

		array<LocPair> raw = rawFromDisk
		bool rebuilt = false

		foreach ( cb in file.postInitCallbacks )
		{
			LocPairData data = cb()
			if ( data.bOverrideSpawns && data.spawns.len() > 0 )
			{
				raw.clear()
				foreach ( s in data.spawns )
					raw.append( s )
				rebuilt = true
			}
			else if ( data.spawns.len() > 0 )
			{
				foreach ( s in data.spawns )
					raw.append( s )
				rebuilt = true
			}

			if ( data.panels != null )
			{
				LocPair panels = expect LocPair( data.panels )
				LocPair_SetFields( g_waitingRoomPanelLocation, panels.origin, panels.angles )
			}
		}

		if ( rebuilt )
			out = SpawnSystem_CreateSpawnObjectArray( raw )
	}

	file.pakInfo[ "spawnsCount" ] <- string( out.len() )
	return out
}

array<LocPair> function SpawnSystem_GenerateRandomSpawns( vector origin, vector angles, float radius, float radiusScalar = 1.0, int amount = 10 )
{
	array<LocPair> out
	float r = radius * radiusScalar
	if ( r < 64.0 )
		r = 256.0
	if ( amount < 1 )
		amount = 8

	// Rejection-sample the disc rather than stamping a fixed-radius ring: a ring puts
	// every point on one circle at the centre's own z, which walks straight into walls,
	// props and open air. sqrt() on the radius keeps the scatter area-uniform.
	int maxAttempts = amount * GENERATE_SPAWN_ATTEMPTS_PER_SPOT
	int attempts = 0

	while ( out.len() < amount && attempts < maxAttempts )
	{
		attempts++

		float ang = RandomFloatRange( -180.0, 180.0 )
		float dist = sqrt( RandomFloat( 1.0 ) ) * r
		vector pos = origin + ( AnglesToForward( <0, ang, 0> ) * dist ) + <0, 0, 8>

		if ( !SpawnSystem_CheckSpawn( pos ) )
			continue

		// Face center: ang+180 can exceed 360 -- keep yaw in [-180, 180] for SetAngles.
		float yaw = ang + 180.0
		if ( yaw > 180.0 )
			yaw -= 360.0
		if ( yaw <= -180.0 )
			yaw += 360.0

		out.append( NewLocPair( pos, <0, yaw, 0> ) )
	}

	if ( out.len() < amount )
		printt( "[SPAWNSYS] generated " + string( out.len() ) + " of " + string( amount ) + " spots in " + string( attempts ) + " attempts, radius " + string( r ) + " at " + string( origin ) )

	return out
}
