global function MeleeCryptoHeirloom_Init

global function OnWeaponActivate_melee_crypto_heirloom
global function OnWeaponDeactivate_melee_crypto_heirloom

const CRYPTO_FX_ATTACK_SWIPE_TOP_FP = $"P_crypto_sword_swipe_top"
const CRYPTO_FX_ATTACK_SWIPE_TOP_3P = $"P_crypto_sword_swipe_top_3P"   //vfx is currently empty
const CRYPTO_FX_ATTACK_SWIPE_FP = $"P_crypto_sword_swipe"
const CRYPTO_FX_ATTACK_SWIPE_3P = $"P_crypto_sword_swipe_3P"        //vfx is currently empty, using rig mesh instead

                    
// Define Retheme effects here
const CRYPTO_FX_ATTACK_SWIPE_TOP_FP_rt01 = $"P_crypto_sword_rt01_swipe_top"
const CRYPTO_FX_ATTACK_SWIPE_TOP_3P_rt01 = $"P_crypto_sword_rt01_swipe_top_3P"   //vfx is currently empty
const CRYPTO_FX_ATTACK_SWIPE_FP_rt01 = $"P_crypto_sword_rt01_swipe"
const CRYPTO_FX_ATTACK_SWIPE_3P_rt01 = $"P_crypto_sword_rt01_swipe_3P"        //vfx is currently empty, using rig mesh instead
// Retheme effects for animation events / inspects.
const CRYPTO_FX_INSPECT_SWIPENR_rt01 = $"P_crypto_sword_rt01_swipe_Norefrac"
const CRYPTO_FX_INSPECT_SWIPE_rt01 = $"P_crypto_sword_rt01_swipe"
const CRYPTO_FX_INSPECT_REBOOT_CORE_rt01 = $"P_crypto_sword_rt01_ins_reboot_core"
const CRYPTO_FX_INSPECT_REBOOT_CORER_rt01 = $"P_crypto_sword_rt01_ins_reboot_core_bladeR"
const CRYPTO_FX_INSPECT_REBOOT_COREL_rt01 = $"P_crypto_sword_rt01_ins_reboot_core_bladeL"
const CRYPTO_FX_INSPECT_REBOOT_CORE_TOP_rt01 = $"P_crypto_sword_rt01_ins_reboot_top"
const CRYPTO_FX_INSPECT_REBOOT_CORE_NRG_rt01 = $"P_crypto_sword_rt01_ins_reboot_enrg"
const CRYPTO_FX_INSPECT_REBOOT_HUD_rt01 = $"P_crypto_sword_rt01_ins_reboot_hud"

const string SWORD_RT01_MOD = "sword_rt01"
      

void function MeleeCryptoHeirloom_Init()
{
	PrecacheParticleSystem( CRYPTO_FX_ATTACK_SWIPE_FP )
	PrecacheParticleSystem( CRYPTO_FX_ATTACK_SWIPE_3P )
	PrecacheParticleSystem( CRYPTO_FX_ATTACK_SWIPE_TOP_FP )
	PrecacheParticleSystem( CRYPTO_FX_ATTACK_SWIPE_TOP_3P )

	PrecacheImpactEffectTable( "melee_crypto_drone" )

                    
	// Precache Retheme effects here
	// Attacks
	PrecacheParticleSystem( CRYPTO_FX_ATTACK_SWIPE_FP_rt01 )
	PrecacheParticleSystem( CRYPTO_FX_ATTACK_SWIPE_3P_rt01 )
	PrecacheParticleSystem( CRYPTO_FX_ATTACK_SWIPE_TOP_FP_rt01 )
	PrecacheParticleSystem( CRYPTO_FX_ATTACK_SWIPE_TOP_3P_rt01 )
	// inspects
	PrecacheParticleSystem( CRYPTO_FX_INSPECT_SWIPENR_rt01 )
	PrecacheParticleSystem( CRYPTO_FX_INSPECT_SWIPE_rt01 )
	PrecacheParticleSystem( CRYPTO_FX_INSPECT_REBOOT_CORE_rt01 )
	PrecacheParticleSystem( CRYPTO_FX_INSPECT_REBOOT_COREL_rt01 )
	PrecacheParticleSystem( CRYPTO_FX_INSPECT_REBOOT_CORER_rt01 )
	PrecacheParticleSystem( CRYPTO_FX_INSPECT_REBOOT_CORE_TOP_rt01 )
	PrecacheParticleSystem( CRYPTO_FX_INSPECT_REBOOT_CORE_NRG_rt01 )
	PrecacheParticleSystem( CRYPTO_FX_INSPECT_REBOOT_HUD_rt01 )

      

}

void function OnWeaponActivate_melee_crypto_heirloom( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

	if ( meleeSkinName == "heirloom" )
	{
		weapon.PlayWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP, CRYPTO_FX_ATTACK_SWIPE_TOP_3P, "Fx_def_blade_01" )
		weapon.PlayWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP, CRYPTO_FX_ATTACK_SWIPE_TOP_3P, "Fx_def_blade_03" )
		weapon.PlayWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP, CRYPTO_FX_ATTACK_SWIPE_TOP_3P, "Fx_def_blade_05" )
		weapon.PlayWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP, CRYPTO_FX_ATTACK_SWIPE_TOP_3P, "Fx_def_blade_07" )

		if ( IsServer() || InPrediction() )
			weapon.RemoveMod( SWORD_RT01_MOD )
	}
                    
	else if ( meleeSkinName == "heirloom_rt01" )
	{
		// Play Retheme effects here
		weapon.PlayWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP_rt01, CRYPTO_FX_ATTACK_SWIPE_TOP_3P_rt01, "Fx_def_blade_01" )
		weapon.PlayWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP_rt01, CRYPTO_FX_ATTACK_SWIPE_TOP_3P_rt01, "Fx_def_blade_03" )
		weapon.PlayWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP_rt01, CRYPTO_FX_ATTACK_SWIPE_TOP_3P_rt01, "Fx_def_blade_05" )
		weapon.PlayWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP_rt01, CRYPTO_FX_ATTACK_SWIPE_TOP_3P_rt01, "Fx_def_blade_07" )

		if ( (IsServer() || InPrediction()) && !weapon.HasMod( "proto_door_kick" ) )
			weapon.AddMod( SWORD_RT01_MOD )
	}
      

}

void function OnWeaponDeactivate_melee_crypto_heirloom( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	string meleeSkinName = MeleeSkin_GetSkinNameFromPlayer( player )

	if ( meleeSkinName == "heirloom" )
	{
		weapon.StopWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP, CRYPTO_FX_ATTACK_SWIPE_3P )
		weapon.StopWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_TOP_FP, CRYPTO_FX_ATTACK_SWIPE_TOP_3P )
	}
                    
	else if ( meleeSkinName == "heirloom_rt01" )
	{
		// Stop Retheme effects here
		weapon.StopWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_FP_rt01, CRYPTO_FX_ATTACK_SWIPE_3P_rt01 )
		weapon.StopWeaponEffect( CRYPTO_FX_ATTACK_SWIPE_TOP_FP_rt01, CRYPTO_FX_ATTACK_SWIPE_TOP_3P_rt01 )

	}
      

}
