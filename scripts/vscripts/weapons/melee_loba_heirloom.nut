global function MeleeLobaHeirloom_Init

global function OnWeaponActivate_melee_loba_heirloom
global function OnWeaponDeactivate_melee_loba_heirloom

// Future: Define Effects here, Currently defined inside of animation events

                         
                                
      

void function MeleeLobaHeirloom_Init()
{
	// Future: precache particles etc.

	PrecacheImpactEffectTable( "melee_loba_fan_blunt" )

                         
                                  
      

}

// this weapon is only used for attacks (not "primary weapon" idling onscreen)
// - activate = attack start; deactivate = attack finished
void function OnWeaponActivate_melee_loba_heirloom( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

	if ( meleeSkinName == "fan" )
	{
		// Future: Play Effects Here
	}
                         
                                        
  
                              
  
      

}

void function OnWeaponDeactivate_melee_loba_heirloom( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

	if ( meleeSkinName == "fan" )
	{
		// Future: Stop Effects Here
	}
                         
                                        
  
                              
  
      

}
