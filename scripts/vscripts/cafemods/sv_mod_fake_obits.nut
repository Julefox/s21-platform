// CafeMod fake_obits: server registration only.
// Kill-feed spam runs CLIENT-side (cl_mod_fake_obits.nut) from synced bitfield.

global function CafeMod_FakeObits_Init

void function CafeMod_FakeObits_Init()
{
	bool def = GetCurrentPlaylistVarBool( "cafemod_fake_obits", false )

	CafeMod_Register( "fake_obits", FakeObits_OnEnable, FakeObits_OnDisable, def )
}

void function FakeObits_OnEnable()
{
	printt( "[CafeMod] fake_obits ON (clients start kill-feed spam on sync)" )
}

void function FakeObits_OnDisable()
{
	printt( "[CafeMod] fake_obits OFF (clients stop on sync)" )
}
