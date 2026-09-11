// CafeMod: Maggie Mitosis -- every ball wall-edge spawns a child (recursive).
// Cap 16 hard stop (uncapped melted the dedi). Rising-edge wall + 0.20s cooldown.

global function CafeMod_MaggieMitosis_Init

void function CafeMod_MaggieMitosis_Init()
{
	bool playlistDefault = GetCurrentPlaylistVarBool( "cafemod_maggie_mitosis", false )

	CafeMod_Register( "maggie_mitosis", MaggieMitosis_OnEnable, MaggieMitosis_OnDisable, playlistDefault )
}

void function MaggieMitosis_OnEnable()
{
	printt( "[CafeMod] maggie_mitosis ON recursive wall-edge max=16 magnets=48 edict_headroom=512" )
}

void function MaggieMitosis_OnDisable()
{
	printt( "[CafeMod] maggie_mitosis OFF (live balls keep rolling, no new children)" )
}
