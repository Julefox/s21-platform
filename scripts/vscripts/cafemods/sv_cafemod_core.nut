// Server CafeMod registry: enable/disable runtime script mutators.
// Control: ClientCommand "cafemod ..." + DevMenu. Server owns truth.

global function CafeMod_ServerInit
global function CafeMod_IsEnabled
global function CafeMod_SetEnabled
global function CafeMod_Toggle
global function CafeMod_Register
global function CafeMod_RegisterPackage
global function CafeMod_GetBitfield
global function CafeMod_SyncToPlayer
global function CafeMod_SyncToAll
global function CafeMod_DisableAll
global function CafeMod_CanSpawnEntities
global function CafeMod_CountByScriptName

struct CafeModEntry
{
	string id
	string name
	bool enabled
	bool registered
	void functionref() onEnable = null
	void functionref() onDisable = null
}

struct CafeModPendingPackage
{
	string id
	string name
	void functionref() onEnable = null
	void functionref() onDisable = null
	bool defaultEnabled = false
}

struct
{
	array<CafeModEntry> mods
	array<CafeModPendingPackage> pendingPackages
	bool inited = false
	bool cmdBound = false
	float edictWarnTime = 0.0
} file

const int CAFEMOD_EDICT_HEADROOM = 512
const int CAFEMOD_EDICT_MAX_FALLBACK = 16384

void function CafeMod_ServerInit()
{
	if ( file.inited )
		return
	file.inited = true

	int count = CafeMod_GetCount()
	file.mods.resize( count )
	for ( int i = 0; i < count; i++ )
	{
		CafeModEntry e
		e.id = CafeMod_GetId( i )
		e.name = CafeMod_GetName( i )
		e.enabled = false
		e.registered = false
		e.onEnable = null
		e.onDisable = null
		file.mods[i] = e
	}

	if ( !file.cmdBound )
	{
		AddClientCommandCallback( "cafemod", CafeMod_ClientCommand )
		file.cmdBound = true
	}

	array<CafeModPendingPackage> pending
	int pendingCount = file.pendingPackages.len()
	for ( int i = 0; i < pendingCount; i++ )
		pending.append( file.pendingPackages[i] )
	file.pendingPackages.clear()
	for ( int i = 0; i < pending.len(); i++ )
	{
		CafeModPendingPackage p = pending[i]
		CafeMod_RegisterPackage( p.id, p.name, p.onEnable, p.onDisable, p.defaultEnabled )
	}

	printt( format( "[CafeMod] ServerInit slots=%d total=%d", count, CafeMod_GetTotalCount() ) )
}

// Mods call this from their Init after CafeMod_ServerInit.
void function CafeMod_Register( string id, void functionref() onEnable, void functionref() onDisable, bool defaultEnabled = false )
{
	if ( !file.inited )
		CafeMod_ServerInit()

	int index = CafeMod_FindIndex( id )
	if ( index < 0 )
	{
		printt( format( "[CafeMod] Register REJECT unknown id='%s' (add slot in sh_cafemod_defs)", id ) )
		return
	}

	CafeModEntry e = file.mods[index]
	e.registered = true
	e.onEnable = onEnable
	e.onDisable = onDisable
	file.mods[index] = e

	printt( format( "[CafeMod] Register id=%s idx=%d default=%s", e.id, index, string( defaultEnabled ) ) )

	if ( defaultEnabled && !e.enabled )
		CafeMod_SetEnabled( e.id, true, null )
}

bool function CafeMod_IsPackageIdChar( int ch )
{
	if ( ch >= 48 && ch <= 57 )
		return true
	if ( ch >= 65 && ch <= 90 )
		return true
	if ( ch >= 97 && ch <= 122 )
		return true
	if ( ch == 95 || ch == 45 )
		return true
	return false
}

bool function CafeMod_IsPackageId( string id )
{
	if ( id.len() < 1 || id.len() > 64 )
		return false

	for ( int i = 0; i < id.len(); i++ )
	{
		int ch = expect int( id[i] ) & 0xFF
		if ( !CafeMod_IsPackageIdChar( ch ) )
			return false
	}
	return true
}

void function CafeMod_EnsureSlot( int idx, string id, string name )
{
	while ( file.mods.len() <= idx )
	{
		CafeModEntry blank
		blank.id = ""
		blank.name = ""
		blank.enabled = false
		blank.registered = false
		blank.onEnable = null
		blank.onDisable = null
		file.mods.append( blank )
	}

	CafeModEntry e = file.mods[idx]
	e.id = id
	e.name = name
	file.mods[idx] = e
}

void function CafeMod_RegisterPackage( string id, string name, void functionref() onEnable, void functionref() onDisable, bool defaultEnabled )
{
	string key = id.tolower()
	if ( !CafeMod_IsPackageId( key ) )
	{
		printt( format( "[CafeMod] RegisterPackage REJECT bad id='%s'", id ) )
		return
	}

	string label = name
	if ( label == "" )
		label = key
	if ( label.len() > 255 )
		label = label.slice( 0, 255 )

	if ( !file.inited )
	{
		CafeModPendingPackage p
		p.id = key
		p.name = label
		p.onEnable = onEnable
		p.onDisable = onDisable
		p.defaultEnabled = defaultEnabled
		file.pendingPackages.append( p )
		printt( format( "[CafeMod] RegisterPackage queued id=%s", key ) )
		return
	}

	int existing = CafeMod_FindIndex( key )
	if ( existing >= 0 && existing < CafeMod_GetCount() )
	{
		printt( format( "[CafeMod] RegisterPackage REJECT id='%s' is a built-in slot", key ) )
		return
	}

	int idx = existing
	if ( idx < 0 )
	{
		idx = CafeMod_GetTotalCount()
		if ( idx < 0 || idx >= CAFEMOD_MAX )
		{
			printt( format( "[CafeMod] WARNING: RegisterPackage id='%s' ignored -- 32 slot ceiling", key ) )
			return
		}

		CafeMod_DefineDynamic( idx, key, label )
		CafeMod_EnsureSlot( idx, key, label )
	}
	else
	{
		CafeMod_DefineDynamic( idx, key, label )
		CafeMod_EnsureSlot( idx, key, label )
	}

	if ( idx < 0 || idx >= file.mods.len() )
	{
		printt( format( "[CafeMod] RegisterPackage REJECT id='%s' idx=%d", key, idx ) )
		return
	}

	CafeModEntry e = file.mods[idx]
	e.registered = true
	e.onEnable = onEnable
	e.onDisable = onDisable
	file.mods[idx] = e

	printt( format( "[CafeMod] RegisterPackage id=%s idx=%d default=%s", e.id, idx, string( defaultEnabled ) ) )

	if ( defaultEnabled && !e.enabled )
		CafeMod_SetEnabled( e.id, true, null )
	else
		CafeMod_SyncToAll()
}

int function CafeMod_CountByScriptName( string scriptName )
{
	if ( scriptName == "" )
		return 0

	array<entity> ents = GetEntArrayByScriptName( scriptName )
	int count = 0
	foreach ( entity e in ents )
	{
		if ( IsValid( e ) )
			count++
	}
	return count
}

bool function CafeMod_CanSpawnEntities( int extra = 8 )
{
	if ( extra < 1 )
		extra = 1

	int used = -1
	int maxEdicts = CAFEMOD_EDICT_MAX_FALLBACK
	try
	{
		used = GetEdictUsed()
		maxEdicts = GetEdictMax()
	}
	catch ( e )
	{
		used = -1
	}

	if ( used < 0 )
		return true

	if ( used + extra < maxEdicts - CAFEMOD_EDICT_HEADROOM )
		return true

	float now = Time()
	if ( now - file.edictWarnTime > 2.0 )
	{
		file.edictWarnTime = now
		printt( format( "[CafeMod] edict cap used=%d max=%d extra=%d -- skip spawn", used, maxEdicts, extra ) )
	}
	return false
}

bool function CafeMod_IsEnabled( string id )
{
	if ( !file.inited )
		return false

	int index = CafeMod_FindIndex( id )
	if ( index < 0 || index >= file.mods.len() )
		return false

	return file.mods[index].enabled
}

bool function CafeMod_SetEnabled( string id, bool on, entity issuer = null )
{
	if ( !file.inited )
		CafeMod_ServerInit()

	int index = CafeMod_FindIndex( id )
	if ( index < 0 || index >= file.mods.len() )
	{
		printt( format( "[CafeMod] SetEnabled unknown id='%s'", id ) )
		return false
	}

	CafeModEntry e = file.mods[index]
	if ( !e.registered )
	{
		printt( format( "[CafeMod] SetEnabled id=%s not registered yet", id ) )
		return false
	}

	if ( e.enabled == on )
		return true

	e.enabled = on
	file.mods[index] = e

	string who = "console"
	if ( IsValid( issuer ) && issuer.IsPlayer() )
		who = issuer.GetPlayerName()

	if ( on )
	{
		printt( format( "[CafeMod] ENABLE %s by %s", e.id, who ) )
		if ( e.onEnable != null )
			e.onEnable()
	}
	else
	{
		printt( format( "[CafeMod] DISABLE %s by %s", e.id, who ) )
		if ( e.onDisable != null )
			e.onDisable()
	}

	CafeMod_SyncToAll()
	return true
}

bool function CafeMod_Toggle( string id, entity issuer = null )
{
	return CafeMod_SetEnabled( id, !CafeMod_IsEnabled( id ), issuer )
}

int function CafeMod_GetBitfield()
{
	int bits = 0
	if ( !file.inited )
		return 0

	int n = file.mods.len()
	if ( n > CAFEMOD_MAX )
		n = CAFEMOD_MAX
	for ( int i = 0; i < n; i++ )
	{
		if ( file.mods[i].enabled )
			bits = bits | CafeMod_BitForIndex( i )
	}
	return bits
}

void function CafeMod_SyncDefsToPlayer( entity player )
{
	// Dynamic slot labels are resolved on the client from its own installed mod
	// list; the remote function API carries no string arguments.
}

void function CafeMod_SyncToPlayer( entity player )
{
	if ( !IsValid( player ) || !player.IsPlayer() )
		return

	CafeMod_SyncDefsToPlayer( player )
	Remote_CallFunction_NonReplay( player, "CafeMod_CL_SyncState", CafeMod_GetBitfield() )
}

void function CafeMod_SyncToAll()
{
	array<entity> players = GetPlayerArray()
	int bits = CafeMod_GetBitfield()
	foreach ( entity player in players )
	{
		if ( !IsValid( player ) || !player.IsPlayer() )
			continue
		CafeMod_SyncDefsToPlayer( player )
		Remote_CallFunction_NonReplay( player, "CafeMod_CL_SyncState", bits )
	}
}

void function CafeMod_DisableAll( entity issuer = null )
{
	if ( !file.inited )
		return

	for ( int i = 0; i < file.mods.len(); i++ )
	{
		if ( file.mods[i].enabled )
			CafeMod_SetEnabled( file.mods[i].id, false, issuer )
	}
}

void function CafeMod_ClientCommand( entity player, array<string> args )
{
	if ( !IsValid( player ) || !player.IsPlayer() )
		return

	if ( args.len() < 1 )
	{
		printt( "[CafeMod] usage: cafemod sync|list|enable|disable|toggle|disable_all [id]" )
		return
	}

	string action = args[0].tolower()

	// Read-only, so never gated -- a dropped sync strands the DevMenu labels.
	if ( action == "sync" )
	{
		CafeMod_SyncToPlayer( player )
		return
	}

	// A refused action still answers, otherwise the UI's optimistic flip stands forever.
	if ( !GetConVarBool( "sv_cheats" ) )
	{
		printt( format( "[CafeMod] denied (sv_cheats 0) '%s' from %s", action, player.GetPlayerName() ) )
		CafeMod_SyncToPlayer( player )
		return
	}

	if ( action == "list" )
	{
		printt( "[CafeMod] --- list ---" )
		for ( int i = 0; i < file.mods.len(); i++ )
		{
			CafeModEntry e = file.mods[i]
			printt( format( "[CafeMod]  [%d] %s (%s) en=%s reg=%s",
				i, e.id, e.name, string( e.enabled ), string( e.registered ) ) )
		}
		return
	}

	if ( action == "disable_all" )
	{
		CafeMod_DisableAll( player )
		CafeMod_SyncToPlayer( player )
		return
	}

	if ( args.len() < 2 )
	{
		printt( format( "[CafeMod] %s needs <id>", action ) )
		return
	}

	string id = args[1].tolower()
	if ( !CafeMod_IsPackageId( id ) )
	{
		printt( format( "[CafeMod] rejected id '%s'", id ) )
		CafeMod_SyncToPlayer( player )
		return
	}

	if ( action == "enable" )
	{
		CafeMod_SetEnabled( id, true, player )
		CafeMod_SyncToPlayer( player )
		return
	}

	if ( action == "disable" )
	{
		CafeMod_SetEnabled( id, false, player )
		CafeMod_SyncToPlayer( player )
		return
	}

	if ( action == "toggle" )
	{
		CafeMod_Toggle( id, player )
		CafeMod_SyncToPlayer( player )
		return
	}

	printt( format( "[CafeMod] unknown action '%s'", action ) )
}
