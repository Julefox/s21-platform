global function UpgradedJets_Init

global const string VALK_UPGRADE_PAS_AIR_CONTROL = "valk_jetpack_manuverability"
global const string VALK_UPGRADE_PAS_LONGER_DURATION = "valk_jetpack_increased_duration"

void function UpgradedJets_Init()
{
	AddCallback_OnPassiveChanged( ePassives.PAS_BOOSTED_JETPACK, BoostedJets_OnPassiveChanged )
	AddCallback_OnPassiveChanged( ePassives.PAS_EXTRA_JETPACK_FUEL, JetpackFuel_OnPassiveChanged )
}

void function BoostedJets_OnPassiveChanged( entity player, int passive, bool didHave, bool nowHas )
{
	#if SERVER
		if ( nowHas )
		{
			GivePlayerSettingsMods( player, [VALK_UPGRADE_PAS_AIR_CONTROL] )
		}

		if( didHave )
		{
			if ( HasPlayerSettingMod( player, VALK_UPGRADE_PAS_AIR_CONTROL ) )
				TakePlayerSettingsMods( player, [VALK_UPGRADE_PAS_AIR_CONTROL] )
		}
	#endif
}

void function JetpackFuel_OnPassiveChanged( entity player, int passive, bool didHave, bool nowHas )
{
	#if SERVER
		if ( nowHas )
		{
			GivePlayerSettingsMods( player, [VALK_UPGRADE_PAS_LONGER_DURATION] )
		}

		if( didHave )
		{
			if ( HasPlayerSettingMod( player, VALK_UPGRADE_PAS_LONGER_DURATION ) )
				TakePlayerSettingsMods( player, [VALK_UPGRADE_PAS_LONGER_DURATION] )
		}
	#endif
}
