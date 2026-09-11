global function MpWeaponSeerHeirloomPrimary_Init
global function OnWeaponActivate_weapon_seer_heirloom_primary
global function OnWeaponDeactivate_weapon_seer_heirloom_primary

const string HEIRLOOM_EQUIPPED_MOD = "heirloom_equipped"

//----FX base
                         
                                
      


void function MpWeaponSeerHeirloomPrimary_Init()
{
                         
                                  
      

}

void function OnWeaponActivate_weapon_seer_heirloom_primary( entity weapon )
{
	#if CLIENT
		if ( !InPrediction() )
			return
	#endif

	entity player = weapon.GetWeaponOwner()
	string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

	Melee_SetModsForLegendAbilities( player )

	if ( meleeSkinName == "heirloom" )
	{
		// Future: Play effects here
	}
                         
                                             
  
                              
  
      

}

void function OnWeaponDeactivate_weapon_seer_heirloom_primary( entity weapon )
{
	#if CLIENT
		if ( !InPrediction() )
			return
	#endif
	entity player = weapon.GetWeaponOwner()
	string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

	Melee_RemoveModsForLegendAbilities( player )

	if ( meleeSkinName == "heirloom" )
	{
		// Future: Stop effects here
	}
                         
                                             
  
                              
  
      

}
