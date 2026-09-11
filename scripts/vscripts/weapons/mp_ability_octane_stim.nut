global function OnWeaponActivate_ability_octane_stim
global function OnWeaponChargeBegin_ability_octane_stim
global function OnWeaponChargeEnd_ability_octane_stim
global function OnWeaponAttemptOffhandSwitch_ability_octane_stim

const float 	STIM_DURATION = 6.0
const int 	STIM_HEALTH_COST = 20
const int 	STIM_HEALTH_COST_UPGRADE = 5


int function GetOctaneHealthCost( entity weapon )
{
	int result = GetCurrentPlaylistVarInt( "octane_health_cost", STIM_HEALTH_COST )
	if( !IsValid( weapon ) )
		return result
	if( !IsValid( weapon.GetOwner() ) )
		return result
	                    
	if( weapon.GetOwner().HasPassive( ePassives.PAS_TAC_UPGRADE_ONE ) ) // upgrade_octane_stim_health_cost
		result -= STIM_HEALTH_COST_UPGRADE
	if( weapon.GetOwner().HasPassive( ePassives.PAS_TAC_UPGRADE_TWO ) ) // upgrade_octane_stim_health_cost_again
		result -= STIM_HEALTH_COST_UPGRADE
       

	return result
}

float function GetStimDuration( )
{
	float duration = GetCurrentPlaylistVarFloat( "octane_stim_duration", STIM_DURATION )
	return duration
}

void function OnWeaponActivate_ability_octane_stim( entity weapon )
{
              
                                                 
                                       
                         
        
 
           
                      
                 
  
                                                                                                       
   
                                     
             
                                        
                                                                                             
         
   
      
   
                                        
   
  
      
}

bool function OnWeaponChargeBegin_ability_octane_stim( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	float duration     = GetStimDuration()
	StimPlayerWithOffhandWeapon( ownerPlayer, duration, weapon )
	#if SERVER
		if ( GetCurrentPlaylistVarBool( "octane_stim_clear_slows", true ) )
		{
			if ( !Survival_IsPlayerHealing( ownerPlayer ) )
			{
				StatusEffect_StopAllOfType( ownerPlayer, eStatusEffect.move_slow )
				StatusEffect_StopAllOfType( ownerPlayer, eStatusEffect.turn_slow )
			}
		}

		int currentHealth    = ownerPlayer.GetHealth()
		int healthToSubtract = GetOctaneHealthCost( weapon )
		float newHealth      = max( 1, currentHealth - healthToSubtract )
		float damage         = currentHealth - newHealth

		ownerPlayer.SetHealth( newHealth )
		ownerPlayer.UpdateLastTimeDamaged( null )

		// store damage taken to damage histroy so that it shows up in the death recap.
		int scriptDamageType = DF_INSTANT | DF_BYPASS_SHIELD //| DF_NO_HITBEEP | DF_NO_INDICATOR
		StoreDamageHistoryAndUpdate( ownerPlayer, GetCurrentPlaylistVarFloat( "max_damage_history_time", MAX_DAMAGE_HISTORY_TIME  ), damage, ownerPlayer.GetCenter(), scriptDamageType, eDamageSourceId.mp_ability_octane_stim, ownerPlayer )

		thread StatsHook_TrackStimDistance( ownerPlayer )
	#endif
	PlayerUsedOffhand( ownerPlayer, weapon )

	#if SERVER
		if ( Time() > weapon.w.voDebounceTime )
		{
			PlayBattleChatterLineToSpeakerAndTeam( ownerPlayer, "bc_tactical" )
			weapon.w.voDebounceTime = Time() + RandomFloatRange( 20.0, 40.0 )
		}
	#else
		Rumble_Play( "rumble_stim_activate", {} )
	#endif
	return true
}


void function OnWeaponChargeEnd_ability_octane_stim( entity weapon )
{
	#if SERVER
		int ammoAfterFiring = weapon.GetWeaponPrimaryClipCount() - weapon.GetAmmoPerShot()
		weapon.SetWeaponPrimaryClipCount( maxint( ammoAfterFiring, 0 ) )
	#endif
}


bool function OnWeaponAttemptOffhandSwitch_ability_octane_stim( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	if ( IsValid( ownerPlayer ) )
	{
		if ( StatusEffect_HasSeverity( ownerPlayer, eStatusEffect.stim_visual_effect ) )
			return false
	}

	return true
}
