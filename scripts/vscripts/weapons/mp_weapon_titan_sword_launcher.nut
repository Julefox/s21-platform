                          
global function MpWeaponTitanSword_Launcher_Init
global function TitanSword_Launcher_OnWeaponActivate
global function TitanSword_Launcher_ClearMods
global function TitanSword_Launcher_TryLauncher
global function TitanSword_Launcher_VictimHitOverride
global function TitanSword_Launcher_TryLauncherAnimEvent

//Names
global const string TITAN_SWORD_LAUNCHER_MOD = "launcher"

//Playlist Vars

//Signals

//DEBUG

//Vars

//VFX
const asset VFX_TITAN_SWORD_LAUNCHER_JETS = $"P_pilot_dash_launch_thruster"
const string VFX_TITAN_SWORD_LAUNCHER_TAKEOFF_IMPACT = "pilot_bodyslam"
const TITAN_SWORD_FX_LAUNCH_ATK_FP = $"P_pilot_sword_swipe_launch_FP"
const TITAN_SWORD_FX_LAUNCH_ATK_3P = $"P_pilot_sword_swipe_launch_3P"



//SFX
const string SFX_TITAN_SWORD_LAUNCH_1P = "titansword_special_launch_1p"

struct
{
}file

void function MpWeaponTitanSword_Launcher_Init()
{
	PrecacheParticleSystem( VFX_TITAN_SWORD_LAUNCHER_JETS )

	PrecacheParticleSystem( TITAN_SWORD_FX_LAUNCH_ATK_FP )
	PrecacheParticleSystem( TITAN_SWORD_FX_LAUNCH_ATK_3P )

	#if SERVER
		AddDamageCallbackSourceID( eDamageSourceId.mp_weapon_titan_sword, TitanSword_OnDamageDealt )
		AddDamageCallbackSourceID( eDamageSourceId.melee_titan_sword, TitanSword_OnDamageDealt )
		AddDamageCallbackSourceID( eDamageSourceId.mp_weapon_titan_sword_slam, TitanSword_OnDamageDealt )
	#endif
}

void function TitanSword_Launcher_OnWeaponActivate( entity player, entity weapon )
{
	#if SERVER
		TitanSword_RemoveModOnDrop( weapon, TITAN_SWORD_LAUNCHER_MOD )
	#endif
}

void function TitanSword_Launcher_StartVFX( entity weapon )
{
	//FX that need to play for the duration of the launcher go here
	weapon.PlayWeaponEffect( TITAN_SWORD_FX_LAUNCH_ATK_FP, TITAN_SWORD_FX_LAUNCH_ATK_3P, "blade_mid" )
}

void function TitanSword_Launcher_ClearMods( entity weapon )
{
	weapon.RemoveMod( TITAN_SWORD_LAUNCHER_MOD )
}

//Launcher

/* LAUNCHER NOTES

- Sliding into the uppercut is AWESOME
- Game auto brings you out of crouch/slide - it shouldn't do that
- Game doesn't match your momentum with the attack - we probably want a smarter feeling attack on slide
- Feels really chunky which is awesome
- Would like to retain some of the forward momentum
- Maybe add some hover to the top of the leap

*/
bool function TitanSword_Launcher_TryLauncher( entity player, entity weapon )
{
	#if CLIENT
		if ( !InPrediction() || !IsFirstTimePredicted() )
			return false
	#endif

	if ( !player.IsOnGround() )
		return false

	if ( !TitanSword_TryUseFuel( player ) )
		return false

	printt( "TRYING LAUNCHER" )

	TitanSword_SafelyAddAttackMod( weapon, TITAN_SWORD_LAUNCHER_MOD )

	TitanSword_Launcher_StartVFX( weapon )

	thread Launcher_Thread( player, weapon )
	//CodeCallback_OnMeleePressed( player, weapon )

	return true
}

void function Launcher_Thread( entity player, entity weapon )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	weapon.EndSignal( "OnDestroy" )
	//If we somehow put away the sword before the attack is over, stop the launch
	weapon.EndSignal( SIG_TITAN_SWORD_DEACTIVATE )

	#if CLIENT
	if ( TitanSword_ClientPredictCheck( "launcher" ) )
	{
		EmitSoundOnEntity( player, SFX_TITAN_SWORD_LAUNCH_1P )
	}
	#endif

	wait 0.35 //We should use some frame data for this I think

	#if SERVER
		thread TitanSword_LaunchPlayer_Thread( player )
	#endif
}

#if SERVER
void function TitanSword_LaunchPlayer_Thread( entity player )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( SIG_TITAN_SWORD_SLAM_ACTIVATED )


	array<entity> movementEffects
	TitanSword_CreateJetDriveJetEffects( player, VFX_TITAN_SWORD_LAUNCHER_JETS, movementEffects )
	PlayImpactFXTable( player.GetOrigin(), player, VFX_TITAN_SWORD_LAUNCHER_TAKEOFF_IMPACT )

	OnThreadEnd(
		function() : ( player, movementEffects )
		{
			if ( IsValid( player ) )
			{
				player.DisableSlowMo()
			}
			foreach ( entity effect in movementEffects )
			{
				if ( IsValid( effect ) )
					EffectStop( effect )
			}
		}
	)

	wait 0.1

	printt( "SHOULD LAUNCH NOW" )

	//player.EnableSlowMo()

	//float velZ        = GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "launcher_vel_z" )
	//vector currentVel = player.GetVelocity()

	//player.PlayerLaunch( <currentVel.x, currentVel.y, velZ>, false )
	wait 0.5

	while( !player.IsOnGround() )
	{
		WaitFrame()
	}
}
#endif

void function TitanSword_Launcher_TryLauncherAnimEvent( entity weapon )
{
	#if CLIENT
		if ( !InPrediction() || !IsFirstTimePredicted() )
			return
	#endif

	if ( !weapon.HasMod( TITAN_SWORD_LAUNCHER_MOD ) )
		return

	printt( "LAUNCHING" )

	entity player = weapon.GetWeaponOwner()

	if ( !IsValid( player ) )
		return

	player.EnableSlowMo()

	float velZ        = GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "launcher_vel_z" )
	vector currentVel = player.GetVelocity()

	//player.PlayerLaunch( <currentVel.x, currentVel.y, velZ>, false )
}


#if SERVER
void function TitanSword_OnDamageDealt( entity victim, var damageInfo )
{
	entity attacker = DamageInfo_GetAttacker( damageInfo )

	if ( !IsValid( attacker ) )
		return

	if ( !IsValid( victim ) )
		return

	/*if ( !victim.IsOnGround() )
	{
		thread AirComboVelocity_Thread( victim, <0, 0, 400> )
	}
	//Trying an enemy step type thing where you bounce if jumping - not sure if I want this to happen all the time
	if ( !attacker.IsOnGround() )
	{
		thread AirComboVelocity_Thread( attacker, <0, 0, 350> )
	}*/
	TitanSword_SlamHit_OnDamageDealt( attacker, victim, damageInfo )

	if ( DamageInfo_GetDamageSourceIdentifier( damageInfo ) == eDamageSourceId.mp_weapon_titan_sword_slam )
	{
		TitanSword_Slam_OnDamageDealt ( attacker, victim, damageInfo )
	}

	if ( !TitanSword_Super_IsActive( attacker ) )
	{
		if ( !victim.IsPlayer() && !IsTrainingDummie( victim ) && !IsCombatNPC( victim ) )
			return

		if ( GetCurrentPlaylistVarBool( "titan_sword_no_bleedout", true ) )
		{
			if ( Bleedout_IsBleedingOut( victim ) )
				return
		}

		float damage = DamageInfo_GetDamage( damageInfo )
		TitanSword_Super_AddCharge( attacker, int(damage) )
	}
}
#endif


bool function TitanSword_Launcher_VictimHitOverride( entity weapon, entity attacker, entity victim, vector velocity )
{
	if ( weapon.HasMod( TITAN_SWORD_LAUNCHER_MOD ) )
	{
		if ( !IsFriendlyTeam( attacker.GetTeam(), victim.GetTeam() ) )
		{
			float velZ = GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "launcher_vel_z" )
			TitanSword_LaunchEntity( victim, <0, 0, velZ> )
			return true
		}
	}

	return false
}

void function TitanSword_Launcher_AirControl( entity player )
{
	if ( !IsValid( player ) )
		return

	player.kv.airSpeed        = 300
	player.kv.airAcceleration = 1000

	//player.kv.airSpeed        = player.GetPlayerSettingFloat( "airSpeed" )
	//player.kv.airAcceleration = player.GetPlayerSettingFloat( "airAcceleration" )
}

                               
