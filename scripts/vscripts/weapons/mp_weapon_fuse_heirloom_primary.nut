global function MpWeaponFuseHeirloomPrimary_Init
global function OnWeaponActivate_weapon_fuse_heirloom_primary
global function OnWeaponDeactivate_weapon_fuse_heirloom_primary

// Define effects here
const asset GUITAR_FX_BASE_FP = $"P_fuse_guitar_base" //added empty fx in case is needed
const asset GUITAR_FX_BASE_3P = $"P_fuse_guitar_base_3P"//added empty fx in case is needed

                         
                                
      

void function MpWeaponFuseHeirloomPrimary_Init()
{
	// Precache Retheme effects here
	PrecacheParticleSystem( GUITAR_FX_BASE_FP )
	PrecacheParticleSystem( GUITAR_FX_BASE_3P )

                         
                                  

      

}

void function OnWeaponActivate_weapon_fuse_heirloom_primary( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

	if ( meleeSkinName == "heirloom" )
	{
		// Play effects here
		weapon.PlayWeaponEffect( GUITAR_FX_BASE_FP, GUITAR_FX_BASE_3P, "fx_blade_btm", true )

	}
                         
                                             
  
                              
  
      

}

void function OnWeaponDeactivate_weapon_fuse_heirloom_primary( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

	if ( meleeSkinName == "heirloom" )
	{
		// Stop effects here
		weapon.StopWeaponEffect( GUITAR_FX_BASE_FP, GUITAR_FX_BASE_3P )

	}
                         
                                             
  
                              
  
      

}
