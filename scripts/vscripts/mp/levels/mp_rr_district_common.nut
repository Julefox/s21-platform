global function District_MapInit_Common
global function CodeCallback_PreMapInit

void function CodeCallback_PreMapInit()
{
	#if SERVER
		LaserMesh_Init()
	#endif
}

void function District_MapInit_Common()
{
	printf( "%s()", FUNC_NAME() )

	// Do NOT call ShPrecacheSkydiveLauncherAssets() here.
	// Filling FX_SKYDIVE_LAUNCHER_LOOP_DEFAULT makes CreateSkydiveLauncher
	// StartParticleEffect on SERVER for every launcher (~42 on district) and tanks the dedi.
	// Gravity cannon idle is map ClientSide FX (P_gravity_canon_spawnpoint), not this path.
	//ShPrecacheSkydiveLauncherAssets()

#if SERVER
	//RegisterGeoFixAsset( STORMCATCHER_GEOFIX_MODEL )
	thread KillPlayersUnderMap_Thread( MAP_KILL_VOLUME_OFFSET_TROPIC_ISLAND ) //-2048
#endif // SERVER

	#if SERVER
		//CommonStoryEvents_Init()
	#endif
}