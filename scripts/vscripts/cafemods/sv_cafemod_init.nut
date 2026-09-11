// CafeMod SERVER bring-up. Called once from Server_Init() in _sh_init.gnut.
// Keep mutator registration here -- never park it under AI/dummie/gamemode code.

global function CafeMod_SystemsInit

void function CafeMod_SystemsInit()
{
	CafeMod_ServerInit()

	// Mutators (each Register() appends to the slot table in sh_cafemod_defs).
	CafeMod_Mitosis_Init()
	CafeMod_MaggieMitosis_Init()
	CafeMod_BigBalls_Init()
	CafeMod_FallDmg_Init()
	CafeMod_BangaloreGas_Init()
	CafeMod_FakeObits_Init()
	CafeMod_ItemsWeapon_Init()
	CafeMod_PlayerModels_Init()

	printt( format( "[CafeMod] SystemsInit done bits=0x%x", CafeMod_GetBitfield() ) )
}
