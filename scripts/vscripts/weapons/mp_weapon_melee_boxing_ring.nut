               
global function MpWeaponMeleeBoxingRing_Init

global function OnWeaponActivate_weapon_melee_boxing_ring
global function OnWeaponDeactivate_weapon_melee_boxing_ring

//const asset KUNAI_FX_GLOW_FP = $"P_kunai_idle_FP"
//const asset KUNAI_FX_GLOW_3P = $"P_kunai_idle_3P"

void function MpWeaponMeleeBoxingRing_Init()
{
	//PrecacheParticleSystem( KUNAI_FX_GLOW_FP )
	//PrecacheParticleSystem( KUNAI_FX_GLOW_3P )
}

void function OnWeaponActivate_weapon_melee_boxing_ring( entity weapon )
{
	//printt( "mp_weapon_wraith_kunai_primary activated" )

	//weapon.PlayWeaponEffect( KUNAI_FX_GLOW_FP, KUNAI_FX_GLOW_3P, "knife_base", true )
}

void function OnWeaponDeactivate_weapon_melee_boxing_ring( entity weapon )
{
	//printt( "mp_weapon_wraith_kunai_primary deactivated" )

	//weapon.StopWeaponEffect( KUNAI_FX_GLOW_FP, KUNAI_FX_GLOW_3P )
}
      
