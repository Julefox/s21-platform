// CafeMod fake_obits: spam fake kill-feed lines on CLIENT.
// Driven by server bitfield via CafeMod_CL_SyncState.

global function CafeMod_FakeObits_OnBitsChanged

const string CAFEMOD_FAKE_OBITS_STOP = "CafeMod_FakeObitsStop"

struct
{
	bool threadRunning = false
	bool signalRegistered = false
	array<string> names = [
		"PixelPwnz",
		"lOrdMcSnugglepants",
		"NinjaNacho",
		"BubblegumBrawler",
		"SirSassALot",
		"GlitterGunslinger",
		"CaptainCouchPotato",
		"DonutDestroyer",
		"FluffyFury",
		"MasterMemeLord",
		"SparklesMcSnark",
		"ProfessorPwnage",
		"ZombeeZapper",
		"LOLlord",
		"DarkKnightRises",
		"Stormbringer99",
		"ArchonXandros",
		"NovaSparks",
		"ValkyrieVixen",
		"ShadowAssassinX",
		"CelestialCrusader",
		"ThunderboltTitan",
		"FrostbiteFury",
		"InfernoInquisitor",
		"StarlightSentinel",
		"ByteBandit",
		"LagLord99",
		"JoystickJedi",
		"PizzaPwnz",
		"SushiSensei",
		"TacoTerror",
		"CoffeeCrusader",
		"CerealKiller",
		"WolfWarrior99",
		"EagleEye99",
		"HoneyBadgerHero",
		"PandaPwnz",
		"GuitarGuru99",
		"DJ_Dynamo",
		"SpaceInvader99",
		"DiscoDynamo",
		"RobotRampage"
	]
} file

// Called from CafeMod_CL_SyncState when bits change.
void function CafeMod_FakeObits_OnBitsChanged( int prevBits, int newBits )
{
	bool wasOn = CafeMod_IsBitSet( prevBits, CAFEMOD_IDX_FAKE_OBITS )
	bool nowOn = CafeMod_IsBitSet( newBits, CAFEMOD_IDX_FAKE_OBITS )

	if ( nowOn && !wasOn )
		CafeMod_FakeObits_Start()
	else if ( !nowOn && wasOn )
		CafeMod_FakeObits_Stop()
	else if ( nowOn && !file.threadRunning )
		CafeMod_FakeObits_Start()
}

void function CafeMod_FakeObits_Start()
{
	if ( !file.signalRegistered )
	{
		RegisterSignal( CAFEMOD_FAKE_OBITS_STOP )
		file.signalRegistered = true
	}

	CafeMod_FakeObits_Stop()

	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	printt( "[CafeMod] fake_obits ON (client kill-feed spam)" )
	file.threadRunning = true
	thread CafeMod_FakeObits_Thread( player )
}

void function CafeMod_FakeObits_Stop()
{
	if ( file.signalRegistered )
	{
		entity player = GetLocalClientPlayer()
		if ( IsValid( player ) )
			player.Signal( CAFEMOD_FAKE_OBITS_STOP )
	}
	file.threadRunning = false
}

void function CafeMod_FakeObits_Thread( entity player )
{
	EndSignal( player, "OnDestroy" )
	EndSignal( player, CAFEMOD_FAKE_OBITS_STOP )

	OnThreadEnd(
		function() : ()
		{
			file.threadRunning = false
		}
	)

	while ( CafeMod_CL_IsEnabled( "fake_obits" ) )
	{
		CafeMod_BuildFakeObituary()
		wait RandomIntRangeInclusive( 1, 10 )
	}
}

// Real eDamageSourceId weapon entries that RegisterWeaponDamageSource maps to hud_icon.
// Random ints (legacy 40-120) mostly miss damageSourceIDToImage -> empty icon / text-only.
array<int> function CafeMod_FakeObits_WeaponSourcePool()
{
	return [
		eDamageSourceId.mp_weapon_rspn101,
		eDamageSourceId.mp_weapon_vinson,
		eDamageSourceId.mp_weapon_hemlok,
		eDamageSourceId.mp_weapon_g2,
		eDamageSourceId.mp_weapon_lstar,
		eDamageSourceId.mp_weapon_lmg,
		eDamageSourceId.mp_weapon_r97,
		eDamageSourceId.mp_weapon_volt_smg,
		eDamageSourceId.mp_weapon_wingman,
		eDamageSourceId.mp_weapon_semipistol,
		eDamageSourceId.mp_weapon_autopistol,
		eDamageSourceId.mp_weapon_sniper,
		eDamageSourceId.mp_weapon_sentinel,
		eDamageSourceId.mp_weapon_dmr,
		eDamageSourceId.mp_weapon_shotgun,
		eDamageSourceId.mp_weapon_mastiff,
		eDamageSourceId.mp_weapon_shotgun_pistol,
		eDamageSourceId.mp_weapon_defender,
		eDamageSourceId.mp_weapon_frag_grenade,
		eDamageSourceId.mp_weapon_thermite_grenade,
		eDamageSourceId.mp_weapon_grenade_emp,
		eDamageSourceId.mp_weapon_energy_shotgun,
		eDamageSourceId.mp_weapon_alternator_smg,
		eDamageSourceId.mp_weapon_pdw,
		eDamageSourceId.mp_weapon_car,
		eDamageSourceId.mp_weapon_esaw,
		eDamageSourceId.mp_weapon_energy_ar,
		eDamageSourceId.mp_weapon_bow,
		eDamageSourceId.mp_weapon_3030,
		eDamageSourceId.mp_weapon_nemesis,
		eDamageSourceId.mp_weapon_doubletake,
	]
}

void function CafeMod_BuildFakeObituary()
{
	if ( file.names.len() < 2 )
		return

	string attacker = file.names.getrandom()
	file.names.removebyvalue( attacker )

	string victim = file.names.getrandom()
	file.names.removebyvalue( victim )
	file.names.append( attacker )
	file.names.append( victim )

	array<int> pool = CafeMod_FakeObits_WeaponSourcePool()
	int damageSourceId = pool[ RandomInt( pool.len() ) ]

	string sourceDisplayName = GetObitFromDamageSourceID( damageSourceId )
	asset weaponIcon = GetObitImageFromDamageSourceID( damageSourceId )

	// Fallback: loot hudIcon if RegisterWeaponDamageSource never filled the table.
	bool isMainWeapon = true
	string damageRef = ""
	if ( DamageSourceIDHasString( damageSourceId ) )
	{
		damageRef = GetRefFromDamageSourceID( damageSourceId )
		if ( weaponIcon == $"" && damageRef != "" && SURVIVAL_Loot_IsRefValid( damageRef ) )
		{
			LootData lootData = SURVIVAL_Loot_GetLootDataByRef( damageRef )
			weaponIcon = lootData.hudIcon
			isMainWeapon = lootData.lootType == eLootType.MAINWEAPON
		}
		else if ( damageRef != "" && SURVIVAL_Loot_IsRefValid( damageRef ) )
		{
			LootData lootData = SURVIVAL_Loot_GetLootDataByRef( damageRef )
			isMainWeapon = lootData.lootType == eLootType.MAINWEAPON
		}
	}

	// Last resort: pull hud_icon straight from weapon info file.
	if ( weaponIcon == $"" && damageRef != "" )
		weaponIcon = GetWeaponInfoFileKeyFieldAsset_Global( damageRef, "hud_icon" )

	string attackerString = Localize( "#OBIT_PLAYER_STRING", attacker )
	string victimString = Localize( "#OBIT_PLAYER_STRING", victim )

	asset modifierIcon = $""
	if ( CoinFlip() )
		modifierIcon = $"rui/hud/obituary/obituary_downed"
	else if ( !isMainWeapon )
		modifierIcon = $"rui/hud/obituary/obituary_headshot"
	else
		modifierIcon = $"rui/hud/obituary/obituary_headshot"

	// Stock path: icon present -> empty weaponDisplayName so RUI shows the image.
	// Text name only when no icon (rare after pool+fallbacks).
	if ( weaponIcon == $"" )
	{
		string localizedObit = Localize( "#OBIT_ENT_WEAPON_ENT", attackerString, Localize( sourceDisplayName ), victimString )
		Obituary_Print_Localized( localizedObit, <255, 255, 255>, <255, 255, 255>, <255, 255, 255> )
		return
	}

	ObitRankBadgeInfo badgeInfo
	Obituary_Print_PlayerDeath(
		attackerString,
		weaponIcon,
		"",
		modifierIcon,
		victimString,
		badgeInfo,
		<255, 255, 255>,
		<255, 255, 255>,
		<255, 255, 255>,
		isMainWeapon,
		0
	)
}
