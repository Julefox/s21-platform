                      

global function MpAbilityCopycatKit_Init
global function CopycatKit_LootPickedUp
global function CopycatKit_LootDropped

#if CLIENT
global function CopycatKitChargePercent_Think
global function ServerCallback_PickupError
#endif

global const string COPYCAT_MOD = "copycat_mod"
global const string COPYCAT_NAME = "mp_ability_copycat_kit"
global const string COPYCAT_ABORT = "copycat_abort"

//Look into converting seperate weapon files into one parent/multiple children with mods

void function MpAbilityCopycatKit_Init()
{

	Remote_RegisterClientFunction( "ServerCallback_PickupError", "entity" )
	RegisterSignal( COPYCAT_ABORT )


	#if SERVER
		Loot_AddCallback_OnPlayerLootPickup( CopycatKit_LootPickedUp )
		//Loot_AddCallback_OnPlayerDropEquipment ( CopycatKit_LootDropped )
	#endif

	#if CLIENT || UI
		AddCallback_EditLootDesc( EditCopycatKitLootDescription )
	#endif
}


void function CopycatKit_LootPickedUp ( entity player, entity pickup, string ref, int unitsPickedUp, bool willDestroy, entity deathBox, int pickupFlags )
{
	if ( ref.find( COPYCAT_NAME ) != 0 )
		return

	string kitAbilityRef = GetWeaponInfoFileKeyField_GlobalString ( ref, "disguise_ability" )

	if (kitAbilityRef == "")
		return

	array<entity> offhandWeapons = player.GetOffhandWeapons()

	//Legends can't wear a costume of themselves. Drop the kit after picking up + error message.
	//No longer necessary as GroundAction_ForEquipment() stops the player from picking the item up
	//but keeping in as a fallback just incase someone forces a kit onto themselves in some way
	foreach (offhand in offhandWeapons)
	{
		if (kitAbilityRef == offhand.GetWeaponClassName())
		{
			#if SERVER
				SURVIVAL_DropPlayerEquipment( player, "gadgetslot" )
				Remote_CallFunction_Replay( player, "ServerCallback_PickupError", player )
			#endif
			return
		}
	}

	#if SERVER
		//Replace slot 7 with new costume ability
		player.TakeOffhandWeapon( OFFHAND_GENERIC )
		player.GiveOffhandWeapon( kitAbilityRef , OFFHAND_GENERIC )
	#endif

	entity costumeWeapon = player.GetOffhandWeapon( OFFHAND_GENERIC )

	//Add mod for audio/VFX/SFX changes
	costumeWeapon.AddMod( COPYCAT_MOD )

	#if SERVER
		//Ability charge is stored on the player. Check the players charge and give it to the new ability.

		bool IsUltimateWeapon = IsBitFlagSet( costumeWeapon.GetWeaponTypeFlags(), WPT_ULTIMATE )
		int abilityChargeMax = costumeWeapon.GetWeaponPrimaryClipCountMax()
		float chargeToGive = abilityChargeMax * player.p.copycatTactCharge

		if ( IsUltimateWeapon )
			chargeToGive = abilityChargeMax * player.p.copycatUltCharge

		costumeWeapon.SetWeaponPrimaryClipCount( chargeToGive )
	#endif
}


void function CopycatKit_LootDropped (entity player, string equipSlot, string equipRef, entity droppedEnt)
{

	droppedEnt.Signal( COPYCAT_ABORT )

	#if SERVER
		if ( equipRef.find( COPYCAT_NAME ) != 0 )
			return

		entity costumeWeapon 		= player.GetOffhandWeapon( OFFHAND_GENERIC )

		if ( !IsValid(costumeWeapon) )
			return

		string costumeWeaponName 	= costumeWeapon.GetWeaponClassName()
		string kitAbilityRef		= GetWeaponInfoFileKeyField_GlobalString ( equipRef, "disguise_ability" )

		if (kitAbilityRef == costumeWeaponName)
		{
			bool IsUltimateWeapon = IsBitFlagSet( costumeWeapon.GetWeaponTypeFlags(), WPT_ULTIMATE )
			int ammoCount = costumeWeapon.GetWeaponPrimaryClipCount()
			float percent = float(ammoCount) / costumeWeapon.GetWeaponPrimaryClipCountMax()

			if (IsUltimateWeapon)
			{
				player.p.copycatUltCharge = clamp ( percent, 0.0, 0.8 )
			}
			else
			{
				player.p.copycatTactCharge = clamp ( percent, 0.0, 0.8 )
			}
		}

		player.TakeOffhandWeapon( OFFHAND_GENERIC )
		player.GiveOffhandWeapon( GENERIC_OFFHAND_WEAPON_NAME , OFFHAND_GENERIC )
	#endif

}

void function ServerCallback_PickupError ( entity player )
{
	#if CLIENT
		AnnouncementMessageRight( GetLocalClientPlayer(), Localize( "#SURVIVAL_PICKUP_COPYCAT_KIT_DUPE_LEGEND_ERROR" ), "", <1, 0, 0>, $"", 1.0, "survival_ui_ability_notready" )
	#endif
}


void function CopycatKitChargePercent_Think( entity player, entity weapon )
{
	AssertIsNewThread()
	player.EndSignal( "OnDeath" )
	weapon.EndSignal( "OnDestroy" )

#if CLIENT
	var dpadMenuRui = GetDpadMenuRui()

	RuiSetBool( dpadMenuRui, "gadgetUIEnabled", true )
	RuiSetBool( dpadMenuRui, "gadgetChargeUIEnabled", true )

	entity doppelWeapon 		= player.GetOffhandWeapon( OFFHAND_GENERIC )
	int ammoMinToFire 			= doppelWeapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
	float regenAmmoRate			= doppelWeapon.GetWeaponSettingFloat( eWeaponVar.regen_ammo_refill_rate )
	string kitAbilityRef		= GetWeaponInfoFileKeyField_GlobalString ( weapon.GetWeaponClassName(), "disguise_ability" )

	if ( kitAbilityRef != doppelWeapon.GetWeaponClassName())
		return

	while( true )
	{
		if ( IsValid( doppelWeapon ) && dpadMenuRui != null )
		{
			float tier1ChargeTimePercent = float( doppelWeapon.GetWeaponPrimaryClipCount() ) / float( doppelWeapon.GetWeaponPrimaryClipCountMax() ) * 100
			int tier1roundedPercent      = int( tier1ChargeTimePercent )

			RuiSetString( dpadMenuRui, "gadgetChargePercent", Localize( "#N_PERCENT", tier1roundedPercent ) )
			RuiSetFloat( dpadMenuRui, "gadgetChargeFrac", tier1ChargeTimePercent / 100.0 )
			RuiSetInt( dpadMenuRui, "ammoMinToFire", ammoMinToFire )
			RuiSetFloat( dpadMenuRui, "ammoRefillRate", regenAmmoRate )
		}
		WaitFrame()
	}
#endif
}


#if CLIENT || UI
string function EditCopycatKitLootDescription( string lootRef, entity player, string originalDesc )
{
	string finalDesc = originalDesc

	if ( lootRef.find( COPYCAT_NAME ) == 0)
	{
		string kitAbilityRef = GetWeaponInfoFileKeyField_GlobalString ( lootRef, "disguise_ability" )

		string kitDescription = GetWeaponInfoFileKeyField_GlobalString ( lootRef, "description" )
		string copiedAbilityDescription

		if (lootRef == "mp_ability_copycat_kit_mirage_holopilot" )
		copiedAbilityDescription = Localize("#SURVIVAL_PICKUP_COPYCAT_KIT_HOLOPILOT_DESC")
		else
		copiedAbilityDescription = GetWeaponInfoFileKeyField_GlobalString ( kitAbilityRef, "description" )

		finalDesc =  Localize(kitDescription) + "\n \n" +  Localize(copiedAbilityDescription)
	}

	return finalDesc
}
#endif

                           
