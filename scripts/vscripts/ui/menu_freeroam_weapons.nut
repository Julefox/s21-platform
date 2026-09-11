// Freeroam Weapons -- DevMenu panel: pick tier on root, then class -> weapon -> slot.
// Open: Dev Menu -> Weapons, or FreeroamWeaponsMenu_Open().
// Always available (not #if DEVELOPER) -- content gated by DevMenu sv_cheats like legacy.

untyped

global function FreeroamWeaponsMenu_Open
global function FreeroamWeaponsMenu_SetupRoot
global function FreeroamWeaponsMenu_IsOpenReady
global function FreeroamWeaponsMenu_SetupCategory
global function FreeroamWeaponsMenu_SetupWeapon

struct
{
	string preferredTier = "gold"
} file

void function FreeroamWeaponsMenu_Open()
{
	printt( "[FreeroamWM-UI] Open Weapon Selector" )
	CloseAllMenus()
	AdvanceMenu( GetMenu( "DevMenu" ) )
	thread FreeroamWeaponsMenu_Open_Thread()
}

bool function FreeroamWeaponsMenu_IsOpenReady()
{
	return true
}

void function FreeroamWeaponsMenu_SetupRoot()
{
	FreeroamWeaponsMenu_SetupRoot_Internal()
}

void function FreeroamWeaponsMenu_Open_Thread()
{
	WaitFrame()
	WaitFrame()
	ChangeToThisMenu( FreeroamWeaponsMenu_SetupRoot )
}

void function FreeroamWeaponsMenu_SetupRoot_Internal()
{
	// First row: tier for every give until changed.
	string tierMark = file.preferredTier.slice( 0, 1 ).toupper() + file.preferredTier.slice( 1 )
	SetupDevMenu( "Tier: " + tierMark, void function( var unused ) {
		thread ChangeToThisMenu( FreeroamWeaponsMenu_SetupTier )
	} )

	array cats = FreeroamWeaponsMenu_GetCategoryWeapons()
	if ( cats.len() == 0 )
	{
		SetupDevCommand( "(no weapon categories)", "echo freeroam_wm_empty" )
		return
	}

	foreach ( catAny in cats )
	{
		table cat = expect table( catAny )
		string catId = string( cat.id )
		string catLabel = string( cat.label )
		array weapons = expect array( cat.weapons )
		string menuLabel = format( "%s (%d)", catLabel, weapons.len() )
		SetupDevMenu( menuLabel, void function( var unused ) : ( catId ) {
			thread ChangeToThisMenu( void function() : ( catId ) {
				FreeroamWeaponsMenu_SetupCategory( catId )
			} )
		} )
	}

	SetupDevCommand( "Refill Ammo", "CC_MenuGiveAimTrainerWeapon refill" )
	SetupDevCommand( "Strip Primary 0", "CC_MenuGiveAimTrainerWeapon strip 0" )
	SetupDevCommand( "Strip Primary 1", "CC_MenuGiveAimTrainerWeapon strip 1" )
}

void function FreeroamWeaponsMenu_SetupTier()
{
	array<string> tiers = [ "gold", "purple", "blue", "white" ]
	foreach ( string tier in tiers )
	{
		string label = tier.slice( 0, 1 ).toupper() + tier.slice( 1 )
		if ( tier == file.preferredTier )
			label += " *"
		SetupDevFunc( label, void function( var unused ) : ( tier ) {
			file.preferredTier = tier
			thread ChangeToThisMenu( FreeroamWeaponsMenu_SetupRoot )
		} )
	}
}

void function FreeroamWeaponsMenu_SetupCategory( var catIdVar )
{
	string catId = string( catIdVar )
	array cats = FreeroamWeaponsMenu_GetCategoryWeapons()

	foreach ( catAny in cats )
	{
		table cat = expect table( catAny )
		if ( string( cat.id ) != catId )
			continue

		array weapons = expect array( cat.weapons )
		foreach ( weaponRowAny in weapons )
		{
			table weaponRow = expect table( weaponRowAny )
			string classname = string( weaponRow.classname )
			string display = string( weaponRow.display )
			SetupDevMenu( display, void function( var unused ) : ( classname, display ) {
				string payload = classname + "|" + display
				thread ChangeToThisMenu( void function() : ( payload ) {
					FreeroamWeaponsMenu_SetupWeapon( payload )
				} )
			} )
		}
		return
	}

	SetupDevCommand( "(category empty)", "echo freeroam_wm_cat_empty" )
}

void function FreeroamWeaponsMenu_SetupWeapon( var payloadVar )
{
	string payload = string( payloadVar )
	array<string> parts = split( payload, "|" )
	string classname = parts.len() > 0 ? parts[0] : ""
	string tier = file.preferredTier

	// Cafe-only ports have no loot row; *_crate refs keep GiveKit's care-package classname.
	// Parked: raygun until packed.
	// if ( classname == "mp_weapon_raygun" )
	// {
	// 	SetupDevCommand( "Primary Slot 0",
	// 		format( "CC_MenuGiveAimTrainerWeapon free 0 %s", classname ) )
	// 	SetupDevCommand( "Primary Slot 1",
	// 		format( "CC_MenuGiveAimTrainerWeapon free 1 %s", classname ) )
	// 	return
	// }

	SetupDevCommand( "Primary Slot 0",
		format( "CC_MenuGiveAimTrainerWeapon kit 0 %s %s", classname, tier ) )
	SetupDevCommand( "Primary Slot 1",
		format( "CC_MenuGiveAimTrainerWeapon kit 1 %s %s", classname, tier ) )
}
