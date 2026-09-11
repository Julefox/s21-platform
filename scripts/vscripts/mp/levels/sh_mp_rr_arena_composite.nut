global function ShInit_ArenaComposite
#if SERVER
global function CodeCallback_MapInit

void function CodeCallback_MapInit()
{
	ConveyorInit($"mdl/vehicles_r5/land_med/msc_freight_tortus_mod/veh_land_msc_freight_tortus_mod_cargo_holder_v2_static.rmdl", "", 6, 80)
	FS_ArenaWalls_Init()
}
#endif

void function ShInit_ArenaComposite()
{
	CryptoDrone_SetMaxZ( 2240 )
	SetVictorySequencePlatformModel( $"mdl/dev/empty_model.rmdl", < 0, 0, -10 >, < 0, 0, 0 > )
	#if CLIENT
		SetVictorySequenceLocation(<1374, -4060, 418>, <0, 201.828598, 0> )
	#endif
}
