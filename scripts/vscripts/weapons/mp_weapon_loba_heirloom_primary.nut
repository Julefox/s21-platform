global function MpWeaponLobaHeirloomPrimary_Init
global function OnWeaponActivate_weapon_loba_heirloom_primary
global function OnWeaponDeactivate_weapon_loba_heirloom_primary

//----FX base
// Future: Define Effects here, Currently defined inside of animation events

                         
                                
      


void function MpWeaponLobaHeirloomPrimary_Init()
{
	// Future: precache particles etc.

                         
                                  
      

}

void function OnWeaponActivate_weapon_loba_heirloom_primary( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

	if ( meleeSkinName == "fan" )
	{
		// Future: Play Effects Here
	}
                         
                                        
  
                              
  
      

}

void function OnWeaponDeactivate_weapon_loba_heirloom_primary( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

	if ( meleeSkinName == "fan" )
	{
		// Future: Stop Effects Here
	}
                         
                                        
  
                              
  
      

}
