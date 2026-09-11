// Flowstate raygun fire path (Cafe port). Loot row required in survival_loot.csv.

global function OnWeaponActivate_RayGun
global function OnWeaponDeactivate_RayGun
global function OnWeaponPrimaryAttack_RayGun
global function MpWeaponRayGun_Init

#if SERVER
global function OnWeaponNpcPrimaryAttack_RayGun
#endif

const string RAYGUN_CLASS_NAME = "mp_weapon_raygun"
const asset BULLETMODELRAYGUN = $"mdl/fx/ar_marker_ringwobble.rmdl"
const asset BULLETMODELRAYGUN3 = $"mdl/fx/energy_ring_core_fx.rmdl"

void function MpWeaponRayGun_Init()
{
	PrecacheModel( BULLETMODELRAYGUN )
	PrecacheModel( BULLETMODELRAYGUN3 )
}

void function OnWeaponActivate_RayGun( entity weapon )
{
	#if CLIENT
		UpdateViewmodelAmmo( false, weapon )
	#endif
}

void function OnWeaponDeactivate_RayGun( entity weapon )
{
}

var function OnWeaponPrimaryAttack_RayGun( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireRayGun( weapon, attackParams, true )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_RayGun( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireRayGun( weapon, attackParams, false )
}
#endif

int function FireRayGun( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired )
{
	#if CLIENT
		if ( !weapon.ShouldPredictProjectiles() )
			return 1
	#endif

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	entity player = weapon.GetWeaponOwner()
	int damageFlags = weapon.GetWeaponDamageFlags()
	WeaponFireBoltParams fireBoltParams
	fireBoltParams.pos = attackParams.pos
	fireBoltParams.dir = attackParams.dir
	fireBoltParams.speed = 1
	fireBoltParams.scriptTouchDamageType = damageFlags
	fireBoltParams.scriptExplosionDamageType = damageFlags
	fireBoltParams.clientPredicted = playerFired
	fireBoltParams.additionalRandomSeed = 0
	entity bullet = weapon.FireWeaponBoltAndReturnEntity( fireBoltParams )

	#if SERVER
	if ( IsValid( bullet ) && IsValid( player ) )
	{
		entity trailFXHandle = StartParticleEffectOnEntity_ReturnEntity( bullet, GetParticleSystemIndex( $"P_skydive_trail_CP" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
		EffectSetControlPointVector( trailFXHandle, 1, <89, 255, 136> )
		EntFireByHandle( trailFXHandle, "Kill", "", 1, null, null )
		EntFireByHandle( trailFXHandle, "Stop", "", 1, null, null )

		vector angles = VectorToAngles( player.GetOrigin() - bullet.GetOrigin() )

		entity visual = CreatePropDynamic( BULLETMODELRAYGUN, bullet.GetOrigin(), Vector( 90, angles.y, angles.z ) )
		visual.SetModelScale( 0.3 )
		visual.kv.rendercolor = "89, 255, 136"
		visual.kv.renderamt = 100
		visual.SetParent( bullet )

		entity visual3 = CreatePropDynamic( BULLETMODELRAYGUN3, bullet.GetOrigin(), Vector( 90, angles.y, angles.z ) )
		visual3.SetModelScale( 0.3 )
		visual3.kv.rendercolor = "89, 255, 136"
		visual3.SetParent( bullet )
	}
	#endif

	return 1
}
