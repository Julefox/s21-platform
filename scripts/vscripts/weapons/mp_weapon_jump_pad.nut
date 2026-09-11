global function OnWeaponTossReleaseAnimEvent_weapon_jump_pad
global function OnWeaponTossPrep_weapon_jump_pad
global function OnJumpPadPlanted

const float JUMP_PAD_ANGLE_LIMIT = 0.70

const bool JUMP_PAD_NEW_DEPLOY_FUNC = true


var function OnWeaponTossReleaseAnimEvent_weapon_jump_pad( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int ammoReq = weapon.GetAmmoPerShot()
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	entity deployable = ThrowDeployable( weapon, attackParams, 1.0, OnJumpPadPlanted, null, null )
	if ( deployable )
	{
		entity player = weapon.GetWeaponOwner()
		PlayerUsedOffhand( player, weapon, true, deployable )

		#if SERVER

		if( IsValid( player ) )
		{
			FiringRange_AddToRemoveOnCharacterChange( deployable, player )
		}

		deployable.proj.refundAmount = ammoReq
		deployable.proj.useHighDetailCollisionTraceForPlaceStickyEnt = true

		string projectileSound = GetGrenadeProjectileSound( weapon )
		if ( projectileSound != "" )
			EmitSoundOnEntity( deployable, projectileSound )

		weapon.w.lastProjectileFired = deployable
		#endif

		#if SERVER
			// S21 uses GetWeaponSettingString( eWeaponVar.battle_chatter_event ).
			// S3 eWeaponVar has no battle_chatter_event member (remapped to printname at load);
			// read the weapon-info key field instead so copycat_mod overrides still apply.
			var battleChatterLine = weapon.GetWeaponInfoFileKeyField( "battle_chatter_event" )
			if ( battleChatterLine != null )
				PlayBattleChatterLineToSpeakerAndTeam( player, expect string( battleChatterLine ) )
		#endif
	}

	return ammoReq
}

void function OnWeaponTossPrep_weapon_jump_pad( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )
}

void function OnJumpPadPlanted( entity projectile, DeployableCollisionParams collisionParams )
{
#if SERVER
#if JUMP_PAD_NEW_DEPLOY_FUNC

	// Do a low-detail trace so we can orient the Jump Pad along player collision surfaces rather than high-detail/projectile collision surfaces
	float traceLength	= 5.0
	vector traceStart	= collisionParams.pos + (traceLength * collisionParams.normal)
	vector traceEnd		= collisionParams.pos - (traceLength * collisionParams.normal)
	TraceResults lowDetailTrace = TraceLine( traceStart, traceEnd, [ projectile ], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
	if ( lowDetailTrace.fraction < 1.0 )
	{
		vector oldForward = AnglesToForward( projectile.GetAngles() )
		vector surfaceAngles = AnglesOnSurface( lowDetailTrace.surfaceNormal, oldForward )
		projectile.SetAbsAngles( surfaceAngles )
	}

	thread JumpPad_CreateAndDeployFromProjectile( projectile )

#else // #if JUMP_PAD_NEW_DEPLOY_FUNC

	Assert( IsValid( projectile ) )
	vector origin = projectile.GetOrigin()

	vector endOrigin = origin - <0,0,32>
	vector up = AnglesToUp( projectile.GetAngles() )
	vector start = projectile.GetOrigin() + (up*16)
	vector surfaceAngles = projectile.proj.savedAngles
	vector oldUpDir = AnglesToUp( surfaceAngles )

	TraceResults traceResult = TraceLine( start, endOrigin, [ projectile ], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
	if ( traceResult.fraction < 1.0 )
	{
		vector forward = AnglesToForward( projectile.proj.savedAngles )
		surfaceAngles = AnglesOnSurface( traceResult.surfaceNormal, forward )

		vector newUpDir = AnglesToUp( surfaceAngles )
		if ( DotProduct( newUpDir, oldUpDir ) < JUMP_PAD_ANGLE_LIMIT )
			surfaceAngles = projectile.proj.savedAngles
	}

	entity oldParent = projectile.GetParent()
	projectile.ClearParent()
	// thread TrapDestroyOnRoundEnd( projectile.GetOwner(), projectile )

	DeployableCollisionParams cp
	cp.hitEnt = traceResult.hitEnt
	cp.deployableFlags = eDeployableFlags.VEHICLES_NO_STICK
	if ( IsValid( traceResult.hitEnt ) && EntityShouldStickEx( projectile, cp ) && !traceResult.hitEnt.IsWorld() )
	{
		projectile.SetAngles( surfaceAngles )
		projectile.SetParent( traceResult.hitEnt )
	}
	else if ( IsValid( oldParent ) )
	{
		projectile.SetParent( oldParent )
	}

	//vector surfaceNormal = AnglesToUp( surfaceAngles )
	//DebugDrawLine( origin, origin + ( surfaceNormal * 64 ), COLOR_RED, true, 30.0 )

	thread JumpPad_CreateAndDeployFromProjectile( projectile )

#endif // #else // #if JUMP_PAD_NEW_DEPLOY_FUNC
#endif // #if SERVER
}
