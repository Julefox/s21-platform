// Client half of the Lab armory. The loot table lives in this VM, so the UI
// asks here for the catalog and for the icon on each visible tile.

global function Lab_RequestCategories
global function Lab_RequestCatalog
global function Lab_SetTileIcon

// Engine loot-type strings, in the order they read best in the picker. A
// category with nothing in this build's loot table is dropped before it ships
// to the UI, so the list always matches what the server can actually give.
const string LAB_CATEGORY_KEYS = "ammo,attachment,armor,helmet,backpack,incapshield,ordnance,health evo_pickup,gadget data_knife marvin_arm custom_pickup"
const array<string> LAB_CATEGORY_TOKENS = [
	"LAB_CAT_AMMO",
	"LAB_CAT_ATTACH",
	"LAB_CAT_ARMOR",
	"LAB_CAT_HELMET",
	"LAB_CAT_BACKPACK",
	"LAB_CAT_INCAP",
	"LAB_CAT_ORDNANCE",
	"LAB_CAT_HEAL",
	"LAB_CAT_MISC",
]

// Localized display label for a category key, with the English shipping text
// as the fallback when a language table has no entry yet.
string function Lab_CategoryLabel( int index )
{
	array<string> fallback = [
		"Ammo",
		"Attachments",
		"Armor",
		"Helmets",
		"Backpacks",
		"Knockdown Shields",
		"Ordnance",
		"Healing",
		"Other Items",
	]

	if ( index < 0 || index >= LAB_CATEGORY_TOKENS.len() )
		return index >= 0 && index < fallback.len() ? fallback[index] : ""

	string loc = Localize( "#" + LAB_CATEGORY_TOKENS[index] )
	if ( loc != "" )
		return loc

	return index < fallback.len() ? fallback[index] : ""
}

void function Lab_RequestCategories()
{
	array<string> keys = split( LAB_CATEGORY_KEYS, "," )

	array<string> liveKeys
	array<string> liveLabels

	for ( int i = 0; i < keys.len(); i++ )
	{
		if ( Lab_CountItemsInCategory( keys[i] ) == 0 )
			continue

		liveKeys.append( keys[i] )
		liveLabels.append( Lab_CategoryLabel( i ) )
	}

	RunUIScript( "LabArmory_SetCategories", Lab_Join( liveKeys ), Lab_Join( liveLabels ) )
}

string function Lab_Join( array<string> parts )
{
	string out = ""
	foreach ( int i, string part in parts )
	{
		if ( i > 0 )
			out += ","
		out += part
	}
	return out
}

array<int> function Lab_CategoryTypes( string categoryKey )
{
	array<int> types
	foreach ( string word in split( categoryKey, WHITESPACE_CHARACTERS ) )
	{
		if ( word == "" )
			continue
		types.append( SURVIVAL_Loot_GetLootTypeFromString( word ) )
	}
	return types
}

int function Lab_CountItemsInCategory( string categoryKey )
{
	array<int> types = Lab_CategoryTypes( categoryKey )
	int count = 0

	foreach ( ref, data in SURVIVAL_Loot_GetLootDataTable() )
	{
		if ( !IsLootTypeValid( data.lootType ) )
			continue
		if ( !types.contains( data.lootType ) )
			continue
		count++
	}

	return count
}

void function Lab_RequestCatalog( string categoryKey )
{
	array<int> types = Lab_CategoryTypes( categoryKey )

	RunUIScript( "LabArmory_CatalogBegin", categoryKey )

	table< string, LootData > lootTable = SURVIVAL_Loot_GetLootDataTable()

	array<string> refs
	foreach ( ref, data in lootTable )
	{
		if ( !IsLootTypeValid( data.lootType ) )
			continue
		if ( !types.contains( data.lootType ) )
			continue
		refs.append( ref )
	}

	refs.sort( int function ( string a, string b ) : ( lootTable )
	{
		LootData da = lootTable[a]
		LootData db = lootTable[b]

		if ( da.tier != db.tier )
			return da.tier < db.tier ? -1 : 1

		string na = Localize( da.pickupString )
		string nb = Localize( db.pickupString )
		if ( na < nb )
			return -1
		if ( na > nb )
			return 1
		return 0
	} )

	foreach ( string ref in refs )
	{
		LootData data = lootTable[ ref ]

		string display = Localize( data.pickupString )
		if ( display == "" )
			display = ref

		RunUIScript( "LabArmory_CatalogRow", ref, display, data.tier )
	}

	RunUIScript( "LabArmory_CatalogEnd", categoryKey )
}

// The UI owns the tile; only this VM can resolve the icon asset behind a ref.
void function Lab_SetTileIcon( var tile, string kind, string ref, int tier )
{
	var rui = Hud_GetRui( tile )
	if ( rui == null )
		return

	asset icon = $""
	int lootTier = tier

	if ( kind == "weapon" )
	{
		icon = GetWeaponInfoFileKeyFieldAsset_Global( ref, "hud_icon" )
	}
	else
	{
		table< string, LootData > lootTable = SURVIVAL_Loot_GetLootDataTable()
		if ( ref in lootTable )
		{
			LootData data = lootTable[ ref ]
			icon = data.hudIcon
			lootTier = data.tier
		}
	}

	RuiSetImage( rui, "iconImage", icon )
	RuiSetInt( rui, "lootTier", lootTier )
	RuiSetInt( rui, "count", 0 )
	RuiSetInt( rui, "maxCount", 0 )
	RuiSetBool( rui, "isInfinite", false )
	RuiSetBool( rui, "brackerGradientEnabled", false )
}
