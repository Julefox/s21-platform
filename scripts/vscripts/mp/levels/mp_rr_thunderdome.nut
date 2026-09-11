global function CodeCallback_MapInit

#if SERVER
#if DEVELOPER
global function DEV_TriggerThunderdomeEasterEgg
#endif
#endif

// EASTER EGG
const string FLAG_NESSIE_FIREWORKS			= "nessie_fireworks"
const string FLAG_APEX_HOLO					= "TD_holo_apex"
const string FLAG_THUNDERDOME_FIREWORKS		= "firework_script"

const string SOUND_NESSIE_FIREWORKS			= "Thunderdome_Fireworks_SkyBurst_EasterEgg_3p"
const string SOUND_NESSIE_APPEAR			= "Giant_Nessi_LongRoar_3p"
const string SOUND_NESSIE_FIREWORKS_CROWD	= "tdome_crowd_cheer_nessie_easteregg"
const string SOUND_INTRO_FIREWORKS			= "Thunderdome_Fireworks_SkyBurst_3p"

const vector ORIGIN_NESSIE_FIREWORKS	= < -5296, 4776, 5000 >
const vector ORIGIN_NESSIE_APPEAR		= < -5720, 5024, 10248 >
const vector ANGLES_NESSIE				= < 12, -45, 0.0 >
const vector ORIGIN_INTRO_FIREWORKS		= < 563, -648, 4473 >

const int SCALE_NESSIE = 600

const float TIME_NESSIE_MOVE = 15.0

const string SCRIPTNAME_NESSIE_GIANT_SPAWN	= "thunderdome_easter_egg_nessie_spawn"
const string SCRIPTNAME_NESSIE_NODE_DEST	= "thunderdome_easter_egg_nessie_destination"
const string SCRIPTNAME_NESSIE_MODEL		= "TDEasterEggNessieModel"
const string SCRIPTNAME_NESSIE_MOVER		= "TDEasterEggNessieMover"

const asset MODEL_NESSIE = $"mdl/props/nessie/nessie_v21_large_v.rmdl"

struct GiantNessieInfo
{
	vector	spawnLocation
	vector	destLocation

	entity	nessie
}
// EASTER EGG

struct
{
	// EASTER EGG
	array< entity >				giantNessieSpawnNodes
	array< GiantNessieInfo >	giantNessieInfos
	// EASTER EGG
} file

void function CodeCallback_MapInit()
{
	RunMySurvivalPreprocess()
	Thunderdome_MapInit_Common()
	CryptoDrone_SetMaxZ( 3300 )

	//CONTROL INTRO CAMERA
	IntroCameraSettings view
	if( GameMode_IsActive( eGameModes.CONTROL ) )
	{
		//MAP CAMERA NAME
		view.origin = <  -1184.0, 1360.0, 1560.0 >
		view.angles = < -5.0, -60.0, 0.0 >
		view.fov = 100
	}
	SetIntroCameraSettings( view )

	AddCallback_EntitiesDidLoad( EntitiesDidLoad )

	if ( IsThunderdomeEasterEggEnabled() )
	{
		FlagInit( FLAG_NESSIE_FIREWORKS )
		FlagInit( FLAG_APEX_HOLO )
		FlagInit( FLAG_THUNDERDOME_FIREWORKS )

		FlagSet( FLAG_APEX_HOLO )

		PrecacheModel( MODEL_NESSIE )

		AddSpawnCallback_ScriptName( SCRIPTNAME_NESSIE_GIANT_SPAWN, OnNessieSpawnNodeGiantSpawned )

		bool areIntroOutroFireworksEnabled = GetCurrentPlaylistVarBool( "thunderdome_intro_outro_fireworks_enabled", true )
		if ( areIntroOutroFireworksEnabled )
		{
			AddCallback_GameStateEnter( eGameState.Playing, OnTriggerThunderdomeFireworks )
			AddCallback_GameStateEnter( eGameState.WinnerDetermined, OnTriggerThunderdomeFireworks )
		}

		                   
			NessieHunt_AddCallback_OnNessieHuntCompleted( NessieHuntCompleted )
                           
	}
}

void function EntitiesDidLoad()
{
	if ( IsThunderdomeEasterEggEnabled() )
	{
		foreach ( entity spawnNode in file.giantNessieSpawnNodes )
		{
			GiantNessieInfo giantNessieInfo
			giantNessieInfo.spawnLocation = spawnNode.GetOrigin()

			array< entity > linkedEnts = spawnNode.GetLinkEntArray()
			foreach ( entity ent in linkedEnts )
			{
				if ( ent.GetScriptName() == SCRIPTNAME_NESSIE_NODE_DEST )
				{
					giantNessieInfo.destLocation = ent.GetOrigin()
					ent.Destroy()
				}
			}

			file.giantNessieInfos.append( giantNessieInfo )
			spawnNode.Destroy()
		}
	}
}

bool function IsThunderdomeEasterEggEnabled()
{
	return GetCurrentPlaylistVarBool( "thunderdome_easter_egg_enabled", true )
}

void function OnTriggerThunderdomeFireworks()
{
	thread TriggerThunderdomeFireworksThread()
}

void function OnNessieSpawnNodeGiantSpawned( entity node )
{
	if ( !IsValid( node ) )
		return

	file.giantNessieSpawnNodes.append( node )
}

void function NessieHuntCompleted()
{
	thread TriggerEasterEggThread()
}

void function TriggerEasterEggThread()
{
	// We use flags instead of signals because of the way info_particle_system entities work
	// these entities are associated to flags and wait for them to be set/clear to trigger their behavior

	//Turn off Hologram
	FlagClear( FLAG_APEX_HOLO )

	//Play Fireworks
	FlagSet( FLAG_NESSIE_FIREWORKS )
	WaitFrame()
	FlagClear( FLAG_NESSIE_FIREWORKS )

	EmitSoundAtPosition( TEAM_UNASSIGNED, ORIGIN_NESSIE_FIREWORKS, SOUND_NESSIE_FIREWORKS, svGlobal.worldspawn )
	EmitSoundAtPosition( TEAM_UNASSIGNED, ORIGIN_NESSIE_APPEAR, SOUND_NESSIE_APPEAR, svGlobal.worldspawn )
	EmitSoundOnEntity( svGlobal.worldspawn, SOUND_NESSIE_FIREWORKS_CROWD ) // this is a 1p sound, doesn't matter where we play it from.

	                         
		array< int > allTeamsOrAlliances = AllianceProximity_GetAllTeamsOrAlliances()
		foreach ( int teamOrAlliance in allTeamsOrAlliances )
		{
			UpdateTeamOrAllianceCrowdNoiseMeterAndBroadcast( teamOrAlliance, eCrowdNoiseMeterModifiers.NESSIE_FIREWORKS_EE )
		}
                                

	foreach ( GiantNessieInfo giantNessieInfo in file.giantNessieInfos )
	{
		giantNessieInfo.nessie = CreatePropDynamic( MODEL_NESSIE, giantNessieInfo.spawnLocation, ANGLES_NESSIE )
		giantNessieInfo.nessie.SetScriptName( SCRIPTNAME_NESSIE_MODEL )

		giantNessieInfo.nessie.SetModelScale( SCALE_NESSIE )

		giantNessieInfo.nessie.kv.CollisionGroup = TRACE_COLLISION_GROUP_NONE
		giantNessieInfo.nessie.NotSolid()

		entity mover = CreateScriptMover( SCRIPTNAME_NESSIE_MOVER, giantNessieInfo.spawnLocation, < 0.0, 0.0, 0.0 > )
		mover.DisallowZiplines()

		giantNessieInfo.nessie.SetParent( mover )

		mover.NonPhysicsMoveTo( giantNessieInfo.destLocation, TIME_NESSIE_MOVE, 0.0, 0.0 )
	}
}

void function TriggerThunderdomeFireworksThread()
{
	FlagSet( FLAG_THUNDERDOME_FIREWORKS )
	WaitFrame()
	FlagClear( FLAG_THUNDERDOME_FIREWORKS )

	EmitSoundAtPosition( TEAM_UNASSIGNED, ORIGIN_INTRO_FIREWORKS, SOUND_INTRO_FIREWORKS, svGlobal.worldspawn )
}

#if SERVER
#if DEVELOPER
void function DEV_TriggerThunderdomeEasterEgg()
{
	//Turn on the Hologram
	FlagSet( FLAG_APEX_HOLO )

	foreach ( GiantNessieInfo giantNessieInfo in file.giantNessieInfos )
	{
		if ( !IsValid( giantNessieInfo.nessie ) )
			continue

		entity mover = giantNessieInfo.nessie.GetParent()
		if ( IsValid( mover ) )
			mover.NonPhysicsStop()

		mover.Destroy()
		giantNessieInfo.nessie.Destroy()
		giantNessieInfo.nessie = null
	}

	thread TriggerEasterEggThread()
}
#endif // DEVELOPER
#endif
