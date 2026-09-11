global function MpAbilityMirageUltimate_Init
global function OnWeaponChargeBegin_ability_mirage_ultimate
global function OnWeaponChargeEnd_ability_mirage_ultimate
global function OnWeaponAttemptOffhandSwitch_ability_mirage_ultimate

                     
// Tuning values for Team Kaleidoscope
const int CLOAK_TRIGGER_RADIUS = 240
                           
const int MIRAGE_ULT_MAX_DECOYS = 5

global function GetMirageCloakDuration
struct
{
	#if CLIENT
	var cancelHintRui
	#endif
} file

void function MpAbilityMirageUltimate_Init()
{
	RegisterSignal( "CancelCloak" )
	#if CLIENT
	StatusEffect_RegisterEnabledCallback( eStatusEffect.mirage_ultimate_cancel_hint, CancelHint_OnCreate )
	StatusEffect_RegisterDisabledCallback( eStatusEffect.mirage_ultimate_cancel_hint, CancelHint_OnDestroy )
	#endif
}

#if CLIENT
void function CancelHint_OnCreate( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	file.cancelHintRui = CreateFullscreenRui( $"ui/mirage_ultimate_cancel_hint.rpak" )
}

void function CancelHint_OnDestroy( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	RuiDestroyIfAlive( file.cancelHintRui )
	file.cancelHintRui = null
}
#endif // CLIENT

bool function OnWeaponAttemptOffhandSwitch_ability_mirage_ultimate( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return false

	if ( !PlayerCanUseDecoy( player ) )
		return false

	return true
}

var function OnWeaponPrimaryAttack_mirage_ultimate( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	var ammoToReturn = OnWeaponPrimaryAttack_holopilot( weapon, attackParams )
	#if SERVER
		float fireDuration = weapon.GetWeaponSettingFloat( eWeaponVar.fire_duration )
		thread HolsterAndDisableWeaponsMirageUltimate( weapon.GetWeaponOwner(), fireDuration )
	#endif
	return ammoToReturn
}

void function MirageUltimateCancelCloak( entity player )
{
	player.Signal( "CancelCloak")
}

void function OnWeaponChargeEnd_ability_mirage_ultimate( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return

	if ( weapon.GetWeaponChargeFraction() < 1 )
	{
		MirageUltimateCancelCloak( player )
		return
	}

	if ( weapon.GetWeaponPrimaryClipCount() == 0 )                                                                                                          
		return

	weapon.SetWeaponPrimaryClipCount( 0 )
	WeaponPrimaryAttackParams attackParams
	OnWeaponPrimaryAttack_mirage_ultimate( weapon, attackParams )
}

#if SERVER
void function HolsterAndDisableWeaponsMirageUltimate( entity ownerPlayer, float fireDuration )
{
	ownerPlayer.EndSignal( "OnDestroy" )
	ownerPlayer.EndSignal( "OnDeath" )
	ownerPlayer.EndSignal( "OnSyncedMelee" )
	ownerPlayer.EndSignal( "BleedOut_OnStartDying" )
	ownerPlayer.EndSignal( "CancelCloak")

	HolsterAndDisableWeapons( ownerPlayer )
	LockWeaponsAndMelee( ownerPlayer, "mirage_ultimate" )

	StatusEffect_AddTimed( ownerPlayer, eStatusEffect.mirage_ultimate_cancel_hint, 1.0, fireDuration, fireDuration )
	AddButtonPressedPlayerInputCallback( ownerPlayer, IN_WEAPON_CYCLE, MirageUltimateCancelCloak )
	AddButtonPressedPlayerInputCallback( ownerPlayer, IN_OFFHAND4, MirageUltimateCancelCloak )

	OnThreadEnd(
		function() : ( ownerPlayer )
		{
			if ( IsValid( ownerPlayer ) )
			{
				RemoveButtonPressedPlayerInputCallback( ownerPlayer, IN_WEAPON_CYCLE, MirageUltimateCancelCloak )
				RemoveButtonPressedPlayerInputCallback( ownerPlayer, IN_OFFHAND4, MirageUltimateCancelCloak )
				StatusEffect_StopAllOfType( ownerPlayer, eStatusEffect.mirage_ultimate_cancel_hint )

				DeployAndEnableWeaponsWithSlowDeploy( ownerPlayer, 0.5 )
				UnlockWeaponsAndMelee( ownerPlayer, "mirage_ultimate" )
			}
		}
	)

	wait fireDuration
}

void function MirageUltCloakThink( entity ownerPlayer, float fireDuration, float flickerDuration )
{
	ownerPlayer.EndSignal( "OnDestroy" )
	ownerPlayer.EndSignal( "OnDeath" )
	ownerPlayer.EndSignal( "OnSyncedMelee" )
	ownerPlayer.EndSignal( "BleedOut_OnStartDying" )
	ownerPlayer.EndSignal( "CancelCloak" )

	float cloakDuration = GetMirageCloakDuration( ownerPlayer, fireDuration )
	EnableCloak( ownerPlayer, cloakDuration, 0.2 )
	ownerPlayer.SetCloakFlicker( 0.5, flickerDuration )

	int statusId = StatusEffect_AddTimed( ownerPlayer, eStatusEffect.speed_boost, 0.15, fireDuration, 0.5 )
	OnThreadEnd(
		function() : ( ownerPlayer, statusId )
		{
			if ( IsValid( ownerPlayer ) )
			{
				if ( ownerPlayer.IsCloaked( true ) )
					DisableCloak( ownerPlayer, 0.5 )
				StatusEffect_Stop( ownerPlayer, statusId )
			}
		}
	)

	wait cloakDuration
}
#endif

float function GetMirageCloakDuration( entity player, float duration )
{
	                    
		if( PlayerHasPassive( player, ePassives.PAS_MIRAGE ) && PlayerHasPassive( player, ePassives.PAS_ULT_UPGRADE_ONE ) )
		{
			duration += GetMirageUpgradedCloakDuration()
		}
       
	return duration
}

                    
float function GetMirageUpgradedCloakDuration()
{
	return GetCurrentPlaylistVarFloat( "upgrade_mirage_extra_cloak_duration", 1.0 )
}
   
bool function OnWeaponChargeBegin_ability_mirage_ultimate( entity weapon )
{
	weapon.EmitWeaponSound_1p3p( "Mirage_Vanish_Activate_1P", "Mirage_Vanish_Activate_3P" )
	entity ownerPlayer = weapon.GetWeaponOwner()

	if( !IsValid( ownerPlayer ) || !ownerPlayer.IsPlayer() )
		return false

	PlayerUsedOffhand( ownerPlayer, weapon, true )
	#if SERVER
	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( ownerPlayer ), Loadout_Character() )
	string charRef = ItemFlavor_GetHumanReadableRef( character )

	if( charRef == "character_mirage")	
		PlayBattleChatterLineToSpeakerAndTeam( ownerPlayer, "bc_super" )

	thread MirageUltCloakThink( ownerPlayer, 1.1, 0.2 )
	#endif
	return true
}

int function MirageUltimate_GetMaxKaleidoscopeDecoys( entity player )
{
	int maxDecoys = MIRAGE_ULT_MAX_DECOYS

		if( player.HasPassive( ePassives.PAS_ULT_UPGRADE_TWO ) )
		{
			maxDecoys += 1
		}

	return maxDecoys
}

bool function ShouldDoKaleidoscopeUltimate()
{
	return GetCurrentPlaylistVarBool( "mirage_kaleidoscope_ulti_enabled", true )
}
