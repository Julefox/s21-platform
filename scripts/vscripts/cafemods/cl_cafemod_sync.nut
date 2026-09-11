// Client bridge: server bitfield -> UI DevMenu labels + client-side CafeMod_IsEnabled.

global function CafeMod_CL_SyncState
global function CafeMod_CL_ItemsState
global function CafeMod_CL_IsEnabled
global function CafeMod_CL_GetBitfield

struct
{
	int bits = 0
} file

// Dynamic slots are appended above the static table in mod load order, so the
// client rebuilds the same mapping from its own installed mods. A client whose
// mod set differs from the server's just shows the generic slot label.
void function CafeMod_CL_ResolveDynamicDefs()
{
	int idx = CafeMod_GetCount()
	foreach ( mod in ModList_Get() )
	{
		if ( idx >= CAFEMOD_MAX )
			break
		if ( !mod.enabled || !mod.hasScripts )
			continue

		CafeMod_DefineDynamic( idx, mod.id, mod.name != "" ? mod.name : mod.id )
		idx++
	}
}

void function CafeMod_CL_SyncState( int bitfield )
{
	CafeMod_CL_ResolveDynamicDefs()

	int prev = file.bits
	file.bits = bitfield
	printt( format( "[CafeMod] CL sync bits=0x%x (was 0x%x)", bitfield, prev ) )

	try
	{
		RunUIScript( "CafeMod_UI_SyncState", bitfield )
	}
	catch ( eUI )
	{
		printt( format( "[CafeMod] UI sync failed (restart client): %s", string( eUI ) ) )
	}

	// Client-only mutators react to bit flips (fake kill feed, etc.).
	CafeMod_FakeObits_OnBitsChanged( prev, bitfield )
}

// Items Weapon profile + physics mirror for DevMenu labels.
void function CafeMod_CL_ItemsState( int profileIndex, int physicsOn )
{
	printt( format( "[CafeMod] CL items profile=%d physics=%d", profileIndex, physicsOn ) )
	try
	{
		RunUIScript( "CafeMod_UI_ItemsState", profileIndex, physicsOn )
	}
	catch ( eUI )
	{
		printt( format( "[CafeMod] UI items sync failed: %s", string( eUI ) ) )
	}
}

int function CafeMod_CL_GetBitfield()
{
	return file.bits
}

bool function CafeMod_CL_IsEnabled( string id )
{
	int index = CafeMod_FindIndex( id )
	if ( index < 0 )
		return false
	return CafeMod_IsBitSet( file.bits, index )
}
