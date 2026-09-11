global function InstagibRailjump_Init
global function OnWeaponAttemptOffhandSwitch_InstagibRailjump
global function OnWeaponPrimaryAttack_InstagibRailjump

void function InstagibRailjump_Init()
{
	if ( !FS_IsInstagib() )
		return

	#if SERVER || CLIENT
		PrecacheWeapon( INSTAGIB_TAC_CLASS )
	#endif

	printt( "[FS-IG] InstagibRailjump_Init" )
}

bool function OnWeaponAttemptOffhandSwitch_InstagibRailjump( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) || !player.IsPlayer() || !IsAlive( player ) )
		return false
	if ( GetGameState() != eGameState.Playing )
		return false
	if ( weapon.GetWeaponPrimaryClipCount() < 1 )
		return false
	return true
}

var function OnWeaponPrimaryAttack_InstagibRailjump( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if CLIENT
		if ( InPrediction() && !IsFirstTimePredicted() )
			return 0
	#endif

	entity player = weapon.GetWeaponOwner()
	if ( !LGUN_DoRailJump( player, weapon ) )
		return 0

	return 1
}
