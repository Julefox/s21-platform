global function ClientCodeCallback_MapInit

const asset MOON_CORE_VFX = $"P_env_KineticBattery_top_elec"
const asset MOON_CABLE_VFX = $"P_env_KineticBattery_cables_shrt"


void function ClientCodeCallback_MapInit()
{
	ClLaserMesh_Init()

	DividedMoon_MapInit_Common()

	MapZones_RegisterDataTable( $"datatable/map_zones/zones_mp_rr_divided_moon_mu1.rpak" )

	
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_6_ATMOSTATION", 0.63, 0.86, 0.5 )
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_13_BIONOMICS", 0.86, 0.79, 0.5 )
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_4_THE_FOUNDRY", 0.2, 0.86, 0.5 )
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_12_TERRAFORMER", 0.64, 0.68, 0.5 )
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_3_PRODUCTION_YARD", 0.12, 0.58, 0.5 )
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_14_THE_DIVIDE", 0.9, 0.5, 0.5 )
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_15_ETERNAL_GARDENS", 0.81, 0.37, 0.5 )
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_8_THE_CORE", 0.35, 0.3, 0.5 )
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_2_DRY_GULCH", 0.18, 0.36, 0.5 )
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_9_ALPHA_BASE", 0.57, 0.18, 0.5 )
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_1_BREAKER_WHARF", 0.81, 0.15, 0.5 )
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_10_STASIS_ARRAY", 0.6, 0.33, 0.5 )
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_5_CULTIVATION", 0.38, 0.80, 0.5 )

	
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_3B_UNDERPASS", 0.22, 0.63, 0.5 )
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_7B_HAZMAT_TUNNEL", 0.58, 0.58, 0.5 )
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_7_QUARANTINE_ZONE", 0.43, 0.52, 0.5 )
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_1_SPACE_PORT", 0.13, 0.2, 0.5 )
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_4C_SOLAR_PODS", 0.29, 0.82, 0.5 )
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_4A_EXPERIMENTAL_LABS", 0.10, 0.70, 0.5 )
	MapZones_AddMinimapLevelLabel( "#MOON_ZONE_10B_CLIFF_SIDE", 0.52, 0.40, 0.5 )



	PrecacheParticleSystem( MOON_CABLE_VFX )
	PrecacheParticleSystem( MOON_CORE_VFX )

	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
}

void function EntitiesDidLoad()
{
	array< entity > ents =  GetEntArrayByScriptName( "kb_cables_shrt_01_info_node" )
	if ( ents.len() == 1 )
	{
		thread CableFXNodeThread( ents[0], ents[0].GetOrigin(), <-17470.87, 18007.68,  3322.34> )
	}

	ents =  GetEntArrayByScriptName( "kb_cables_shrt_02_info_node" )
	if (  ents.len() == 1 )
	{
		thread CableFXNodeThread( ents[0], < -10158.26, 19460.14, 3703.56 >, <-8121.13, 20013.76, 3045.25> )
	}

	ents =  GetEntArrayByScriptName( "kb_top_elec_info_node" )
	if ( ents.len() == 1 )
	{
		thread TopElecNodeFXThread( ents[0] )
	}

	thread DomeSFXThread()
}

void function DomeSFXThread()
{
	const vector DOME_POS = <-7944, -4632, 2744.75>
	const int DOME_SOUND_RADIUS = 9000
	const int DOME_SOUND_PLAY_RADIUS = DOME_SOUND_RADIUS + 6000
	const int DOME_SOUND_PLAY_RADIUS_SQR = DOME_SOUND_PLAY_RADIUS * DOME_SOUND_PLAY_RADIUS

	var soundHandle = null
	while ( true )
	{
		float distSqr = DOME_SOUND_PLAY_RADIUS_SQR
		entity viewPlayer = GetLocalViewPlayer()
		if ( viewPlayer )
			distSqr = DistanceSqr( viewPlayer.GetOrigin(), DOME_POS )

		bool shouldPlay = distSqr < DOME_SOUND_PLAY_RADIUS_SQR
		bool isPlaying = soundHandle != null && IsSoundStillPlaying( soundHandle )

		if ( shouldPlay && !isPlaying )
			soundHandle = EmitSoundOnSphere( DOME_POS, DOME_SOUND_RADIUS, "DividedMoon_Mu1_GroundZero_Emit_DomePerimeter", true )
		else if ( !shouldPlay && isPlaying )
			StopSound( soundHandle )

		wait 2.0
	}
}

void function TopElecNodeFXThread( entity node)
{
	int effectHandle = -1

	OnThreadEnd(
		function() : ( effectHandle )
		{
			if ( EffectDoesExist( effectHandle ) )
				EffectStop( effectHandle, true, false )
		}
	)

	while ( true )
	{
		EmitSoundOnEntity( node, "DividedMoon_PerpetualCore_Emit_CoreElectricity"  )
		effectHandle = StartParticleEffectOnEntity( node, GetParticleSystemIndex( MOON_CORE_VFX ), FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
		wait RandomFloatRange( 2.1, 12 )

		if ( EffectDoesExist( effectHandle ) )
			EffectStop( effectHandle, true, false )
	}
}

void function CableFXNodeThread( entity node, vector ambientStart, vector ambientStop  )
{
	entity mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", ambientStart, <0, 0, 0> )
	entity ambientGeneric = CreateClientSideAmbientGeneric( mover.GetOrigin(), "DividedMoon_PerpetualCore_Emit_WiresElectricity", 0 )
	ambientGeneric.SetParent( mover )
	ambientGeneric.SetEnabled( false )

	int effectHandle = -1

	OnThreadEnd(
		function() : ( mover, ambientGeneric, effectHandle )
		{
			if ( IsValid (ambientGeneric ) )
			{
				ambientGeneric.ClearParent()
				ambientGeneric.Destroy()
			}

			if ( IsValid (mover ) )
			{
				mover.Destroy()
			}

			if ( EffectDoesExist( effectHandle ) )
				EffectStop( effectHandle, true, false )
		}
	)

	while ( true )
	{
		effectHandle = StartParticleEffectOnEntity( node, GetParticleSystemIndex( MOON_CABLE_VFX ), FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
		mover.NonPhysicsMoveTo( ambientStop, 1.0, 0.0, 0.0 )
		ambientGeneric.SetEnabled( true )

		wait 2.0

		mover.NonPhysicsStop()
		mover.SetOrigin( ambientStart )
		ambientGeneric.SetEnabled( false )

		if ( EffectDoesExist( effectHandle ) )
			EffectStop( effectHandle, true, false )

		wait RandomFloatRange( 0.1, 10 )
	}
}
