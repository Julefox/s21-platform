global function ShInit_PartyCrasher


void function ShInit_PartyCrasher()
{
	CryptoDrone_SetMaxZ( 2240 )
	#if SERVER
	FS_ArenaWalls_Init()
	#endif
}