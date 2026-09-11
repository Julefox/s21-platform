global function UpgradedClusterMissile_Init

global const string VALK_UPGRADE_TAC_INCREASE_MISSILES_1 = "upgrade_core_valk_tac_increase_missiles_1"
global const string VALK_UPGRADE_TAC_INCREASE_MISSILES_2 = "upgrade_core_valk_tac_increase_missiles_2"


void function UpgradedClusterMissile_Init()
{
	AddCallback_OnPassiveChanged( ePassives.PAS_EXTRA_SWARM_MISSILE, ExtraSwarmMissile_OnPassiveChanged )
}

void function ExtraSwarmMissile_OnPassiveChanged( entity player, int passive, bool didHave, bool nowHas )
{
	#if SERVER
		entity offhandWeapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )
		if ( nowHas )
		{
			float ammoPercentage = float( offhandWeapon.GetWeaponPrimaryClipCount() ) / float( offhandWeapon.GetWeaponPrimaryClipCountMax() )
			if( player.HasPassive( ePassives.PAS_TAC_COOLDOWN_REDUCTION ) )
			{
				array mods = player.GetExtraWeaponMods()
				mods.append( VALK_UPGRADE_TAC_INCREASE_MISSILES_2 )
				mods.fastremovebyvalue( TAC_COOLDOWN_REDUCTION_MOD )
				player.SetExtraWeaponMods( mods )
			}
			else
			{
				GiveExtraWeaponMod( player, VALK_UPGRADE_TAC_INCREASE_MISSILES_1 )
			}
			int maxAmmo = offhandWeapon.GetWeaponPrimaryClipCountMax()
			offhandWeapon.SetWeaponPrimaryClipCount( int( ceil( maxAmmo * ammoPercentage ) ) )

			Remote_CallFunction_NonReplay( player, "ServerCallback_UpdateOffhandRuis" )
		}

		if ( player.GetActiveWeapon( eActiveInventorySlot.mainHand ) == offhandWeapon )
			SwapToLastEquippedPrimary( player )
	#endif

}
