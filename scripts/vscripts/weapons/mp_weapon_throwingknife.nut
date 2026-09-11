
global function OnProjectileCollision_weapon_throwingknife
global function OnWeaponActivate_weapon_throwingknife

const int KNIFE_DESPAWN_TIME = 5

void function OnWeaponActivate_weapon_throwingknife( entity weapon )
{

#if SERVER

	if ( !IsValid( weapon ) )
		return

	entity player = weapon.GetWeaponOwner()

	if( player.IsNPC() || !IsValid( player ) )
		return

	if (PlayerHasPassive(player, ePassives.PAS_PARIAH ))
	{
		weapon.AddMod( "seer_passive_throwingknife" )
		weapon.w.modsToRemoveOnDrop.append( "seer_passive_throwingknife" )
	}
	else if ( weapon.HasMod ( "seer_passive_throwingknife" ) )
	{
		weapon.RemoveMod( "seer_passive_throwingknife")
	}

#endif

}

#if SERVER
void function OnProjectileCollision_weapon_throwingknife( entity projectile, vector pos, vector normal, entity hitEnt, int hitBox, bool isCritical )
#else
void function OnProjectileCollision_weapon_throwingknife( entity projectile, vector pos, vector normal, entity hitEnt, int hitBox, bool isCritical, bool isPassthrough )
#endif
{

	if ( !IsValid( projectile ) )
	{
		return
	}


	if ( !IsValid( hitEnt ) )
	{
		#if SERVER
			projectile.Destroy()
		#endif
		return
	}

	bool ignoreTarget

	//Dont stick to player who threw it
	if ( IsValid( projectile.GetOwner() ) && hitEnt == projectile.GetOwner() )
		ignoreTarget = true

	//Dont stick to Ally
	if ( hitEnt.IsPlayer() && IsFriendlyTeam( hitEnt.GetTeam(), projectile.GetTeam() ) )
		ignoreTarget = true

	//Dont stick to Vehicle
	//if ( hitEnt.IsPlayerVehicle() )
	//	ignoreTarget = true

	//Don't stick to players effected by Revnant Totem
	if ( hitEnt.IsPlayer() && StatusEffect_GetTimeRemaining (hitEnt, eStatusEffect.death_totem_recall) > 0.0 )
	{
		ignoreTarget = true
	}

	if (Bleedout_IsBleedingOut( hitEnt ))
	{
		ignoreTarget = true
	}

	vector forward = AnglesToForward( VectorToAngles( projectile.GetVelocity() ) )
	vector stickNormal

	if ( LengthSqr( forward ) > FLT_EPSILON )
		stickNormal = forward
	else
		stickNormal = normal

	DeployableCollisionParams collisionParams
	collisionParams.pos = pos + (projectile.proj.savedDir)
	collisionParams.normal = stickNormal
	collisionParams.hitEnt = hitEnt
	collisionParams.hitBox = hitBox
	collisionParams.isCritical = isCritical
	projectile.kv.solid          = 0
	projectile.SetDoesExplode( false )

	vector plantAngles = AnglesCompose( VectorToAngles( collisionParams.normal ), <90,0,0> )

	if ( !PlantStickyEntity( projectile, collisionParams, <90,0,0> , true ) || ignoreTarget )
	{
		//Plant Failed or Rejected
		#if SERVER
			projectile.Destroy() // Very delayed on client
		#else // #if SERVER
			// We need to still stop the entity and teleport, as the client has a very delayed deletion of the projectile
			projectile.StopPhysics()
			projectile.SetVelocity( <0, 0, 0> )
			projectile.ProjectileTeleport( collisionParams.pos, plantAngles )
		#endif // #else // #if SERVER
	}
	else
	{
		//Plant Success
		if ( IsValid( projectile ) )
		{
			#if CLIENT
				projectile.ProjectileTeleport( collisionParams.pos, plantAngles )
			#endif // #if CLIENT

			if ( IsValid( projectile.GetWeaponSource() ) )
			{
				StopSoundOnEntity( projectile, GetGrenadeProjectileSound( projectile.GetWeaponSource() ) )
			}
			thread CleanupKnife( projectile, hitEnt, KNIFE_DESPAWN_TIME )
		}
	}
}

void function CleanupKnife( entity ent, entity hitEnt, float time )
{
#if SERVER
	OnThreadEnd(
		function() : ( ent, hitEnt )
		{
			if ( IsValid( ent ) )
			{
				ent.Destroy()
			}
		}
	)

	if ( IsValid( hitEnt ) )
	{
		if ( (hitEnt.IsPlayer() || hitEnt.IsNPC()) && !IsAlive( hitEnt ) )
			return

		hitEnt.EndSignal( "OnDestroy" )
		hitEnt.EndSignal( "OnDeath" )
	}
	else
	{
		return
	}

	if ( IsValid( ent ) )
		ent.EndSignal( "OnDestroy" )
	else
		return

	if ( time >= 0 )
		wait time
	else
		WaitForever()
#endif
}
