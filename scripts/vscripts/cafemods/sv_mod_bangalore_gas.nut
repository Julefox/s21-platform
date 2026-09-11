// CafeMod bangalore_gas: Bangalore smoke fuse detours to CreateGasCloudLarge.
// Gate lives in weapons/mp_weapon_grenade_bangalore.nut (Bangalore_DetonateSmokeGrenade).

global function CafeMod_BangaloreGas_Init

void function CafeMod_BangaloreGas_Init()
{
	bool def = GetCurrentPlaylistVarBool( "cafemod_bangalore_gas", false )

	CafeMod_Register( "bangalore_gas", BangaloreGas_OnEnable, BangaloreGas_OnDisable, def )
}

void function BangaloreGas_OnEnable()
{
	printt( "[CafeMod] bangalore_gas ON (smoke -> CreateGasCloudLarge)" )
}

void function BangaloreGas_OnDisable()
{
	printt( "[CafeMod] bangalore_gas OFF" )
}
