// Flowstate anti-AFK -- S21 port from scripts_old/mp/_antiafk.nut
// Spawn-hooked from _gamemode_1v1; Init from _Gamemode1v1Standalone_Init.

global function Flowstate_Afk_Init
global function Flowstate_InitAFKThreadForPlayer
global function AfkThread_PlayerMoved

struct
{
	float Flowstate_antiafk_warn
	float Flowstate_antiafk_grace
	float Flowstate_antiafk_interval

	bool flowstate_afk_kick_enable
	bool enable_afk_thread
	bool loggedInit = false

	// One SUSPICIOUS warning per idle stretch (handle -> true while warned).
	table< int, bool > afkWarned = {}
} file

enum eAntiAfkPlayerState
{
	ACTIVE
	SUSPICIOUS
	AFK
}

void function Flowstate_Afk_Init()
{
	file.Flowstate_antiafk_warn     = GetCurrentPlaylistVarFloat( "Flowstate_antiafk_warn", 15.0 )
	file.Flowstate_antiafk_grace    = GetCurrentPlaylistVarFloat( "Flowstate_antiafk_grace", bAfkToRest() ? 45.0 : 120.0 )
	file.Flowstate_antiafk_interval = GetCurrentPlaylistVarFloat( "Flowstate_antiafk_interval", 10.0 )
	file.flowstate_afk_kick_enable  = GetCurrentPlaylistVarBool( "flowstate_afk_kick_enable", true )
	file.enable_afk_thread          = GetCurrentPlaylistVarBool( "enable_afk_thread", true )

	if ( !file.loggedInit )
	{
		file.loggedInit = true
		printt( "[FS-AFK] init warn=" + string( file.Flowstate_antiafk_warn )
			+ " grace=" + string( file.Flowstate_antiafk_grace )
			+ " interval=" + string( file.Flowstate_antiafk_interval )
			+ " kick=" + string( file.flowstate_afk_kick_enable )
			+ " thread=" + string( file.enable_afk_thread )
			+ " afk_to_rest=" + string( bAfkToRest() ) )
	}
}

void function Flowstate_InitAFKThreadForPlayer( entity player )
{
	if ( !IsValid( player ) || IsAdmin( player ) || !file.flowstate_afk_kick_enable || !file.enable_afk_thread )
		return

	AfkThread_AddPlayerCallbacks( player )
	AfkThread_PlayerMoved( player )
	thread CheckAfkKickThread( player )
}

// Fixed vs R5V: kick path was dead when afk_to_rest was false (GetAfkState never left ACTIVE).
int function GetAfkState( entity player )
{
	float localgrace = file.Flowstate_antiafk_grace
	float warn = file.Flowstate_antiafk_warn
	float lastmove = player.p.lastmoved

	if ( bAfkToRest() && Gamemode1v1_IsPlayerResting( player ) )
		return eAntiAfkPlayerState.ACTIVE

	if ( Time() > lastmove + localgrace )
		return eAntiAfkPlayerState.AFK

	if ( Time() > lastmove + ( localgrace - warn ) )
		return eAntiAfkPlayerState.SUSPICIOUS

	return eAntiAfkPlayerState.ACTIVE
}

void function AfkWarning( entity player )
{
	string warnStr = string( int( file.Flowstate_antiafk_warn ) )
	if ( bAfkToRest() )
	{
		LocalMsg( player, "#FS_AFK_ALERT", "#FS_AFK_REST_MSG", eMsgUI.DEFAULT, 10.0, "", warnStr )
		LocalSplashMsg( player, "AFK warning: rest in " + warnStr + "s", 8.0 )
	}
	else
	{
		LocalMsg( player, "#FS_AFK_ALERT", "#FS_AFK_KICK_MSG", eMsgUI.DEFAULT, 10.0, "", warnStr )
		LocalSplashMsg( player, "AFK warning: kick in " + warnStr + "s", 8.0 )
	}
}

void function CheckAfkKickThread( entity player )
{
	for ( ; ; )
	{
		wait file.Flowstate_antiafk_interval

		if ( !IsValid( player ) )
			break

		if ( GetGameState() != eGameState.Playing )
			continue

		if ( !IsAlive( player ) )
			continue

		if ( player.p.isSpectating )
			continue

		if ( bAfkToRest() && Gamemode1v1_IsRestEnabled() && Gamemode1v1_IsPlayerInState( player, e1v1State.RESTING ) )
			continue

		int handle = player.p.handle

		switch ( GetAfkState( player ) )
		{
			case eAntiAfkPlayerState.ACTIVE:
				if ( handle in file.afkWarned )
					delete file.afkWarned[ handle ]
				break

			case eAntiAfkPlayerState.SUSPICIOUS:
				// One warning per continuous SUSPICIOUS stretch (interval poll used to spam every tick).
				if ( !( handle in file.afkWarned ) )
				{
					file.afkWarned[ handle ] <- true
					AfkWarning( player )
				}
				break

			case eAntiAfkPlayerState.AFK:
				if ( bAfkToRest() )
				{
					player.p.lastmoved = Time()

					if ( Gamemode1v1_IsRestEnabled() )
					{
						if ( Gamemode1v1_IsPlayerResting( player ) )
						{
							AfkThread_PlayerMoved( player )
							continue
						}

						printt( "[FS-AFK] force rest " + player.GetPlayerName() )
						Gamemode1v1_ForceRest( player )
					}
					else
					{
						Warning( "[FS-AFK] afk_to_rest enabled but rest disabled; call Gamemode1v1_SetRestEnabled()" )
					}
				}
				else
				{
					Warning( "[FS-AFK] kicking " + player.GetPlayerName() + " for AFK" )
					KickPlayerById( player.GetPlatformUID(), "You were AFK for too long" )
				}
				break

			default:
				Warning( "[FS-AFK] invalid afk state" )
				break
		}

		wait 1
	}
}

void function AfkThread_PlayerMoved( entity player )
{
	if ( !IsValid( player ) )
		return
	player.p.lastmoved = Time()
	int handle = player.p.handle
	if ( handle in file.afkWarned )
		delete file.afkWarned[ handle ]
}

void function AfkThread_AddPlayerCallbacks( entity player )
{
	AddPlayerPressedForwardCallback( player, AfkThread_PlayerMoved, 1.0 )
	AddPlayerPressedBackCallback( player, AfkThread_PlayerMoved, 1.0 )
	AddPlayerPressedLeftCallback( player, AfkThread_PlayerMoved, 1.0 )
	AddPlayerPressedRightCallback( player, AfkThread_PlayerMoved, 1.0 )
}
