                    
global function MeleeCryptoHeirloomRt01_Init

global function OnWeaponActivate_melee_crypto_heirloom_rt01
global function OnWeaponDeactivate_melee_crypto_heirloom_rt01

// DavidF 10/11/23 : it seems fx are not triggering from this file, but from the melee_crypto_heirloom.nut under the Rt01 sections.
// Once the alias system is ready we can delete the dup script/files and move all inspect fx to alias system.
const CRYPTO_FX_ATTACK_SWIPE_TOP_FP_rt01 = $"P_crypto_sword_rt01_swipe_top"
const CRYPTO_FX_ATTACK_SWIPE_TOP_3P_rt01 = $"P_crypto_sword_rt01_swipe_top_3P"   //vfx is currently empty
const CRYPTO_FX_ATTACK_SWIPE_FP_rt01 = $"P_crypto_sword_rt01_swipe"
const CRYPTO_FX_ATTACK_SWIPE_3P_rt01 = $"P_crypto_sword_rt01_swipe_3P"        //vfx is currently empty, using rig mesh instead
                    
		// Define Retheme effects here
      

void function MeleeCryptoHeirloomRt01_Init()
{
	// Precache Retheme effects here
	PrecacheParticleSystem( CRYPTO_FX_ATTACK_SWIPE_FP_rt01 )
	PrecacheParticleSystem( CRYPTO_FX_ATTACK_SWIPE_3P_rt01 )
	PrecacheParticleSystem( CRYPTO_FX_ATTACK_SWIPE_TOP_FP_rt01 )
	PrecacheParticleSystem( CRYPTO_FX_ATTACK_SWIPE_TOP_3P_rt01 )


	PrecacheImpactEffectTable( "melee_crypto_drone" )

                    
		// Precache Retheme effects here
      

}

void function OnWeaponActivate_melee_crypto_heirloom_rt01( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

	if ( meleeSkinName == "heirloom" )
	{
		weapon.PlayWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP_rt01, CRYPTO_FX_ATTACK_SWIPE_TOP_3P_rt01, "Fx_def_blade_01" )
		weapon.PlayWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP_rt01, CRYPTO_FX_ATTACK_SWIPE_TOP_3P_rt01, "Fx_def_blade_03" )
		weapon.PlayWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP_rt01, CRYPTO_FX_ATTACK_SWIPE_TOP_3P_rt01, "Fx_def_blade_05" )
		weapon.PlayWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP_rt01, CRYPTO_FX_ATTACK_SWIPE_TOP_3P_rt01, "Fx_def_blade_07" )
	}
                    
	else if ( meleeSkinName == "heirloom_rt01" )
	{
		// Play Retheme effects here
	}
      

}

void function OnWeaponDeactivate_melee_crypto_heirloom_rt01( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

	if ( meleeSkinName == "heirloom" )
	{
		weapon.StopWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP_rt01, CRYPTO_FX_ATTACK_SWIPE_3P_rt01 )
		weapon.StopWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_TOP_FP_rt01, CRYPTO_FX_ATTACK_SWIPE_TOP_3P_rt01 )
	}
                    
	else if ( meleeSkinName == "heirloom_rt01" )
	{
		// Stop Retheme effects here
	}
      

}
                              
