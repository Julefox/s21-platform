                      
global function Candy_Init

const int	CANDY_EVO_POINTS_DEFAULT = 75
const int   CANDY_SHIELD_HEAL = 25
const float	CANDY_SHIELD_HEAL_DURATION = 4.0
const float	CANDY_ULT_CHARGE = 20

const bool CANDY_GIVE_SPEED = false
const bool CANDY_GIVE_ULTIMATE = true

const asset CANDY_SHIELD_CHARGE_FX = $"P_armor_3P_loop_CP"

const asset CANDY_PICKUP_SCREEN_FX = $"P_candy_boost_1p"
const float CANDY_PICKUP_SCREEN_FX_DURATION = 0.5

const asset CANDY_PICKUP_WORLD_FX = $"P_candy_pickup_3p"

const string CANDY_PICKUP_SHIELD_CHARGE_SFX_1P = "Survival_Loot_Pickup_Candy_Charging_1P"
const string CANDY_PICKUP_SHIELD_CHARGE_SFX_3P = "Survival_Loot_Pickup_Candy_Charging_3P"
const string CANDY_PICKUP_SHIELD_CHARGE_END_SFX_1P = "Survival_Loot_Pickup_Candy_Charging_Ending_1P"
const string CANDY_PICKUP_SHIELD_CHARGE_END_SFX_3P = "Survival_Loot_Pickup_Candy_Charging_Ending_3P"

const int   CANDY_SHIELD_CHARGE_END_TRIGGER_AMOUNT = 3

void function Candy_Init()
{
	PrecacheParticleSystem( CANDY_SHIELD_CHARGE_FX )
	PrecacheParticleSystem( CANDY_PICKUP_SCREEN_FX )
	PrecacheParticleSystem( CANDY_PICKUP_WORLD_FX )

	RegisterCustomItemPickupAction( "candy_pickup", Candy_ItemPickup )

	RegisterSignal( "OnShieldDamaged" )
	#if SERVER
		AddCallback_OnPlayerShieldDamage( Candy_OnShieldDamaged )
	#endif
}

bool function Candy_ItemPickup( entity pickup, entity player, int pickupFlags, entity deathBox, int ornull desiredCount, LootData data )
{
	//Check for playlist override
	int EVO_Reward = GetPlaylistVarInt( GetCurrentPlaylistName(), "candy_evo_points", CANDY_EVO_POINTS_DEFAULT )
	int SHIELD_Reward = GetPlaylistVarInt( GetCurrentPlaylistName(), "candy_shield_heal", CANDY_SHIELD_HEAL )
	int ULT_Reward = GetPlaylistVarInt( GetCurrentPlaylistName(), "candy_ult_charge", CANDY_ULT_CHARGE )
	float DURATION_Reward = GetPlaylistVarFloat( GetCurrentPlaylistName(), "candy_duration", CANDY_SHIELD_HEAL_DURATION )

	bool Candy_Give_Ultimate = GetPlaylistVarBool( GetCurrentPlaylistName(), "candy_give_ultimate", CANDY_GIVE_ULTIMATE )

	#if SERVER
		//Give EVO Points and start Shield Regen
		EvolvingArmor_ApplyEvoPoints( player, EVO_Reward)

		if ( player.GetShieldHealth() != player.GetShieldHealthMax() )
			thread Candy_ShieldRegen_Think( player, SHIELD_Reward, DURATION_Reward )

		//GiveHealthAndShieldToPlayerSimultaneously (player,0,CANDY_SHIELD_HEAL)

		//Ultimate Charge Reward
		if (Candy_Give_Ultimate)
			Candy_UltimateCharge(player, ULT_Reward)
	#endif

	#if CLIENT
		//On screen pop up for EVO points
		if (player == GetLocalClientPlayer())
		{
			AnnouncementMessageRight( GetLocalClientPlayer(), "EVO: +" + EVO_Reward + "\nULT: +" + ULT_Reward + "%", "", <0, 1, 0>, $"", 1.0 )

			//In World VFX
			int fxIndex = GetParticleSystemIndex( CANDY_PICKUP_WORLD_FX )
			StartParticleEffectInWorld( fxIndex, pickup.GetOrigin(), <0, 0, 0> )
		}

		//ScreenFX
		thread Candy_ScreenFx( player )
	#endif

	return true
}

#if CLIENT
void function Candy_ScreenFx ( entity player )
{
	EndSignal( player, "OnDeath", "OnDestroy" )

	int candyScreenFxHandle

	if ( player != GetLocalViewPlayer() )
		return

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	if ( EffectDoesExist( candyScreenFxHandle ) )
		return

	int fxID = GetParticleSystemIndex( CANDY_PICKUP_SCREEN_FX )
	candyScreenFxHandle = StartParticleEffectOnEntity( cockpit, fxID, FX_PATTACH_ABSORIGIN_FOLLOW, ATTACHMENTID_INVALID )
	EffectSetIsWithCockpit( candyScreenFxHandle, true )
	EffectSetControlPointVector( candyScreenFxHandle, 1, <255, 208, 56> )

	OnThreadEnd( function() : ( candyScreenFxHandle )
	{
		if ( EffectDoesExist( candyScreenFxHandle ) )
			EffectStop( candyScreenFxHandle, false, true )
	} )

	wait CANDY_PICKUP_SCREEN_FX_DURATION
}
#endif


#if SERVER
void function Candy_UltimateCharge(entity player, int amount)
{
	entity ultWeapon = player.GetOffhandWeapon( OFFHAND_ULTIMATE )

	if ( !IsValid( ultWeapon ) )
		return

	int oldAmmo = ultWeapon.GetWeaponPrimaryClipCount()
	int ammoMax = ultWeapon.GetWeaponPrimaryClipCountMax()
	int newAmmoRaw = (oldAmmo + ( ammoMax * amount / 100) )
	int newAmmo = minint( newAmmoRaw, ammoMax )

	ultWeapon.SetWeaponPrimaryClipCountNoRegenReset( newAmmo )

	if ( (newAmmo > oldAmmo) && (newAmmo >= ammoMax) )
		Ultimates_OnPlayerUltIsReady( player, ultWeapon )
}
#endif

#if SERVER
void function Candy_ShieldRegen_Think ( entity target, int shieldHealing, float time )
{
	EndSignal( target, "OnDeath" )
	EndSignal( target, "OnDestroy" )
	target.EndSignal( "OnDamaged" )
	target.EndSignal( "OnShieldDamaged" )

	//Particle stuff
	int attachID         = target.LookupAttachment( "CHESTFOCUS" )
	int shieldChargeFXID = GetParticleSystemIndex( CANDY_SHIELD_CHARGE_FX )
	entity fxEnt         = StartParticleEffectOnEntity_ReturnEntity( target, shieldChargeFXID, FX_PATTACH_POINT_FOLLOW, attachID )

	fxEnt.SetOwner( target )
	fxEnt.SetVisibilityFlags( ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY )

	int armorTier = EquipmentSlot_GetEquipmentTier( target, "armor" )
	vector shieldColor = GetFXRarityColorForTier( armorTier )

	EffectSetControlPointVector( fxEnt, 2, shieldColor )

	EmitSoundOnEntityOnlyToPlayer( target, target, CANDY_PICKUP_SHIELD_CHARGE_SFX_1P )
	EmitSoundOnEntityExceptToPlayer( target, target, CANDY_PICKUP_SHIELD_CHARGE_SFX_3P )

	OnThreadEnd(
		function() : ( fxEnt, target )
		{
			StopSoundOnEntity( target, CANDY_PICKUP_SHIELD_CHARGE_SFX_1P )
			StopSoundOnEntity( target, CANDY_PICKUP_SHIELD_CHARGE_SFX_3P )

			if ( IsValid( fxEnt ) )
				EffectStop( fxEnt )
		}
	)

	//Shield regen logic
	float startTime = Time()
	float shieldHealingApplied
	float completionFrac
	bool endPlayed = false

	while ( completionFrac < 1 )
	{
		if ( !IsValid( target ) )
			return

		//End early if shield health is full
		if ( target.GetShieldHealth() == target.GetShieldHealthMax() )
		{
			StopSoundOnEntity( target, CANDY_PICKUP_SHIELD_CHARGE_SFX_1P )
			break
		}
		completionFrac = Clamp ( (Time() - startTime) / time, 0.0, 1.0)
		float timeElapsed = Time() - startTime

		int shieldsToAdd = int(( completionFrac * shieldHealing ) - shieldHealingApplied )
		shieldHealingApplied = shieldHealingApplied + shieldsToAdd

		GiveHealthAndShieldToPlayerSimultaneously (target, 0, shieldsToAdd)

		int possibleHealingLeft =  target.GetShieldHealthMax() - target.GetShieldHealth()

		//Stop the audio loop 0.5 seconds before the healing is completed. 3 health out of the 25 healing is around 0.5 seconds worth of healing.
		if (!endPlayed && ( ( shieldHealingApplied > shieldHealing - CANDY_SHIELD_CHARGE_END_TRIGGER_AMOUNT ) || ( possibleHealingLeft < CANDY_SHIELD_CHARGE_END_TRIGGER_AMOUNT)))
		{
			endPlayed = true
			EmitSoundOnEntityOnlyToPlayer( target, target, CANDY_PICKUP_SHIELD_CHARGE_END_SFX_1P  )
			EmitSoundOnEntityExceptToPlayer( target, target, CANDY_PICKUP_SHIELD_CHARGE_END_SFX_3P )
		}

		WaitFrame()
	}
}
#endif

#if SERVER
float function Candy_OnShieldDamaged( entity player, var damageInfo )
{
	if ( IsValid( player ) )
		player.Signal( "OnShieldDamaged" )

	return 1.0
}
#endif

                        
