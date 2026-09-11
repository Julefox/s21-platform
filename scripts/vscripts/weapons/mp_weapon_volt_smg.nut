//global function MpWeaponVoltSmg_Init

global function OnWeaponActivate_weapon_volt_smg
global function OnWeaponDeactivate_weapon_volt_smg

const string ADS_MOD = "in_ads"
const string ADS_THINK_THREAD_ABORT_SIGNAL = "ads_think_abort"
const float ADS_MOD_ZOOM_FRAC_REQUIRED = 0.5

void function OnWeaponActivate_weapon_volt_smg( entity weapon )
{
	                    
		GoldenHorseGreen_OnWeaponActivate( weapon )
       
	EnergyAmmoRegen_Start( weapon )
}

void function OnWeaponDeactivate_weapon_volt_smg( entity weapon )
{
	                    
		GoldenHorseGreen_OnWeaponDeactivate( weapon )
       
}


/*
void function MpWeaponVoltSmg_Init()
{
	RegisterSignal( ADS_THINK_THREAD_ABORT_SIGNAL )
}

void function OnWeaponActivate_weapon_volt_smg( entity weapon )
{
	#if SERVER
		entity player = weapon.GetWeaponOwner()
		if ( !IsValid( player ) )
			return

		thread VoltADSThink( player, weapon )
	#endif
}

void function OnWeaponDeactivate_weapon_volt_smg( entity weapon )
{
	#if SERVER
		weapon.Signal( ADS_THINK_THREAD_ABORT_SIGNAL )
		weapon.RemoveMod( ADS_MOD )
	#endif
}

#if SERVER
void function VoltADSThink( entity player, entity weapon )
{
	AssertIsNewThread()
	player.EndSignal( "OnDeath" )
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( ADS_THINK_THREAD_ABORT_SIGNAL )

	OnThreadEnd(
		function() : ( player, weapon )
		{
			if ( IsValid( weapon ) )
				weapon.RemoveMod( ADS_MOD )
		}
	)

	while ( true )
	{
		if ( !IsValid( weapon ) || !IsValid( player ) )
			return

		if ( weapon.IsWeaponInAds() && player.GetZoomFrac() >= ADS_MOD_ZOOM_FRAC_REQUIRED )
		{
			if ( !weapon.HasMod( ADS_MOD ) )
				weapon.AddMod( ADS_MOD )
		}
		else if ( weapon.HasMod( ADS_MOD ) )
		{
			weapon.RemoveMod( ADS_MOD )
		}

		WaitFrame()
	}
}
#endif //SERVER
*/
