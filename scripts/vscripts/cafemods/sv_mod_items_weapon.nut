// CafeMod: per-weapon stamps. DevMenu profile+physics, then Give Weapon stamps that gun only.

global function CafeMod_ItemsWeapon_Init
global function CafeItems_OnWeaponGiven
global function CafeItems_Server_GetProfileIndex
global function CafeItems_Server_GetPhysics

const asset ITEM_MDL_NESSIE       = $"mdl/props/nessie/nessie_april_fools.rmdl"
const asset ITEM_MDL_MAGGIE_MINE  = $"mdl/props/madmaggie_ultimate_mine/madmaggie_ultimate_mine.rmdl"
const asset ITEM_MDL_MAGGIE_BALL  = $"mdl/props/madmaggie_ultimate_ball_static/madmaggie_ultimate_ball_static.rmdl"
const asset ITEM_MDL_ROCK         = $"mdl/rocks/rock_desert_04.rmdl"
const asset ITEM_MDL_SMOKE_CAN    = $"mdl/weapons/grenades/w_bangalore_canister_gas_projectile.rmdl"
const asset ITEM_MDL_WRECK_PIECE  = $"mdl/props/madmaggie_ultimate_mine/madmaggie_ultimate_mine.rmdl"

const string ITEMS_TOY_SCRIPTNAME = "cafemod_items_toy"
const string ITEMS_DEFAULT_WEAPON = "mp_weapon_rspn101"

const float ITEMS_SPEED_DEFAULT = 2000.0
const float ITEMS_SPEED_HITSCAN_SCALE = 0.1
const float ITEMS_SPEED_HITSCAN_THRESHOLD = 5000.0
const float ITEMS_SPEED_MIN = 400.0
const float ITEMS_SPEED_MAX = 4500.0
const float ITEMS_SPEED_JITTER_FRAC = 0.12
const float ITEMS_ANGULAR_MAX = 720.0
const float ITEMS_MUZZLE_FORWARD = 20.0
const float ITEMS_MAGGIE_BALL_SCALE = 1.0
const float ITEMS_PROJ_STEP = 0.05
const float ITEMS_PROJ_GRAVITY = 750.0
const float ITEMS_PROJ_MAX_TIME = 8.0
const int CAFEITEMS_MAX_TOYS = 64
const asset ITEM_MDL_JUMPPAD = $"mdl/props/octane_jump_pad/octane_jump_pad.rmdl"
const asset ITEM_MDL_PROJECTILE = $"mdl/props/madmaggie_ultimate_mine/madmaggie_ultimate_mine.rmdl"

struct CafeItemsPending
{
	int profileIndex = 0
	bool physicsOn = true
	bool stampNext = false
}

struct CafeItemsStamp
{
	int profileIndex = 0
	bool physicsOn = true
}

struct
{
	bool attackHooked = false
	bool cmdBound = false
	// Pending config while building a stamped give (per player).
	table<entity, CafeItemsPending> pending
	// Live stamps on weapon entities.
	table<entity, CafeItemsStamp> stamps
} file

void function CafeMod_ItemsWeapon_Init()
{
	PrecacheModel( ITEM_MDL_NESSIE )
	PrecacheModel( ITEM_MDL_MAGGIE_MINE )
	PrecacheModel( ITEM_MDL_MAGGIE_BALL )
	PrecacheModel( ITEM_MDL_ROCK )
	PrecacheModel( ITEM_MDL_SMOKE_CAN )
	PrecacheModel( ITEM_MDL_WRECK_PIECE )
	PrecacheModel( ITEM_MDL_PROJECTILE )
	PrecacheModel( ITEM_MDL_JUMPPAD )
	PrecacheScriptString( ITEMS_TOY_SCRIPTNAME )

	if ( !file.cmdBound )
	{
		AddClientCommandCallback( "cafeitems", CafeItems_ClientCommand )
		file.cmdBound = true
	}

	// Always arm the attack hook. Fire only when the weapon is stamped.
	CafeMod_Register( "items_weapon", ItemsWeapon_OnEnable, ItemsWeapon_OnDisable, true )
}

int function CafeItems_Server_GetProfileIndex()
{
	return 0
}

bool function CafeItems_Server_GetPhysics()
{
	return true
}

void function ItemsWeapon_OnEnable()
{
	if ( !file.attackHooked )
	{
		AddCallback_OnWeaponAttack( ItemsWeapon_OnWeaponAttack )
		file.attackHooked = true
	}
	printt( "[CafeMod] items_weapon ready (per-weapon stamps; Give applies profile)" )
}

void function ItemsWeapon_OnDisable()
{
	if ( file.attackHooked )
	{
		RemoveCallback_OnWeaponAttack( ItemsWeapon_OnWeaponAttack )
		file.attackHooked = false
	}
	printt( "[CafeMod] items_weapon OFF" )
}

CafeItemsPending function CafeItems_GetOrCreatePending( entity player )
{
	if ( !( player in file.pending ) )
	{
		CafeItemsPending p
		p.profileIndex = 0
		p.physicsOn = true
		p.stampNext = false
		file.pending[player] <- p
	}
	return file.pending[player]
}

void function CafeItems_ClientCommand( entity player, array<string> args )
{
	if ( !IsValid( player ) || !player.IsPlayer() )
		return
	if ( args.len() < 1 )
	{
		printt( "[CafeItems] usage: cafeitems set|physics|stamp_next|sync|list" )
		return
	}

	string action = args[0].tolower()

	// Read-only, so never gated -- a dropped sync strands the DevMenu labels.
	if ( action == "sync" )
	{
		CafeItems_SyncToPlayer( player )
		return
	}

	// A refused action still answers, otherwise the UI's optimistic flip stands forever.
	if ( !GetConVarBool( "sv_cheats" ) )
	{
		printt( format( "[CafeItems] denied (sv_cheats 0) '%s' from %s", action, player.GetPlayerName() ) )
		CafeItems_SyncToPlayer( player )
		return
	}

	CafeItemsPending pend = CafeItems_GetOrCreatePending( player )

	if ( action == "list" )
	{
		printt( format( "[CafeItems] pending profile=%s physics=%s stamp_next=%s",
			CafeItems_GetId( pend.profileIndex ), string( pend.physicsOn ), string( pend.stampNext ) ) )
		printt( format( "[CafeItems] live stamps=%d", file.stamps.len() ) )
		return
	}

	if ( action == "physics" )
	{
		if ( args.len() < 2 )
			pend.physicsOn = !pend.physicsOn
		else
		{
			string v = args[1].tolower()
			pend.physicsOn = ( v == "1" || v == "on" || v == "true" )
		}
		file.pending[player] = pend
		printt( format( "[CafeItems] pending physics=%s by %s", string( pend.physicsOn ), player.GetPlayerName() ) )
		CafeItems_SyncToPlayer( player )
		return
	}

	if ( action == "set" )
	{
		if ( args.len() < 2 )
		{
			printt( "[CafeItems] set needs <id>" )
			return
		}
		int idx = CafeItems_FindIndex( args[1] )
		if ( idx < 0 )
		{
			int asInt = args[1].tointeger()
			if ( asInt >= 0 && asInt < CafeItems_GetCount() )
				idx = asInt
		}
		if ( idx < 0 )
		{
			printt( format( "[CafeItems] unknown profile '%s'", args[1] ) )
			return
		}
		pend.profileIndex = idx
		file.pending[player] = pend
		printt( format( "[CafeItems] pending profile=%s by %s", CafeItems_GetId( idx ), player.GetPlayerName() ) )
		CafeItems_SyncToPlayer( player )
		return
	}

	// Arm next freeroam GiveKit/Freeform to stamp the granted weapon.
	if ( action == "stamp_next" )
	{
		pend.stampNext = true
		file.pending[player] = pend
		printt( format( "[CafeItems] stamp_next ARMED profile=%s physics=%s for %s",
			CafeItems_GetId( pend.profileIndex ), string( pend.physicsOn ), player.GetPlayerName() ) )
		return
	}

	// Convenience: give + stamp without freeroam menu.
	if ( action == "give" )
	{
		string weap = ITEMS_DEFAULT_WEAPON
		string tier = "gold"
		if ( args.len() >= 2 && args[1] != "" )
			weap = args[1]
		if ( args.len() >= 3 && args[2] != "" )
			tier = args[2]

		pend.stampNext = true
		file.pending[player] = pend

		FreeroamWeaponsMenu_ServerInit()
		entity given = FreeroamWeaponsMenu_GiveKit( player, weap, WEAPON_INVENTORY_SLOT_PRIMARY_0, tier )
		if ( !IsValid( given ) )
			FreeroamWeaponsMenu_GiveFreeform( player, weap, WEAPON_INVENTORY_SLOT_PRIMARY_0, [] )
		return
	}

	printt( format( "[CafeItems] unknown action '%s'", action ) )
}

// Called from freeroam GiveKit / GiveFreeform after a successful give.
void function CafeItems_OnWeaponGiven( entity player, entity weapon )
{
	if ( !IsValid( player ) || !IsValid( weapon ) )
		return
	if ( !( player in file.pending ) )
		return

	CafeItemsPending pend = file.pending[player]
	if ( !pend.stampNext )
		return

	CafeItemsStamp stamp
	stamp.profileIndex = pend.profileIndex
	stamp.physicsOn = pend.physicsOn
	file.stamps[weapon] <- stamp

	pend.stampNext = false
	file.pending[player] = pend

	AddEntityDestroyedCallback( weapon, CafeItems_OnStampedWeaponDestroyed )

	printt( format( "[CafeItems] STAMPED weapon=%s profile=%s physics=%s player=%s",
		weapon.GetWeaponClassName(), CafeItems_GetId( stamp.profileIndex ), string( stamp.physicsOn ), player.GetPlayerName() ) )
}

void function CafeItems_OnStampedWeaponDestroyed( entity weapon )
{
	if ( weapon in file.stamps )
		delete file.stamps[weapon]
}

void function CafeItems_SyncToPlayer( entity player )
{
	if ( !IsValid( player ) )
		return
	CafeItemsPending pend = CafeItems_GetOrCreatePending( player )
	Remote_CallFunction_NonReplay( player, "CafeMod_CL_ItemsState", pend.profileIndex, pend.physicsOn ? 1 : 0 )
}

void function ItemsWeapon_OnWeaponAttack( entity player, entity weapon, string weaponName, int ammoUsed, vector attackOrigin, vector attackDir )
{
	if ( !IsValid( player ) || !player.IsPlayer() )
		return
	if ( !IsValid( weapon ) )
		return
	if ( !( weapon in file.stamps ) )
		return
	if ( ammoUsed <= 0 )
		return
	if ( LengthSqr( attackDir ) < 0.0001 )
		return
	if ( IsMeleeWeapon( weapon ) )
		return
	if ( !CafeMod_CanSpawnEntities( 8 ) )
		return
	if ( CafeMod_CountByScriptName( ITEMS_TOY_SCRIPTNAME ) >= CAFEITEMS_MAX_TOYS )
		return

	CafeItemsStamp stamp = file.stamps[weapon]
	int idx = stamp.profileIndex
	bool physicsOn = stamp.physicsOn
	int kind = CafeItems_GetKind( idx )

	vector dir = Normalize( attackDir )
	vector origin = CafeItems_GetSpawnOrigin( weapon, attackOrigin, dir )
	vector angles = VectorToAngles( dir )
	float speed = CafeItems_GetLaunchSpeed( weapon )
	vector vel = dir * speed + player.GetVelocity()

	// Jump pads always fly then arm on impact.
	// Physics OFF: models/loot fly then place on impact.
	// Physics ON: fling solid from barrel (maggie always solid).
	bool needsProjectile = ( kind == CAFE_ITEM_KIND_JUMPPAD ) ||
		( !physicsOn && ( kind == CAFE_ITEM_KIND_MODEL || kind == CAFE_ITEM_KIND_LOOT ) )

	if ( needsProjectile )
	{
		thread CafeItems_FireProjectileThenArm( player, origin, angles, vel, idx, kind )
		return
	}

	if ( kind == CAFE_ITEM_KIND_LOOT )
	{
		CafeItems_SpawnLoot( player, CafeItems_GetLootRef( idx ), origin, angles, vel, true )
		return
	}

	if ( kind == CAFE_ITEM_KIND_MAGGIE )
	{
		CafeItems_SpawnMaggieBall( player, origin, angles, vel )
		return
	}

	CafeItems_SpawnSolidModel( player, CafeItems_GetModelAsset( idx ), origin, angles, vel )
}

// Scripted ballistic projectile: step + TraceLine until hit, then arm final spawn.
// Avoids prop_physics OnFirstCollision (does not fire reliably on custom solid props).
void function CafeItems_FireProjectileThenArm( entity player, vector origin, vector angles, vector vel, int profileIndex, int kind )
{
	if ( !IsLegalWorldOrigin( origin ) )
		return
	if ( !CafeMod_CanSpawnEntities( 8 ) )
		return

	asset visModel = ITEM_MDL_PROJECTILE
	if ( kind == CAFE_ITEM_KIND_JUMPPAD )
		visModel = ITEM_MDL_JUMPPAD
	else if ( kind == CAFE_ITEM_KIND_MODEL )
		visModel = CafeItems_GetModelAsset( profileIndex )
	else if ( kind == CAFE_ITEM_KIND_LOOT )
		visModel = ITEM_MDL_PROJECTILE

	entity visual = CreatePropDynamic( visModel, origin, angles, 0 )
	if ( !IsValid( visual ) )
	{
		// Still plant if visual fails.
		CafeItems_PlantAtImpact( player, origin, angles, profileIndex, kind )
		return
	}

	visual.SetOwner( player )
	visual.SetScriptName( ITEMS_TOY_SCRIPTNAME )
	visual.RemoveFromAllRealms()
	visual.AddToOtherEntitysRealms( player )
	// Not solid so traces pass through the visual itself.
	visual.NotSolid()

	OnThreadEnd(
		function() : ( visual )
		{
			if ( IsValid( visual ) )
				visual.Destroy()
		}
	)

	vector pos = origin
	vector v = vel
	float elapsed = 0.0

	while ( elapsed < ITEMS_PROJ_MAX_TIME )
	{
		if ( !IsValid( visual ) )
			return

		vector next = pos + v * ITEMS_PROJ_STEP
		v = <v.x, v.y, v.z - ITEMS_PROJ_GRAVITY * ITEMS_PROJ_STEP>

		if ( !IsLegalWorldOrigin( next ) )
		{
			if ( IsValid( visual ) )
				visual.Destroy()
			return
		}

		// Ignore shooter + visual so the projectile does not collide with itself.
		TraceResults tr = TraceLine( pos, next, [ player, visual ], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
		if ( tr.fraction < 1.0 )
		{
			vector hitOrg = tr.endPos
			vector hitAng = AnglesOnSurface( tr.surfaceNormal, Normalize( v ) )
			// Nudge off surface so pad doesn't embed.
			hitOrg = hitOrg + tr.surfaceNormal * 2.0

			if ( IsValid( visual ) )
				visual.Destroy()

			CafeItems_PlantAtImpact( player, hitOrg, hitAng, profileIndex, kind )
			return
		}

		pos = next
		visual.SetOrigin( pos )
		if ( LengthSqr( v ) > 1.0 )
			visual.SetAngles( VectorToAngles( Normalize( v ) ) )

		elapsed += ITEMS_PROJ_STEP
		wait ITEMS_PROJ_STEP
	}

	// Timed out -- plant where it is.
	if ( IsValid( visual ) )
	{
		vector fallOrg = visual.GetOrigin()
		vector fallAng = visual.GetAngles()
		visual.Destroy()
		CafeItems_PlantAtImpact( player, fallOrg, fallAng, profileIndex, kind )
	}
}

void function CafeItems_PlantAtImpact( entity player, vector hitOrg, vector hitAng, int profileIndex, int kind )
{
	if ( !IsLegalWorldOrigin( hitOrg ) )
		return

	if ( kind == CAFE_ITEM_KIND_JUMPPAD )
	{
		CafeItems_ArmJumpPadAt( player, hitOrg, hitAng )
		return
	}

	if ( kind == CAFE_ITEM_KIND_LOOT )
	{
		CafeItems_SpawnLoot( player, CafeItems_GetLootRef( profileIndex ), hitOrg, hitAng, <0, 0, 0>, false )
		return
	}

	CafeItems_SpawnStaticModel( player, CafeItems_GetModelAsset( profileIndex ), hitOrg, hitAng )
}

// Fully armed pad: CreateAtLocation(activateImmediately=true) builds launch trigger.
// Deploy anim is optional; WaittillAnimDone can hang so we arm via activate flag.
void function CafeItems_ArmJumpPadAt( entity player, vector origin, vector angles )
{
	if ( !IsValid( player ) )
		return

	// activateImmediately=true -> JumpPad_ActivateLaunchLogic (trigger + idle).
	entity pad = JumpPad_CreateAtLocation( origin, angles, player, true )
	if ( !IsValid( pad ) )
	{
		printt( "[CafeItems] JumpPad_CreateAtLocation failed" )
		return
	}

	pad.SetMaxHealth( 200 )
	pad.SetHealth( 200 )
	pad.SetTakeDamageType( DAMAGE_YES )
	pad.SetCanBeMeleed( true )
	pad.SetScriptName( JUMP_PAD_SCRIPTNAME )
	pad.SetTouchTriggers( true )

	if ( IsValid( player ) )
		FiringRange_AddToRemoveOnCharacterChange( pad, player )

	Highlight_SetOwnedHighlight( pad, "sp_friendly_hero" )
	Highlight_SetFriendlyHighlight( pad, "sp_friendly_hero" )
	EmitSoundOnEntity( pad, "JumpPad_Deploy_Unpack" )

	// Cosmetic deploy anim only -- pad is already armed (trigger live).
	pad.Anim_PlayOnly( "prop_octane_jump_pad_deploy" )
	printt( format( "[CafeItems] jump pad ARMED at <%.0f %.0f %.0f>", origin.x, origin.y, origin.z ) )
}

asset function CafeItems_GetModelAsset( int index )
{
	switch ( index )
	{
		case 0:  return ITEM_MDL_NESSIE
		case 6:  return ITEM_MDL_MAGGIE_MINE
		case 9:  return ITEM_MDL_ROCK
		case 10: return ITEM_MDL_SMOKE_CAN
		case 11: return ITEM_MDL_WRECK_PIECE
	}
	return ITEM_MDL_NESSIE
}

void function CafeItems_SpawnLoot( entity player, string lootRef, vector origin, vector angles, vector vel, bool doThrow )
{
	if ( !CafeMod_CanSpawnEntities( 4 ) )
		return
	if ( lootRef == "" || !SURVIVAL_Loot_IsRefValid( lootRef ) )
	{
		printt( format( "[CafeItems] invalid loot ref '%s'", lootRef ) )
		return
	}

	entity loot = SpawnGenericLoot( lootRef, origin, angles, 1 )
	if ( !IsValid( loot ) )
		return

	loot.RemoveFromAllRealms()
	loot.AddToOtherEntitysRealms( player )

	if ( doThrow )
		FakePhysicsThrow( player, loot, vel, true )
}

void function CafeItems_SpawnStaticModel( entity player, asset model, vector origin, vector angles )
{
	if ( !CafeMod_CanSpawnEntities( 4 ) )
		return
	entity prop = CreatePropDynamic( model, origin, angles, 0 )
	if ( !IsValid( prop ) )
		return
	prop.SetScriptName( ITEMS_TOY_SCRIPTNAME )
	prop.SetOwner( player )
	prop.RemoveFromAllRealms()
	prop.AddToOtherEntitysRealms( player )
}

void function CafeItems_SpawnMaggieBall( entity player, vector origin, vector angles, vector vel )
{
	if ( !CafeMod_CanSpawnEntities( 8 ) )
		return

	entity ball = null
	try
	{
		ball = CreateEntity( "prop_physics" )
	}
	catch ( e )
	{
		printt( "[CafeItems] CreateEntity prop_physics failed" )
		return
	}
	if ( !IsValid( ball ) )
		return
	ball.SetValueForModelKey( ITEM_MDL_MAGGIE_BALL )
	ball.SetOrigin( origin )
	ball.SetAngles( angles )
	ball.SetModelScale( ITEMS_MAGGIE_BALL_SCALE )
	ball.kv.massScale = ITEMS_MAGGIE_BALL_SCALE
	ball.kv.inertiaScale = 1.0
	ball.kv.gravity = 1
	ball.kv.solid = SOLID_VPHYSICS
	ball.kv.spawnflags = 0
	ball.kv.CollisionGroup = TRACE_COLLISION_GROUP_NONE
	ball.kv.CollideWithOwner = false
	ball.SetOwner( player )
	ball.SetScriptName( ITEMS_TOY_SCRIPTNAME )
	ball.SetBlocksRadiusDamage( false )
	ball.SetTakeDamageType( DAMAGE_NO )
	SetTeam( ball, player.GetTeam() )
	ball.RemoveFromAllRealms()
	ball.AddToOtherEntitysRealms( player )
	DispatchSpawn( ball )

	if ( CafeMod_IsEnabled( "big_balls" ) )
	{
		ball.SetModelScale( 5.0 )
		ball.kv.massScale = 5.0
	}

	ball.SetVelocity( vel )
	ball.SetAngularVelocity(
		RandomFloatRange( -ITEMS_ANGULAR_MAX, ITEMS_ANGULAR_MAX ),
		RandomFloatRange( -ITEMS_ANGULAR_MAX, ITEMS_ANGULAR_MAX ),
		RandomFloatRange( -ITEMS_ANGULAR_MAX, ITEMS_ANGULAR_MAX )
	)
}

void function CafeItems_SpawnSolidModel( entity player, asset model, vector origin, vector angles, vector vel )
{
	if ( !CafeMod_CanSpawnEntities( 8 ) )
		return

	entity phys = null
	try
	{
		phys = CreateEntity( "prop_physics" )
	}
	catch ( e )
	{
		printt( "[CafeItems] CreateEntity prop_physics failed" )
		return
	}
	if ( !IsValid( phys ) )
		return
	phys.SetValueForModelKey( model )
	phys.SetOrigin( origin )
	phys.SetAngles( angles )
	phys.kv.spawnflags = 0
	phys.kv.fadedist = -1
	phys.kv.physdamagescale = 0.1
	phys.kv.inertiaScale = 1.0
	phys.kv.gravity = 1
	phys.kv.solid = SOLID_VPHYSICS
	phys.kv.renderamt = 255
	phys.kv.rendercolor = "255 255 255"
	phys.kv.CollideWithOwner = false
	phys.kv.CollisionGroup = TRACE_COLLISION_GROUP_NONE
	phys.SetOwner( player )
	phys.SetScriptName( ITEMS_TOY_SCRIPTNAME )
	phys.SetBlocksRadiusDamage( false )
	phys.SetTakeDamageType( DAMAGE_NO )
	SetTeam( phys, TEAM_NPC_FRIENDLY_TO_PLAYERS )
	phys.RemoveFromAllRealms()
	phys.AddToOtherEntitysRealms( player )
	DispatchSpawn( phys )

	phys.SetVelocity( vel )
	phys.SetAngularVelocity(
		RandomFloatRange( -ITEMS_ANGULAR_MAX, ITEMS_ANGULAR_MAX ),
		RandomFloatRange( -ITEMS_ANGULAR_MAX, ITEMS_ANGULAR_MAX ),
		RandomFloatRange( -ITEMS_ANGULAR_MAX, ITEMS_ANGULAR_MAX )
	)
}

vector function CafeItems_GetSpawnOrigin( entity weapon, vector attackOrigin, vector dir )
{
	vector base = attackOrigin
	if ( IsValid( weapon ) )
	{
		vector attackPos = weapon.GetAttackPosition()
		if ( LengthSqr( attackPos ) > 1.0 )
			base = attackPos
	}
	return base + dir * ITEMS_MUZZLE_FORWARD
}

float function CafeItems_GetLaunchSpeed( entity weapon )
{
	float launch = ITEMS_SPEED_DEFAULT
	if ( IsValid( weapon ) )
	{
		float raw = weapon.GetWeaponSettingFloat( eWeaponVar.projectile_launch_speed )
		if ( raw > 50.0 )
			launch = raw
	}
	if ( launch >= ITEMS_SPEED_HITSCAN_THRESHOLD )
		launch *= ITEMS_SPEED_HITSCAN_SCALE
	if ( launch < ITEMS_SPEED_MIN )
		launch = ITEMS_SPEED_MIN
	else if ( launch > ITEMS_SPEED_MAX )
		launch = ITEMS_SPEED_MAX
	float jitter = launch * ITEMS_SPEED_JITTER_FRAC
	return launch + RandomFloatRange( -jitter, jitter )
}
