// CafeMod: Caustic Mitosis -- every armed trap throws child canisters (recursive).
// Behavior in mp_weapon_dirty_bomb.nut; this file owns enable/disable + budget.
// Cap 300 proved stable for recursive throw. Plant via proj.deployFunc (not WaitSignal Planted).

global function CafeMod_Mitosis_Init

const int MITOSIS_MAX_CANISTERS = 300
const int MITOSIS_DEFAULT_CANISTERS = 6

void function CafeMod_Mitosis_Init()
{
	bool playlistDefault = GetCurrentPlaylistVarBool( "cafemod_mitosis", false )

	CafeMod_Register( "mitosis", Mitosis_OnEnable, Mitosis_OnDisable, playlistDefault )
}

void function Mitosis_OnEnable()
{
	DIRTY_BOMB_MAX_GAS_CANISTERS = MITOSIS_MAX_CANISTERS
	printt( format( "[CafeMod] mitosis ON max_canisters=%d (recursive throw + sticky deployFunc)", DIRTY_BOMB_MAX_GAS_CANISTERS ) )
}

void function Mitosis_OnDisable()
{
	DIRTY_BOMB_MAX_GAS_CANISTERS = MITOSIS_DEFAULT_CANISTERS
	printt( format( "[CafeMod] mitosis OFF max_canisters=%d (live traps stop after current wait)", DIRTY_BOMB_MAX_GAS_CANISTERS ) )
}
