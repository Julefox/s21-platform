global function Desertlands_PreMapInit_Common
global function Desertlands_MapInit_Common
global function CodeCallback_PlayerEnterUpdraftTrigger
global function CodeCallback_PlayerLeaveUpdraftTrigger

#if SERVER
global function Desertlands_MU1_MapInit_Common
global function Desertlands_MU1_EntitiesLoaded_Common
global function Desertlands_MU1_UpdraftInit_Common
global function Desertlands_SetTrainEnabled
global function GeyserInit
#endif


#if SERVER
//Copied from _jump_pads. This is being hacked for the geysers.
const float JUMP_PAD_PUSH_RADIUS = 256.0
const float JUMP_PAD_PUSH_PROJECTILE_RADIUS = 32.0//98.0
const float JUMP_PAD_PUSH_VELOCITY = 2000.0
const float JUMP_PAD_VIEW_PUNCH_SOFT = 25.0
const float JUMP_PAD_VIEW_PUNCH_HARD = 4.0
const float JUMP_PAD_VIEW_PUNCH_RAND = 4.0
const float JUMP_PAD_VIEW_PUNCH_SOFT_TITAN = 120.0
const float JUMP_PAD_VIEW_PUNCH_HARD_TITAN = 20.0
const float JUMP_PAD_VIEW_PUNCH_RAND_TITAN = 20.0
const TEAM_JUMPJET_DBL = $"P_team_jump_jet_ON_trails"
const ENEMY_JUMPJET_DBL = $"P_enemy_jump_jet_ON_trails"
const asset JUMP_PAD_MODEL = $"mdl/props/octane_jump_pad/octane_jump_pad.rmdl"

const float JUMP_PAD_ANGLE_LIMIT = 0.70
const float JUMP_PAD_ICON_HEIGHT_OFFSET = 48.0
const float JUMP_PAD_ACTIVATION_TIME = 0.5
const asset JUMP_PAD_LAUNCH_FX = $"P_grndpnd_launch"
const JUMP_PAD_DESTRUCTION = "jump_pad_destruction"

// Loot drones
const int NUM_LOOT_DRONES_WITH_VAULT_KEYS = 4
#endif

#if CLIENT
const JUMP_PAD_LAUNCH_SOUND_1P = "Geyser_LaunchPlayer_1p"
#endif

struct
{
	#if SERVER
	bool isTrainEnabled = true
	#endif
} file

void function Desertlands_PreMapInit_Common()
{
	DesertlandsTrain_PreMapInit()
}

void function Desertlands_MapInit_Common()
{
	printt( "Desertlands_MapInit_Common" )

	                        
		if ( GameMode_IsActive( eGameModes.CONTROL ) )
		{
			#if SERVER || CLIENT
				// ToDo: DSwieczko: Find a Level Ed solution for this
				Control_SetHomeBaseBadPlacesForMRBForAlliance( ALLIANCE_A, [ <4377.86572, -26819.9141, -3711.96875>, <2097.12085, -26366.8496, -3703.5625>, <518.120239, -24563.4102, -3639.96875>, <-318.68219, -21906.8262, -3898.45557> ] )
				Control_SetHomeBaseBadPlacesForMRBForAlliance( ALLIANCE_B, [ <8058.47754, -14368.2168, -3717.50073>, <11589.5918, -14460.458, -3718.93726>, <13570.1641, -16230.3955, -3717.59326>, <13909.2988, -18391.2441, -3723.20239>, <9866.09863, -12401.3018, -3658.69238>, <5657.99072, -13631.9248, -3711.9375> ] )
			#endif // SERVER || CLIENT
		}
       

	#if SERVER
		AddCallback_EntitiesDidLoad( EntitiesDidLoad )

		SURVIVAL_SetPlaneHeight( 15250 )
		SURVIVAL_SetAirburstHeight( 2500 )
		SURVIVAL_SetMapCenter( <0, 0, 0> )
		Survival_SetMapFloorZ( -8000 )

		if ( file.isTrainEnabled )
			DesertlandsTrain_Precaches()

		AddSpawnCallback_ScriptName( "desertlands_train_mover_0", AddTrainToMinimap )

		thread KillPlayersUnderMap_Thread( MAP_KILL_VOLUME_OFFSET_DESERTLANDS ) //-22290

                       
                                                                                      
                             
	#endif

	#if CLIENT
		Freefall_SetPlaneHeight( 15250 )
		Freefall_SetDisplaySeaHeightForLevel( -8961.0 )
		SetMinimapBackgroundTileImage( $"overviews/mp_rr_desertlands_lava_bg" )

		AddCreateCallback( "trigger_cylinder_heavy", Geyser_OnJumpPadCreated )
		RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.TRAIN, MINIMAP_OBJECT_RUI, MinimapPackage_Train, FULLMAP_OBJECT_RUI, FullmapPackage_Train )

                       
                                                              
                             
	#endif
}

#if SERVER
void function EntitiesDidLoad()
{
	if ( file.isTrainEnabled )
		thread DesertlandsTrain_Init()
}
#endif

#if SERVER
void function Desertlands_SetTrainEnabled( bool enabled )
{
	file.isTrainEnabled = enabled
}
#endif

//=================================================================================================
//=================================================================================================
//
//  ##     ## ##     ##    ##       ######   #######  ##     ## ##     ##  #######  ##    ##
//  ###   ### ##     ##  ####      ##    ## ##     ## ###   ### ###   ### ##     ## ###   ##
//  #### #### ##     ##    ##      ##       ##     ## #### #### #### #### ##     ## ####  ##
//  ## ### ## ##     ##    ##      ##       ##     ## ## ### ## ## ### ## ##     ## ## ## ##
//  ##     ## ##     ##    ##      ##       ##     ## ##     ## ##     ## ##     ## ##  ####
//  ##     ## ##     ##    ##      ##    ## ##     ## ##     ## ##     ## ##     ## ##   ###
//  ##     ##  #######   ######     ######   #######  ##     ## ##     ##  #######  ##    ##
//
//=================================================================================================
//=================================================================================================

#if SERVER
void function Desertlands_MU1_MapInit_Common()
{
	AddSpawnCallback_ScriptName( "conveyor_rotator_mover", OnSpawnConveyorRotatorMover )

	Desertlands_MapInit_Common()
	PrecacheParticleSystem( JUMP_PAD_LAUNCH_FX )
	LaserMesh_Init()
	FlagSet( "DisableDropships" )

	AddDamageCallbackSourceID( eDamageSourceId.burn, OnBurnDamage )
}


void function OnBurnDamage( entity player, var damageInfo )
{
	if ( !player.IsPlayer() )
		return

	// sky laser shouldn't hurt players in plane
	if ( player.GetPlayerNetBool( "playerInPlane" ) )
	{
		DamageInfo_SetDamage( damageInfo, 0 )
	}
}

///////////////////////
///////////////////////
//// Conveyor


void function OnSpawnConveyorRotatorMover( entity mover )
{
	thread ConveyorRotatorMoverThink( mover )
}


void function ConveyorRotatorMoverThink( entity mover )
{
	mover.EndSignal( "OnDestroy" )

	entity rotator = GetEntByScriptName( "conveyor_rotator" )
	entity startNode
	entity endNode

	array<entity> links = rotator.GetLinkEntArray()
	foreach ( l in links )
	{
		if ( l.GetValueForKey( "script_noteworthy" ) == "end" )
			endNode = l
		if ( l.GetValueForKey( "script_noteworthy" ) == "start" )
			startNode = l
	}


	float angle1 = VectorToAngles( startNode.GetOrigin() - rotator.GetOrigin() ).y
	float angle2 = VectorToAngles( endNode.GetOrigin() - rotator.GetOrigin() ).y

	float angleDiff = angle1 - angle2
	angleDiff = (angleDiff + 180) % 360 - 180

	float rotatorSpeed = float( rotator.GetValueForKey( "rotate_forever_speed" ) )
	float waitTime     = fabs( angleDiff ) / rotatorSpeed

	Assert( IsValid( endNode ) )

	while ( true )
	{
		mover.WaitSignal( "ReachedPathEnd" )

		mover.SetParent( rotator, "", true )

		wait waitTime

		mover.ClearParent()
		mover.SetOrigin( endNode.GetOrigin() )
		mover.SetAngles( endNode.GetAngles() )

		thread MoverThink( mover, [ endNode ] )
	}
}


void function Desertlands_MU1_UpdraftInit_Common( entity player )
{
	ApplyUpdraftModUntilTouchingGround( player )

		Control_PrintSkydiveDebug( player, " Desertlands_MU1_UpdraftInit_Common going to trigger PlayerSkydiveFromCurrentPosition" )

	thread PlayerSkydiveFromCurrentPosition( player )
	thread BurnPlayerOverTime( player )
}


void function Desertlands_MU1_EntitiesLoaded_Common()
{
	GeyserInit()

	string currentPlaylist = GetCurrentPlaylistName()

	int keyCount = GetPlaylistVarInt( currentPlaylist, "loot_drones_vault_key_count", NUM_LOOT_DRONES_WITH_VAULT_KEYS )
	if ( keyCount > 0 )
		LootRollers_ForceAddLootRefToRandomLootRollers( "data_knife", keyCount )
}


//Geyster stuff
void function GeyserInit()
{
	array<entity> geyserTargets = GetEntArrayByScriptName( "geyser_jump" )
	foreach ( target in geyserTargets )
	{
		thread GeyersJumpTriggerArea( target )
		//target.Destroy()
	}
}


void function GeyersJumpTriggerArea( entity jumpPad )
{
	Assert ( IsNewThread(), "Must be threaded off" )
	jumpPad.EndSignal( "OnDestroy" )

	vector origin = OriginToGround( jumpPad.GetOrigin() )
	vector angles = jumpPad.GetAngles()

	entity trigger = CreateEntity( "trigger_cylinder_heavy" )
	SetTargetName( trigger, "geyser_trigger" )
	trigger.SetOwner( jumpPad )
	trigger.SetCylinderRadius( JUMP_PAD_PUSH_RADIUS )
	trigger.SetAboveHeight( 32 )
	trigger.SetBelowHeight( 16 ) //need this because the player or jump pad can sink into the ground a tiny bit and we check player feet not half height
	trigger.SetOrigin( origin )
	trigger.SetAngles( angles )
	trigger.SetTriggerType( TT_JUMP_PAD )
	trigger.SetLaunchScaleValues( JUMP_PAD_PUSH_VELOCITY, 1.25 )
	trigger.SetViewPunchValues( JUMP_PAD_VIEW_PUNCH_SOFT, JUMP_PAD_VIEW_PUNCH_HARD, JUMP_PAD_VIEW_PUNCH_RAND )
	trigger.SetLaunchDir( <0.0, 0.0, 1.0> )
	trigger.UsePointCollision()
	trigger.kv.triggerFilterNonCharacter = "0"
	DispatchSpawn( trigger )
	trigger.SetEnterCallback( Geyser_OnJumpPadAreaEnter )

	entity traceBlocker = CreateTraceBlockerVolume( trigger.GetOrigin(), 24.0, true, CONTENTS_BLOCK_PING | CONTENTS_NOGRAPPLE, TEAM_MILITIA, GEYSER_PING_SCRIPT_NAME )
	traceBlocker.SetBox( <-192, -192, -16>, <192, 192, 3000> )

	//DebugDrawCylinder( origin, < -90, 0, 0 >, JUMP_PAD_PUSH_RADIUS, trigger.GetAboveHeight(), COLOR_MAGENTA, true, 9999.9 )
	//DebugDrawCylinder( origin, < -90, 0, 0 >, JUMP_PAD_PUSH_RADIUS, -trigger.GetBelowHeight(), COLOR_MAGENTA, true, 9999.9 )

	OnThreadEnd(
		function() : ( trigger )
		{
			trigger.Destroy()
		} )

	WaitForever()
}


void function Geyser_OnJumpPadAreaEnter( entity trigger, entity ent )
{
	Geyser_JumpPadPushEnt( trigger, ent, trigger.GetOrigin(), trigger.GetAngles() )
}


void function Geyser_JumpPadPushEnt( entity trigger, entity ent, vector origin, vector angles )
{
	if ( Geyser_JumpPad_ShouldPushPlayerOrNPC( ent ) )
	{
		if ( ent.IsPlayer() )
		{
			entity jumpPad = trigger.GetOwner()
			if ( IsValid( jumpPad ) )
			{
				int fxId = GetParticleSystemIndex( JUMP_PAD_LAUNCH_FX )
				StartParticleEffectOnEntity( jumpPad, fxId, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
			}

			RemoveDoubleJump ( ent )

			thread Geyser_JumpJetsWhileAirborne( ent )
		}
		else
		{
			EmitSoundOnEntity( ent, "JumpPad_LaunchPlayer_3p" )
			EmitSoundOnEntity( ent, "JumpPad_AirborneMvmt_3p" )
		}
	}
}


void function Geyser_JumpJetsWhileAirborne( entity player )
{
	if ( !IsPilot( player ) )
		return

	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.Signal( "JumpPadStart" )
	player.EndSignal( "JumpPadStart" )
	player.EnableSlowMo()
	player.DisableMantle()

	EmitSoundOnEntityExceptToPlayer( player, player, "JumpPad_LaunchPlayer_3p" )
	EmitSoundOnEntityExceptToPlayer( player, player, "JumpPad_AirborneMvmt_3p" )

	array<entity> jumpJetFXs
	array<string> attachments = [ "vent_left", "vent_right" ]
	int team                  = player.GetTeam()
	foreach ( attachment in attachments )
	{
		int friendlyID    = GetParticleSystemIndex( TEAM_JUMPJET_DBL )
		entity friendlyFX = StartParticleEffectOnEntity_ReturnEntity( player, friendlyID, FX_PATTACH_POINT_FOLLOW, player.LookupAttachment( attachment ) )
		friendlyFX.SetOwner( player )
		SetTeam( friendlyFX, team )
		friendlyFX.kv.VisibilityFlags = ENTITY_VISIBLE_TO_FRIENDLY
		jumpJetFXs.append( friendlyFX )

		int enemyID    = GetParticleSystemIndex( ENEMY_JUMPJET_DBL )
		entity enemyFX = StartParticleEffectOnEntity_ReturnEntity( player, enemyID, FX_PATTACH_POINT_FOLLOW, player.LookupAttachment( attachment ) )
		SetTeam( enemyFX, team )
		enemyFX.kv.VisibilityFlags = ENTITY_VISIBLE_TO_ENEMY
		jumpJetFXs.append( enemyFX )
	}

	OnThreadEnd(
		function() : ( jumpJetFXs, player )
		{
			foreach ( fx in jumpJetFXs )
			{
				if ( IsValid( fx ) )
					fx.Destroy()
			}

			if ( IsValid( player ) )
			{
				player.DisableSlowMo()
				player.EnableMantle()
				StopSoundOnEntity( player, "JumpPad_AirborneMvmt_3p" )
			}
		}
	)

	WaitFrame()

	wait 0.1

	while( !player.IsOnGround() )
	{
		WaitFrame()
	}
}


bool function Geyser_JumpPad_ShouldPushPlayerOrNPC( entity target )
{
	if ( target.IsTitan() )
		return false
                         
                                
              
      

	if ( IsTurret( target ) )
		return false

	if ( IsDropship( target ) )
		return false

	return true
}


///////////////////////
///////////////////////
//// Updrafts

void function BurnPlayerOverTime( entity player )
{
	Assert( IsValid( player ) )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "DeathTotem_PreRecallPlayer" )
	for ( int i = 0; i < 8; ++i )
	{
		if ( !player.Player_IsInsideUpdraftTrigger() )
			break

		if ( !player.IsPhaseShifted() )
		{
			player.TakeDamage( 5, null, null, { damageSourceId = eDamageSourceId.burn, damageType = DMG_BURN } )
		}

		wait 0.5
	}
}
#endif

void function CodeCallback_PlayerEnterUpdraftTrigger( entity trigger, entity player )
{
	float entZ = player.GetOrigin().z
	OnEnterUpdraftTrigger( trigger, player, max( -5750.0, entZ - 400.0 ) )
	#if SERVER
		PIN_Interact ( player, "desertlands_updraft_enter" )
	#endif
}


void function CodeCallback_PlayerLeaveUpdraftTrigger( entity trigger, entity player )
{
	OnLeaveUpdraftTrigger( trigger, player )
}

#if SERVER
void function AddTrainToMinimap( entity mover )
{
	entity minimapObj = CreatePropScript( $"mdl/dev/empty_model.rmdl", mover.GetOrigin() )
	minimapObj.Minimap_SetCustomState( eMinimapObject_prop_script.TRAIN )
	minimapObj.SetParent( mover )
	SetTargetName( minimapObj, "trainIcon" )
	foreach ( player in GetPlayerArray() )
	{
		minimapObj.Minimap_AlwaysShow( 0, player )
	}
}
#endif

#if CLIENT
void function MinimapPackage_Train( entity ent, var rui )
{
	if ( MINIMAP_DEBUG )
		printt( "Adding 'rui/hud/gametype_icons/sur_train_minimap' icon to minimap" )

	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/sur_train_minimap" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}

void function FullmapPackage_Train( entity ent, var rui )
{
	MinimapPackage_Train( ent, rui )
	RuiSetFloat2( rui, "iconScale", <1.5,1.5,0.0> )
	RuiSetFloat3( rui, "iconColor", <0.5,0.5,0.5> )
}

void function Geyser_OnJumpPadCreated( entity trigger )
{
	if ( trigger.GetTriggerType() != TT_JUMP_PAD )
		return

	if ( trigger.GetTargetName() != "geyser_trigger" )
		return

	trigger.SetClientEnterCallback( Geyser_OnJumpPadAreaEnter )
}

void function Geyser_OnJumpPadAreaEnter( entity trigger, entity player )
{
	entity localViewPlayer = GetLocalViewPlayer()
	if ( player != localViewPlayer )
		return

	if ( !IsPilot( player ) )
		return

	if ( trigger.GetTargetName() != "geyser_trigger" )
		return

	EmitSoundOnEntity( player, JUMP_PAD_LAUNCH_SOUND_1P )
	EmitSoundOnEntity( player, "JumpPad_Ascent_Windrush" )
}
#endif