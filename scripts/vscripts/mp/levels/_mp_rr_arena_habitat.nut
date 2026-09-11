global function CodeCallback_MapInit

const asset ARENA_LEVIATHAN_MODEL = $"mdl/creatures/leviathan/leviathan_kingscanyon_preview_animated.rmdl"

void function CodeCallback_MapInit()
{
	#if SERVER
	PrecacheModel( ARENA_LEVIATHAN_MODEL )
	FS_ArenaWalls_Init()
	#endif
}
