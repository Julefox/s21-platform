
global function MpSpaceElevatorAbility_Init
global function OnWeaponReadyToFire_weapon_space_elevator_tac
global function OnWeaponDeactivate_weapon_space_elevator_tac
global function OnWeaponTossRelease_weapon_space_elevator_tac


const asset ELEVATOR_GRENADE_FX_GLOW_FP = $"P_repulsor_ptpov"
const asset ELEVATOR_GRENADE_FX_GLOW_3P = $"P_repulsor_pt3p"

const int CHANCE_TO_BATTLE_CHATTER_ELEVATOR = 50

void function MpSpaceElevatorAbility_Init()
{
	PrecacheParticleSystem( ELEVATOR_GRENADE_FX_GLOW_FP )
	PrecacheParticleSystem( ELEVATOR_GRENADE_FX_GLOW_3P )
}


void function OnWeaponReadyToFire_weapon_space_elevator_tac( entity weapon )
{
	weapon.PlayWeaponEffect( ELEVATOR_GRENADE_FX_GLOW_FP, ELEVATOR_GRENADE_FX_GLOW_3P, "muzzle_flash" )
}

void function OnWeaponDeactivate_weapon_space_elevator_tac( entity weapon )
{
	weapon.StopWeaponEffect( ELEVATOR_GRENADE_FX_GLOW_FP, ELEVATOR_GRENADE_FX_GLOW_3P )
	Grenade_OnWeaponDeactivate( weapon )
}

var function OnWeaponTossRelease_weapon_space_elevator_tac( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	weapon.StopWeaponEffect( ELEVATOR_GRENADE_FX_GLOW_FP, ELEVATOR_GRENADE_FX_GLOW_3P )
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	///////////////////////////////////////////////////////////////////
	// Throwable version
	entity deployable = ThrowDeployable( weapon, attackParams, 1.0, SpaceElevatorTac_ProjectileLanded, null, ZERO_VECTOR )
	if ( deployable )
	{
		entity player = weapon.GetWeaponOwner()
		PlayerUsedOffhand( player, weapon, true, deployable )

		#if SERVER
			deployable.proj.refundAmount = weapon.GetAmmoPerShot()

			string projectileSound = GetGrenadeProjectileSound( weapon )
			if ( projectileSound != "" )
				EmitSoundOnEntity( deployable, projectileSound )

			weapon.w.lastProjectileFired = deployable

		#endif
		#if SERVER
			if ( RandomIntRange( 0, 100 ) <= CHANCE_TO_BATTLE_CHATTER_ELEVATOR )
			{
				TryPlayWeaponBattleChatterLine( player, weapon )
			}
		#endif
	}
	///////////////////////////////////////////////////////////////////


	int ammoReq = weapon.GetAmmoPerShot()
	return ammoReq
}

void function SpaceElevatorTac_ProjectileLanded( entity projectile, DeployableCollisionParams collisionParams )
{
	#if SERVER
		Assert( IsValid( projectile ) )

		//Whats our parent?
		entity parentTo = projectile.GetParent()
		if ( IsValid( collisionParams.hitEnt ) && EntityShouldStick( projectile, collisionParams.hitEnt ) && !collisionParams.hitEnt.IsWorld() )
		{
			parentTo = collisionParams.hitEnt
		}

		entity projOwner = projectile.GetOwner()

                      
                                                                            

		     
		projectile.Destroy()

		// Deploy the prop
		thread SpaceElevator_PropDeploy( projOwner, collisionParams.pos, ZERO_VECTOR, parentTo )
        

	#endif
}


#if SERVER
                    
                                                                                      
 
                                         

                                          
                                                                                                                                    

                                                                                                
                      
  
                                                                  
                                                                                                                                    

                                                           

                   
                                                                                                                                
                   

                      
               
  

                             
  
                                                           
                      
  

                                                                         
 
      
#endif
