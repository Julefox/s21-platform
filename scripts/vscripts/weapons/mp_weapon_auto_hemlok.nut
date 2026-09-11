global function WeaponAutoHemlok_Init
global function OnWeaponActivate_hemlok_auto
global function OnWeaponDeactivate_hemlok_auto
global function OnWeaponPrimaryAttack_hemlok_auto
global function OnProjectileCollision_hemlok_auto
global function OnWeaponReload_weapon_hemlok_auto
global function WeaponAutoHemlok_BreachChargeOnCooldown
global function WeaponIsAutoHemlok

const string AUTO_HEMLOK_CLASS_NAME = "mp_weapon_auto_hemlok"
const string AUTO_HEMLOK_CRATE_CLASS_NAME = "mp_weapon_auto_hemlok_crate"
const float AUTO_HEMLOK_BREACH_COOLDOWN_DEFAULT = 30.0

void function WeaponAutoHemlok_Init()
{
#if CLIENT
	AddCallback_OnPlayerAddWeaponMod( WeaponAutoHemlok_AddedToggleWeaponMod )
#endif
}

bool function WeaponIsAutoHemlok( entity weapon )
{
	if ( !IsValid( weapon ) )
		return false

	string name = weapon.GetWeaponClassName()
	return name == AUTO_HEMLOK_CLASS_NAME || name == AUTO_HEMLOK_CRATE_CLASS_NAME
}

void function OnWeaponActivate_hemlok_auto( entity weapon )
{
#if CLIENT
	if ( GetLocalClientPlayer() == GetLocalViewPlayer() )
	{
		if ( weapon.HasMod( "altfire" ) && WeaponAutoHemlok_BreachChargeOnCooldown( weapon ) )
			weapon.RemoveMod( "altfire" )
	}
#endif

	if ( weapon.HasMod( "hopup_smart_reload" ) )
	{
		SmartReloadSettings settings
		settings.OverloadedAmmo = GetWeaponInfoFileKeyField_GlobalInt( AUTO_HEMLOK_CLASS_NAME, OVERLOAD_AMMO_SETTING )
		settings.LowAmmoFrac    = GetWeaponInfoFileKeyField_GlobalFloat( AUTO_HEMLOK_CLASS_NAME, LOW_AMMO_FAC_SETTING )

		OnWeaponActivate_Smart_Reload( weapon, settings )
	}
	else
	{
#if SERVER
		weapon.RemoveMod( "overloaded_ammo" )
		weapon.RemoveMod( "fast_reload_mod" )
#endif
	}
}

void function OnWeaponDeactivate_hemlok_auto( entity weapon )
{
	OnWeaponDeactivate_Smart_Reload( weapon )
}

var function OnWeaponPrimaryAttack_hemlok_auto( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( weapon.HasMod( "altfire" ) )
	{
		if ( WeaponAutoHemlok_BreachChargeOnCooldown( weapon ) )
			return 0

		entity projectile = Grenade_Launch( weapon, attackParams.pos, attackParams.dir, PROJECTILE_PREDICTED, PROJECTILE_LAG_COMPENSATED, <0, 0, 0> )
#if SERVER
		if ( IsValid( projectile ) )
			projectile.ProjectileSetDamageSourceID( eDamageSourceId.mp_weapon_auto_hemlok_breach_charge )
		else
			Warning( "Auto Hemlok breach Grenade_Launch returned null\n" )
#endif

		thread BreachCharge_CooldownThread( weapon )

#if CLIENT
		if ( InPrediction() )
#endif
		{
			weapon.RemoveMod( "altfire" )
		}

		return 0
	}

	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, 1.0, 1.0, false )
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

#if CLIENT
void function OnProjectileCollision_hemlok_auto( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical, bool isPassthrough )
{
	WeaponAutoHemlok_TryExplodeBreach( projectile, normal )
}
#else
void function OnProjectileCollision_hemlok_auto( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	WeaponAutoHemlok_TryExplodeBreach( projectile, normal )
}
#endif

void function WeaponAutoHemlok_TryExplodeBreach( entity projectile, vector normal )
{
	if ( !IsValid( projectile ) )
		return

	if ( !projectile.HasWeaponMod( "altfire" ) )
		return

	if ( projectile.GetCodeClassName() != "grenade" )
		return

	projectile.GrenadeExplode( normal )
}

void function OnWeaponReload_weapon_hemlok_auto( entity weapon, int milestoneIndex )
{
	OnWeaponReload_Smart_Reload( weapon, milestoneIndex )
}

void function BreachCharge_CooldownThread( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	weapon.EndSignal( "OnDestroy" )

	float debounce = GetCurrentPlaylistVarFloat( "auto_hemlok_cooldownTime", AUTO_HEMLOK_BREACH_COOLDOWN_DEFAULT )
	if ( IsInfiniteAmmoEnabled() )
		debounce = 0.0
	float debounceTime = Time() + debounce

#if CLIENT
	if ( InPrediction() )
#endif
	{
		weapon.SetScriptTime0( debounceTime )
	}

	OnThreadEnd(
		function() : ( weapon )
		{
			if ( !IsValid( weapon ) )
				return

#if CLIENT
			if ( InPrediction() )
#endif
			{
				weapon.SetScriptTime0( Time() )
			}
		}
	)

	wait debounce
}

bool function WeaponAutoHemlok_BreachChargeOnCooldown( entity weapon )
{
	if ( !IsValid( weapon ) )
		return false

	if ( !weapon.IsWeaponX() )
		return false

	if ( IsInfiniteAmmoEnabled() )
		return false

	return Time() < weapon.GetScriptTime0()
}

#if CLIENT
void function WeaponAutoHemlok_AddedToggleWeaponMod( entity player, entity weapon, string mod )
{
	if ( !WeaponIsAutoHemlok( weapon ) )
		return

	if ( mod != "altfire" )
		return

	float fuseTime = weapon.GetWeaponSettingFloat( eWeaponVar.grenade_fuse_time )
	weapon.SetIndicatorEffectDurationOverride( fuseTime )
}
#endif
