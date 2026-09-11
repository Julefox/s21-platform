// Map editor extended palette: non-prop recipes and zipline two-point flow.
// Client only ever sends a recipe index -- never a classname, model path, or asset.

global function MapEditor_Palette_ServerInit

const asset MAPEDIT_JUMP_PAD_MODEL = $"mdl/props/octane_jump_pad/octane_jump_pad.rmdl"
const asset MAPEDIT_DOOR_MODEL = $"mdl/door/door_104x64x8_elevatorstyle01_right_animated.rmdl"

// Particle allowlist -- index 0 is default for recipe 5.
const asset MAPEDIT_FX_LAUNCHPAD = $"P_launchpad_launch"
const asset MAPEDIT_FX_LOOTBIN_OPEN = $"P_LootBin_open"
const asset MAPEDIT_FX_JUMPJET = $"P_team_jump_jet_ON_trails"

struct
{
	table< entity, vector > ziplineAnchor
	table< entity, entity > jumpPadTriggers
	table< entity, entity > doorPairs
	table< entity, bool >   lootBins
	table< entity, array< float > > placeTimes
	bool particlesPrecached = false
} file

void function MapEditor_Palette_ServerInit()
{
	if ( !MapEditor_IsEnabled() )
		return

	PrecacheModel( MAPEDIT_JUMP_PAD_MODEL )
	PrecacheModel( MAPEDIT_DOOR_MODEL )
	PrecacheParticleSystem( MAPEDIT_FX_LAUNCHPAD )
	PrecacheParticleSystem( MAPEDIT_FX_LOOTBIN_OPEN )
	PrecacheParticleSystem( MAPEDIT_FX_JUMPJET )
	file.particlesPrecached = true

	AddClientCommandCallback( "mapedit_special", ClientCommand_MapEdit_Special )
	AddClientCommandCallback( "mapedit_zipline_start", ClientCommand_MapEdit_ZiplineStart )
	AddClientCommandCallback( "mapedit_zipline_end", ClientCommand_MapEdit_ZiplineEnd )
	AddClientCommandCallback( "mapedit_zipline_cancel", ClientCommand_MapEdit_ZiplineCancel )

	AddCallback_OnClientDisconnected( MapEditPalette_OnClientDisconnected )

	printt( "[MAPEDIT] palette init (recipes 1-5; light omitted)" )
}

void function MapEditPalette_OnClientDisconnected( entity player )
{
	if ( player in file.ziplineAnchor )
		delete file.ziplineAnchor[player]

	if ( player in file.placeTimes )
		delete file.placeTimes[player]
}

// Drop any palette table entry keyed by or pointing at ent.
// Bound via AddEntityDestroyedCallback so it runs whenever Destroy runs --
// including after MapEdit_RemoveAtIndex in the registry path.
void function MapEditPalette_OnTrackedDestroyed( entity ent )
{
	if ( ent in file.jumpPadTriggers )
		delete file.jumpPadTriggers[ent]

	if ( ent in file.doorPairs )
		delete file.doorPairs[ent]

	if ( ent in file.lootBins )
		delete file.lootBins[ent]

	array< entity > jumpKeys
	foreach ( entity k, entity v in file.jumpPadTriggers )
	{
		if ( v == ent )
			jumpKeys.append( k )
	}
	foreach ( entity k in jumpKeys )
		delete file.jumpPadTriggers[k]

	array< entity > doorKeys
	foreach ( entity k, entity v in file.doorPairs )
	{
		if ( v == ent )
			doorKeys.append( k )
	}
	foreach ( entity k in doorKeys )
		delete file.doorPairs[k]
}

void function MapEditPalette_TrackJumpPad( entity prop, entity trigger )
{
	file.jumpPadTriggers[prop] <- trigger
	AddEntityDestroyedCallback( prop, MapEditPalette_OnTrackedDestroyed )
	AddEntityDestroyedCallback( trigger, MapEditPalette_OnTrackedDestroyed )
}

void function MapEditPalette_TrackDoorPair( entity left, entity rightDoor )
{
	file.doorPairs[left] <- rightDoor
	AddEntityDestroyedCallback( left, MapEditPalette_OnTrackedDestroyed )
	AddEntityDestroyedCallback( rightDoor, MapEditPalette_OnTrackedDestroyed )
}

void function MapEditPalette_TrackLootBin( entity bin )
{
	file.lootBins[bin] <- true
	AddEntityDestroyedCallback( bin, MapEditPalette_OnTrackedDestroyed )
}

// Register or destroy; catalogId 0 for non-catalog recipes.
bool function MapEditPalette_TryRegister( entity ent, entity owner )
{
	if ( !IsValid( ent ) )
		return false

	if ( !MapEditor_RegisterSpawned( ent, 0, owner ) )
	{
		if ( IsValid( ent ) )
			ent.Destroy()
		return false
	}
	return true
}

// ---------------------------------------------------------------------------
// Recipes -- each takes (origin, angles) and returns primary entity or null
// ---------------------------------------------------------------------------

entity function MapEditPalette_Recipe_JumpPad( vector origin, vector angles )
{
	entity prop = CreatePropDynamic( MAPEDIT_JUMP_PAD_MODEL, origin, angles, SOLID_VPHYSICS, -1.0 )
	if ( !IsValid( prop ) )
	{
		printt( "[MAPEDIT] jump pad: CreatePropDynamic failed" )
		return null
	}
	prop.SetScriptName( "mapedit_jumppad" )

	entity trigger = CreateEntity( "trigger_cylinder_heavy" )
	if ( !IsValid( trigger ) )
	{
		printt( "[MAPEDIT] jump pad: CreateEntity trigger_cylinder_heavy failed" )
		prop.Destroy()
		return null
	}

	trigger.SetOwner( prop )
	trigger.SetRadius( MAPEDIT_JUMP_PAD_RADIUS )
	trigger.SetAboveHeight( MAPEDIT_JUMP_PAD_HEIGHT )
	trigger.SetBelowHeight( MAPEDIT_JUMP_PAD_BELOW )
	trigger.SetOrigin( origin )
	trigger.SetAngles( angles )
	trigger.SetTriggerType( TT_JUMP_PAD )
	trigger.SetLaunchScaleValues( MAPEDIT_JUMP_PAD_VELOCITY, MAPEDIT_JUMP_PAD_VERT )
	trigger.SetLaunchDir( <0.0, 0.0, 1.0> )
	trigger.UsePointCollision()
	trigger.kv.triggerFilterNonCharacter = "0"
	DispatchSpawn( trigger )
	trigger.SetParent( prop, "", true, 0.0 )
	trigger.SetScriptName( "mapedit_jumppad_trigger" )

	// Caller registers both; trigger looked up via file.jumpPadTriggers.
	MapEditPalette_TrackJumpPad( prop, trigger )
	return prop
}

entity function MapEditPalette_Recipe_DoorSingle( vector origin, vector angles )
{
	// CreateSurvivalDoorPlain is the tree's spawn path (prop_dynamic + survival_door_plain).
	// CreateEntity("prop_door") has no script call sites.
	// Keeps survival_door_plain script name so door logic still runs.
	entity door = CreateSurvivalDoorPlain( MAPEDIT_DOOR_MODEL, origin, angles )
	if ( !IsValid( door ) )
	{
		printt( "[MAPEDIT] door single: CreateSurvivalDoorPlain failed" )
		return null
	}
	return door
}

entity function MapEditPalette_Recipe_DoorDouble( vector origin, vector angles )
{
	vector right = AnglesToRight( angles )
	float half = MAPEDIT_DOOR_DOUBLE_GAP * 0.5

	entity left = CreateSurvivalDoorPlain( MAPEDIT_DOOR_MODEL, origin - right * half, angles )
	if ( !IsValid( left ) )
	{
		printt( "[MAPEDIT] door double: left CreateSurvivalDoorPlain failed" )
		return null
	}

	vector rightAngles = AnglesCompose( angles, <0, 180, 0> )
	entity rightDoor = CreateSurvivalDoorPlain( MAPEDIT_DOOR_MODEL, origin + right * half, rightAngles )
	if ( !IsValid( rightDoor ) )
	{
		printt( "[MAPEDIT] door double: right CreateSurvivalDoorPlain failed" )
		left.Destroy()
		return null
	}

	MapEditPalette_TrackDoorPair( left, rightDoor )
	return left
}

entity function MapEditPalette_Recipe_LootBin( vector origin, vector angles )
{
	entity bin = CreateLootBin( origin, angles, false, false, false )
	if ( !IsValid( bin ) )
	{
		printt( "[MAPEDIT] loot bin: CreateLootBin failed" )
		return null
	}
	// CreateLootBin sets LOOT_BIN_SCRIPTNAME; track in file.lootBins for cleanup.
	MapEditPalette_TrackLootBin( bin )
	return bin
}

entity function MapEditPalette_Recipe_Particle( vector origin, vector angles )
{
	if ( !file.particlesPrecached )
	{
		printt( "[MAPEDIT] particle: not precached" )
		return null
	}

	int fxIdx = GetParticleSystemIndex( MAPEDIT_FX_LAUNCHPAD )
	entity fx = StartParticleEffectInWorld_ReturnEntity( fxIdx, origin, angles )
	if ( !IsValid( fx ) )
	{
		printt( "[MAPEDIT] particle: StartParticleEffectInWorld_ReturnEntity failed" )
		return null
	}
	fx.SetScriptName( "mapedit_fx" )
	return fx
}

// Recipe 6 (light): no light entity CreateEntity path exists in this tree -- omitted.

// ---------------------------------------------------------------------------
// mapedit_special <recipeId> <x> <y> <z> <pitch> <yaw> <roll>
// ---------------------------------------------------------------------------

void function ClientCommand_MapEdit_Special( entity player, array<string> args )
{
	if ( !MapEditor_IsEnabled() )
		return

	if ( !IsValid( player ) || !player.IsPlayer() )
		return

	if ( MapEditor_IsFrozenFor( player ) )
	{
		MapEdit_Reject( player, "placement frozen by admin" )
		return
	}

	if ( args.len() != 7 )
	{
		MapEdit_Reject( player, "special needs 7 args: <recipeId> <x> <y> <z> <pitch> <yaw> <roll>" )
		return
	}

	if ( !IsStringNumber( args[0] ) || !IsStringNumber( args[1] ) || !IsStringNumber( args[2] ) ||
		 !IsStringNumber( args[3] ) || !IsStringNumber( args[4] ) || !IsStringNumber( args[5] ) ||
		 !IsStringNumber( args[6] ) )
	{
		MapEdit_Reject( player, "special: args not numeric" )
		return
	}

	int recipeId = args[0].tointeger()
	float x = args[1].tofloat()
	float y = args[2].tofloat()
	float z = args[3].tofloat()
	float pitch = args[4].tofloat()
	float yaw = args[5].tofloat()
	float roll = args[6].tofloat()

	if ( !MapEdit_IsFiniteCoord( x ) || !MapEdit_IsFiniteCoord( y ) || !MapEdit_IsFiniteCoord( z ) )
	{
		MapEdit_Reject( player, "special: origin not finite or out of world limit" )
		return
	}

	if ( pitch != pitch || yaw != yaw || roll != roll )
	{
		MapEdit_Reject( player, "special: angles contain NaN" )
		return
	}
	if ( fabs( pitch ) > MAPEDIT_ANGLE_LIMIT || fabs( yaw ) > MAPEDIT_ANGLE_LIMIT || fabs( roll ) > MAPEDIT_ANGLE_LIMIT )
	{
		MapEdit_Reject( player, "special: angles not finite" )
		return
	}

	vector origin = <x, y, z>
	vector eye = player.EyePosition()
	if ( Distance( eye, origin ) > MAPEDIT_MAX_PLACE_DIST )
	{
		MapEdit_Reject( player, format( "special: origin too far from eye (max %.0f)", MAPEDIT_MAX_PLACE_DIST ) )
		return
	}

	pitch = MapEdit_NormalizeAngle360( pitch )
	yaw   = MapEdit_NormalizeAngle360( yaw )
	roll  = MapEdit_NormalizeAngle360( roll )
	vector angles = <pitch, yaw, roll>

	float now = Time()
	if ( !( player in file.placeTimes ) )
		file.placeTimes[player] <- []

	array< float > placeWindow = file.placeTimes[player]
	while ( placeWindow.len() > 0 && ( now - placeWindow[0] ) > MAPEDIT_PLACE_RATE_WINDOW )
		placeWindow.remove( 0 )

	if ( placeWindow.len() >= MAPEDIT_PLACE_RATE_MAX )
	{
		MapEdit_Reject( player, format( "place rate limit %d / %.1fs", MAPEDIT_PLACE_RATE_MAX, MAPEDIT_PLACE_RATE_WINDOW ) )
		return
	}

	entity primary = null
	array< entity > extras

	switch ( recipeId )
	{
		case 1:
			primary = MapEditPalette_Recipe_JumpPad( origin, angles )
			if ( IsValid( primary ) && ( primary in file.jumpPadTriggers ) )
			{
				entity t = file.jumpPadTriggers[primary]
				if ( IsValid( t ) )
					extras.append( t )
			}
			break
		case 2:
			primary = MapEditPalette_Recipe_DoorSingle( origin, angles )
			break
		case 3:
			primary = MapEditPalette_Recipe_DoorDouble( origin, angles )
			if ( IsValid( primary ) && ( primary in file.doorPairs ) )
			{
				entity pair = file.doorPairs[primary]
				if ( IsValid( pair ) )
					extras.append( pair )
			}
			break
		case 4:
			primary = MapEditPalette_Recipe_LootBin( origin, angles )
			break
		case 5:
			primary = MapEditPalette_Recipe_Particle( origin, angles )
			break
		case 6:
			MapEdit_Reject( player, "special: light recipe omitted (no light entity in this tree)" )
			return
		default:
			MapEdit_Reject( player, "special: unknown recipeId " + string( recipeId ) )
			return
	}

	if ( !IsValid( primary ) )
	{
		MapEdit_Reject( player, format( "special: recipe %d failed to spawn", recipeId ) )
		return
	}

	if ( !MapEditPalette_TryRegister( primary, player ) )
	{
		foreach ( entity e in extras )
		{
			if ( IsValid( e ) )
				e.Destroy()
		}
		return
	}

	foreach ( entity e in extras )
	{
		if ( !IsValid( e ) )
			continue
		if ( !MapEditPalette_TryRegister( e, player ) )
		{
			// Partial register; primary already in registry. Leave it; report.
			MapEdit_Reject( player, "special: budget refused for secondary entity" )
			return
		}
	}

	placeWindow.append( Time() )

	MapEdit_Report( player, format( "special recipe=%d at %.0f %.0f %.0f",
		recipeId, origin.x, origin.y, origin.z ) )
	return
}

// ---------------------------------------------------------------------------
// Zipline two-point flow
// ---------------------------------------------------------------------------

void function ClientCommand_MapEdit_ZiplineStart( entity player, array<string> args )
{
	if ( !MapEditor_IsEnabled() )
		return

	if ( !IsValid( player ) || !player.IsPlayer() )
		return

	if ( MapEditor_IsFrozenFor( player ) )
	{
		MapEdit_Reject( player, "zipline frozen by admin" )
		return
	}

	vector eye = player.EyePosition()
	vector forward = player.GetViewVector()
	TraceResults tr = TraceLine( eye, eye + forward * MAPEDIT_MAX_PLACE_DIST, player, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )

	vector anchor = tr.endPos
	file.ziplineAnchor[player] <- anchor

	MapEdit_Report( player, format( "zipline start set %.0f %.0f %.0f", anchor.x, anchor.y, anchor.z ) )
	return
}

void function ClientCommand_MapEdit_ZiplineEnd( entity player, array<string> args )
{
	if ( !MapEditor_IsEnabled() )
		return

	if ( !IsValid( player ) || !player.IsPlayer() )
		return

	if ( MapEditor_IsFrozenFor( player ) )
	{
		MapEdit_Reject( player, "zipline frozen by admin" )
		return
	}

	if ( !( player in file.ziplineAnchor ) )
	{
		MapEdit_Reject( player, "zipline end: no start anchor (mapedit_zipline_start first)" )
		return
	}

	vector start = file.ziplineAnchor[player]

	vector eye = player.EyePosition()
	vector forward = player.GetViewVector()
	TraceResults tr = TraceLine( eye, eye + forward * MAPEDIT_MAX_PLACE_DIST, player, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
	vector end = tr.endPos

	float dist = Distance( start, end )
	if ( dist > MAPEDIT_ZIPLINE_MAX_DIST )
	{
		MapEdit_Reject( player, format( "zipline end: too far (max %.0f)", MAPEDIT_ZIPLINE_MAX_DIST ) )
		return
	}
	if ( dist < 64.0 )
	{
		MapEdit_Reject( player, "zipline end: too close to start" )
		return
	}

	// Build from move_rope + keyframe_rope (CreateZipLine pattern in _utility).
	string midpointName = UniqueString( "mapedit_zip_mid" )
	string endpointName = UniqueString( "mapedit_zip_end" )

	entity rope_start = CreateEntity( "move_rope" )
	if ( !IsValid( rope_start ) )
	{
		printt( "[MAPEDIT] zipline: CreateEntity move_rope failed" )
		return
	}
	rope_start.kv.NextKey = midpointName
	rope_start.kv.MoveSpeed = 0
	rope_start.kv.ZiplineMoveSpeedScale = 1.0
	rope_start.kv.Slack = 0
	rope_start.kv.Subdiv = 0
	rope_start.kv.Width = "2"
	rope_start.kv.TextureScale = "1"
	rope_start.kv.RopeMaterial = "cable/zipline.vmt"
	rope_start.kv.PositionInterpolator = 2
	rope_start.kv.Zipline = "1"
	rope_start.kv.ZiplineAutoDetachDistance = "150"
	rope_start.kv.ZiplineSagEnable = "0"
	rope_start.kv.ZiplineSagHeight = "0"
	rope_start.SetOrigin( start )
	rope_start.SetScriptName( "mapedit_zipline" )

	entity rope_mid = CreateEntity( "keyframe_rope" )
	if ( !IsValid( rope_mid ) )
	{
		printt( "[MAPEDIT] zipline: CreateEntity keyframe_rope mid failed" )
		rope_start.Destroy()
		return
	}
	SetTargetName( rope_mid, midpointName )
	rope_mid.kv.NextKey = endpointName
	rope_mid.SetOrigin( ( start + end ) * 0.5 )
	rope_mid.SetScriptName( "mapedit_zipline" )

	entity rope_end = CreateEntity( "keyframe_rope" )
	if ( !IsValid( rope_end ) )
	{
		printt( "[MAPEDIT] zipline: CreateEntity keyframe_rope end failed" )
		rope_start.Destroy()
		rope_mid.Destroy()
		return
	}
	SetTargetName( rope_end, endpointName )
	rope_end.SetOrigin( end )
	rope_end.SetScriptName( "mapedit_zipline" )

	DispatchSpawn( rope_start )
	DispatchSpawn( rope_mid )
	DispatchSpawn( rope_end )

	// Register start + end against budget; mid is structural -- register all three.
	if ( !MapEditPalette_TryRegister( rope_start, player ) )
	{
		if ( IsValid( rope_mid ) )
			rope_mid.Destroy()
		if ( IsValid( rope_end ) )
			rope_end.Destroy()
		return
	}
	if ( !MapEditPalette_TryRegister( rope_mid, player ) )
	{
		if ( IsValid( rope_end ) )
			rope_end.Destroy()
		return
	}
	if ( !MapEditPalette_TryRegister( rope_end, player ) )
		return

	delete file.ziplineAnchor[player]

	MapEdit_Report( player, format( "zipline placed len=%.0f", dist ) )
	return
}

void function ClientCommand_MapEdit_ZiplineCancel( entity player, array<string> args )
{
	if ( !MapEditor_IsEnabled() )
		return

	if ( !IsValid( player ) || !player.IsPlayer() )
		return

	if ( player in file.ziplineAnchor )
		delete file.ziplineAnchor[player]

	MapEdit_Report( player, "zipline anchor cleared" )
	return
}
