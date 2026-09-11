                    
global function MpWeaponOctaneKnifePrimaryRt01_Init

global function OnWeaponActivate_weapon_octane_knife_rt01_primary
global function OnWeaponDeactivate_weapon_octane_knife_rt01_primary

// Future: Define Effects here, Currently defined inside of animation events

                         
                                
      

                    
const table<string, table< int, int > > HEIRLOOM_SKIN_REMAP =
{
	["knife_rt01"] =
	{
		[eDamageSourceId.mp_weapon_octane_knife_primary] = eDamageSourceId.mp_weapon_octane_knife_rt01_primary,
		[eDamageSourceId.melee_octane_knife] = eDamageSourceId.melee_octane_knife_rt01,
	},
}
      

void function MpWeaponOctaneKnifePrimaryRt01_Init()
{
	// Future: precache particles etc.

                         
                                  
      

                    
	#if SERVER
		AddDamageCallbackSourceID( eDamageSourceId.mp_weapon_octane_knife_primary, OctaneHeirloom_OnSourceDamage )
		AddDamageCallbackSourceID( eDamageSourceId.melee_octane_knife, OctaneHeirloom_OnSourceDamage )
	#endif
      
}

                    
#if SERVER
void function OctaneHeirloom_OnSourceDamage( entity victim, var damageInfo )
{
	MeleeSkin_RemapSkinToDamageSourceId( damageInfo, HEIRLOOM_SKIN_REMAP )
}
#endif
      

void function OnWeaponActivate_weapon_octane_knife_rt01_primary( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

	if ( meleeSkinName == "knife" )
	{
		// Future: Play Effects Here
	}
                         
                                          
  
                              
  
      
}

void function OnWeaponDeactivate_weapon_octane_knife_rt01_primary( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

	if ( meleeSkinName == "knife" )
	{
		// Future: Stop Effects Here
	}
                         
                                          
  
                              
  
      
}
                              
