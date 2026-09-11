global function CodeCallback_MapInit

void function CodeCallback_MapInit()
{

	//TODO: OPTIMIZATION - REMOVE LEVIATHANS FROM FIRING RANGE SCRIPT //Shawbs
	PrecacheModel( MU1_LEVIATHAN_MODEL )

	CryptoDrone_SetMaxZ( 4500 )

	Canyonlands_MapInit_Common()
	AddSpawnCallback_ScriptName( "leviathan_staging", CreateClientSideLeviathanMarkers )
	ShPrecacheSkydiveLauncherAssets()
	RunMySurvivalPreprocess()

	MapZones_RegisterDataTable( $"datatable/map_zones/zones_mp_rr_canyonlands_staging_mu1.rpak" )

	thread function() : ()
	{
		FlagWait( "EntitiesDidLoad" )

		const float SKYBOX_Z_OFFSET_STAGING_AREA = 32.0
		const vector SKYBOX_ANGLES_STAGING_AREA = <0, 60, 0>

		entity skyboxCamera = GetEnt( "skybox_cam_level" )
		skyboxCamera.SetOrigin( skyboxCamera.GetOrigin() + <0, 0, SKYBOX_Z_OFFSET_STAGING_AREA> )
		skyboxCamera.SetAngles( SKYBOX_ANGLES_STAGING_AREA )
	}()
}


void function CreateClientSideLeviathanMarkers( entity leviathan )
{
	leviathan.EndSignal( "OnDestroy" )

	vector leviathanOrigin = leviathan.GetOrigin()
	vector leviathanAngles = leviathan.GetAngles()

	entity ent = CreatePropDynamic_NoDispatchSpawn( $"mdl/dev/empty_model.rmdl", leviathanOrigin, leviathanAngles )
	SetTargetName( ent, leviathan.GetScriptName() )
	DispatchSpawn( ent )

	leviathan.Destroy()

	ent.EndSignal( "OnDestroy" )

	wait 3.0

	ent.Destroy()
}