global function ShInit_Aqueduct
global function CodeCallback_MapInit

void function CodeCallback_MapInit()
{
	#if SERVER
	FS_ArenaWalls_Init()
	#endif
}

void function ShInit_Aqueduct()
{
	CryptoDrone_SetMaxZ( 2240 )
	SetVictorySequencePlatformModel( $"mdl/dev/empty_model.rmdl", < 0, 0, -10 >, < 0, 0, 0 > )
	#if CLIENT
	  SetVictorySequenceLocation(<2382.82422, -4059.49658, -3141.40796>, <0, 201.828598, 0> )
	#endif
}
