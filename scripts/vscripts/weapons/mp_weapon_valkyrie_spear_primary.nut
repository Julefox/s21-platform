global function MpWeaponValkyrieSpearPrimary_Init
global function OnWeaponActivate_weapon_valkyrie_spear_primary
global function OnWeaponDeactivate_weapon_valkyrie_spear_primary
global function OnWeaponCustomActivityStart_weapon_valkyrie_spear_primary
global function OnWeaponCustomActivityEnd_weapon_valkyrie_spear_primary

const asset VALK_AMB_EXHAUST_FP = $"P_valk_spear_thruster_idle"
const asset VALK_AMB_EXHAUST_3P = $"P_valk_spear_thruster_idle_3P"

                         
                                
      

void function MpWeaponValkyrieSpearPrimary_Init()
{
	PrecacheParticleSystem( VALK_AMB_EXHAUST_FP )
	PrecacheParticleSystem( VALK_AMB_EXHAUST_3P )

	#if CLIENT
		AddOnSpectatorTargetChangedCallback( OnSpectatorTargetChanged_Callback )
	#endif

                          
                                  
       

}

#if CLIENT
void function OnSpectatorTargetChanged_Callback( entity player, entity prevTarget, entity newTarget )
{
	if( !IsValid( newTarget ) )
		return

	if( !newTarget.IsPlayer() )
		return

	entity weapon = newTarget.GetActiveWeapon( eActiveInventorySlot.mainHand  )
	if( IsValid( weapon ) && weapon.GetWeaponClassName() == "mp_weapon_valkyrie_spear_primary" )
		OnWeaponActivate_weapon_valkyrie_spear_primary( weapon )
}
#endif

void function OnWeaponActivate_weapon_valkyrie_spear_primary( entity weapon )
{
	// stop existing vfx
	OnWeaponDeactivate_melee_valkyrie_spear( weapon )

	entity player = weapon.GetWeaponOwner()
	string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

	if ( meleeSkinName == "spear" )
	{
		weapon.StopWeaponEffect( VALK_AMB_EXHAUST_FP, VALK_AMB_EXHAUST_3P )

		// thruster exhaust
		weapon.PlayWeaponEffect( VALK_AMB_EXHAUST_FP, VALK_AMB_EXHAUST_3P, "fx_l_thruster_top", true )
		weapon.PlayWeaponEffect( VALK_AMB_EXHAUST_FP, VALK_AMB_EXHAUST_3P, "fx_l_thruster_bot", true )
		weapon.PlayWeaponEffect( VALK_AMB_EXHAUST_FP, VALK_AMB_EXHAUST_3P, "fx_r_thruster_top", true )
		weapon.PlayWeaponEffect( VALK_AMB_EXHAUST_FP, VALK_AMB_EXHAUST_3P, "fx_r_thruster_bot", true )
	}
                         
                                          
  
                              
  
      

	#if SERVER
		if ( weapon.HasMod( "using_jets" ) )
			weapon.RemoveMod( "using_jets" )
	#endif
}

void function OnWeaponDeactivate_weapon_valkyrie_spear_primary( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

	if ( meleeSkinName == "spear" )
	{
		weapon.StopWeaponEffect( VALK_AMB_EXHAUST_FP, VALK_AMB_EXHAUST_3P )
	}
                         
                                          
  
                              
  
      
}

#if CLIENT
void function OnWeaponCustomActivityStart_weapon_valkyrie_spear_primary( entity weapon, int sequence )
#else
void function OnWeaponCustomActivityStart_weapon_valkyrie_spear_primary( entity weapon )
#endif
{
	if ( weapon.GetWeaponActivity() == ACT_VM_WEAPON_INSPECT )
		{
			entity player = weapon.GetWeaponOwner()
			string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

			if ( meleeSkinName == "spear" )
			{
				weapon.StopWeaponEffect( VALK_AMB_EXHAUST_FP, VALK_AMB_EXHAUST_3P )
			}
                         
                                            
    
                                
    
      
		}
}

#if CLIENT
void function OnWeaponCustomActivityEnd_weapon_valkyrie_spear_primary( entity weapon, int activity )
#else
void function OnWeaponCustomActivityEnd_weapon_valkyrie_spear_primary( entity weapon )
#endif
{
#if SERVER
	int activity = weapon.GetWeaponActivity()
#endif

	if ( activity == ACT_VM_WEAPON_INSPECT )
		{
			entity player = weapon.GetWeaponOwner()
			string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

			if ( meleeSkinName == "spear" )
			{
				weapon.PlayWeaponEffect( VALK_AMB_EXHAUST_FP, VALK_AMB_EXHAUST_3P, "fx_l_thruster_top", true )
				weapon.PlayWeaponEffect( VALK_AMB_EXHAUST_FP, VALK_AMB_EXHAUST_3P, "fx_l_thruster_bot", true )
				weapon.PlayWeaponEffect( VALK_AMB_EXHAUST_FP, VALK_AMB_EXHAUST_3P, "fx_r_thruster_top", true )
				weapon.PlayWeaponEffect( VALK_AMB_EXHAUST_FP, VALK_AMB_EXHAUST_3P, "fx_r_thruster_bot", true )
			}
                         
                                            
    
                                
    
      
		}
}
