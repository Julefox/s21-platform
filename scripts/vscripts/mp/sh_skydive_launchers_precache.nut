global function ShPrecacheSkydiveLauncherAssets

void function ShPrecacheSkydiveLauncherAssets( asset defaultLoopFX = $"P_launchpad_winter", asset launchFX = $"P_launchpad_winter_engage" )
{
	FX_SKYDIVE_LAUNCHER_LOOP_DEFAULT = defaultLoopFX //$"P_item_loot_LG" //$"P_ar_titan_droppoint"  //P_ar_loot_drop_point
	FX_SKYDIVE_LAUNCHER_LOOP_NO_SNOW = $"P_launchpad_winter_AR"
	if ( defaultLoopFX != $"" )
		PrecacheParticleSystem( FX_SKYDIVE_LAUNCHER_LOOP_DEFAULT )
	PrecacheParticleSystem( FX_SKYDIVE_LAUNCHER_LOOP_NO_SNOW )

	// Gravity Mini / District launcher idle loop (and GRAVITY_CANNON fallback loop)
	FX_SKYDIVE_LAUNCHER_GRAVITY_MINI_IDLE = $"P_gravity_launcher_hld"
	PrecacheParticleSystem( FX_SKYDIVE_LAUNCHER_GRAVITY_MINI_IDLE )

	#if SERVER
		FX_SKYDIVE_LAUNCHER_LAUNCH = launchFX
		MODEL_SKYDIVE_LAUNCHER_DEFAULT = $"mdl/s2s/s2s_hullhatch_tube_lift.rmdl"
		PrecacheModel( MODEL_SKYDIVE_LAUNCHER_DEFAULT )
		if ( launchFX != $"" )
			PrecacheParticleSystem( FX_SKYDIVE_LAUNCHER_LAUNCH )

		MODEL_SKYDIVE_LAUNCHER_GRAVITY_MINI = $"mdl/tropics/gravity_launcher_mini_01.rmdl"
		PrecacheModel( MODEL_SKYDIVE_LAUNCHER_GRAVITY_MINI )

		FX_SKYDIVE_LAUNCHER_GRAVITY_MINI_LAUNCH = $"P_ziprails_launcher_engage"
		PrecacheParticleSystem( FX_SKYDIVE_LAUNCHER_GRAVITY_MINI_LAUNCH )

		FX_SKYDIVE_LAUNCHER_GRAVITY_ZIPRAIL_LAUNCH = $"P_ziprails_launcher_hld"
		PrecacheParticleSystem( FX_SKYDIVE_LAUNCHER_GRAVITY_ZIPRAIL_LAUNCH )
	#endif
}
