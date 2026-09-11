// Bridge lobby: Continue connects to the local dedi; leave is client disconnect.

global function Bridge_MainMenuContinue
global function Bridge_ConnectToDedi
global function Bridge_LeaveMatchToLobby
global function Bridge_GetConnectHost
global function Bridge_GetConnectKey
global function Bridge_SetConnectTarget
global function Bridge_SetConnectKey
global function Bridge_BuildConnectAddress
global function Bridge_IsIdentityReady
global function Bridge_IsOfflineLaunch
global function Bridge_ShowOfflineJoinError

// Mirrors PlatformIdentityState_t in the SDK. Keep in step.
global enum ePlatformIdentity
{
	NOT_REQUIRED = 0,
	PENDING = 1,
	READY = 2,
	SLOW = 3
}

const string BRIDGE_DEFAULT_CONNECT_HOST = "127.0.0.1"
const string BRIDGE_DEFAULT_CONNECT_PORT = "37015"
const string BRIDGE_DEFAULT_CONNECT_KEY = ""
const string BRIDGE_DEFAULT_LOBBY_MAP = "mp_lobby"
const float BRIDGE_CONNECT_TIMEOUT = 20.0

struct
{
	bool isWorking = false
	// host or host:port from main-menu fields; empty means default.
	string connectTarget = ""
	// net_setKey value from main-menu field; empty skips net_setKey.
	string connectKey = ""
} file

// A server verifies the account before it lets anyone in, and the proof is issued
// a moment after launch. Offering an action that cannot succeed yet is the thing
// worth avoiding, so the menu waits on this rather than letting a connect fail.
bool function Bridge_IsIdentityReady()
{
	int state = GetPlatformIdentityState()
	return state == ePlatformIdentity.READY || state == ePlatformIdentity.NOT_REQUIRED
}

bool function Bridge_IsOfflineLaunch()
{
	return GetPlatformIdentityState() == ePlatformIdentity.NOT_REQUIRED
}

bool function Bridge_IsLoopbackHost( string host )
{
	if ( host == "" || host.find( "localhost" ) == 0 )
		return true
	if ( host.find( "127." ) == 0 )
		return true
	if ( host.find( "[::1]" ) == 0 || host == "::1" )
		return true
	return false
}

void function Bridge_ShowOfflineJoinError()
{
	ConfirmDialogData data
	data.headerText = "#ERROR"
	data.messageText = "#BRIDGE_SB_OFFLINE_JOIN"
	OpenOKDialogFromData( data )
	EmitUISound( "menu_deny" )
}

// host, host:port, or empty (default 127.0.0.1:37015).
void function Bridge_SetConnectTarget( string target )
{
	file.connectTarget = target
}

string function Bridge_GetConnectHost()
{
	if ( file.connectTarget != "" )
		return file.connectTarget

	return BRIDGE_DEFAULT_CONNECT_HOST + ":" + BRIDGE_DEFAULT_CONNECT_PORT
}

void function Bridge_SetConnectKey( string key )
{
	file.connectKey = key
}

string function Bridge_GetConnectKey()
{
	if ( file.connectKey != "" )
		return file.connectKey

	return BRIDGE_DEFAULT_CONNECT_KEY
}

// Build host:port for bridge_connect. If host already has a single :port, port is ignored.
string function Bridge_BuildConnectAddress( string host, string port )
{
	if ( host == "" )
		host = BRIDGE_DEFAULT_CONNECT_HOST
	if ( port == "" )
		port = BRIDGE_DEFAULT_CONNECT_PORT

	// Keep explicit host:port as-is (single unbracketed colon).
	if ( host.find( ":" ) != -1 )
		return host

	return host + ":" + port
}

void function Bridge_MainMenuContinue()
{
	if ( file.isWorking )
		return

	if ( !IsEULAAccepted() )
	{
		OpenEULADialog( false )
		return
	}

	Bridge_ConnectToDedi()
}

// Spinner outlives the async connect. File-local functions must be defined above their caller.
void function Bridge_ConnectAndShowProgress()
{
	EndSignal( uiGlobal.signalDummy, "EndPrelaunchValidation" )

	OnThreadEnd(
		void function() : ()
		{
			file.isWorking = false
		}
	)

	SetLaunchState( eLaunchState.WORKING, "", "" )
	Bridge_SetAuthMessage( Localize( "#BRIDGE_CONNECTING" ) )

	string host = Bridge_GetConnectHost()
	string key = Bridge_GetConnectKey()

	if ( Bridge_IsOfflineLaunch() && !Bridge_IsLoopbackHost( host ) )
	{
		file.isWorking = false
		Bridge_SetAuthMessage( "" )
		SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#BRIDGE_SB_OFFLINE_JOIN" ), Localize( "#MAINMENU_BROWSE_SERVERS" ) )
		Bridge_ShowOfflineJoinError()
		return
	}

	// bridge_connect -> v_Cmd_Dispatch(connect) (UI ClientCommand("connect") is blocked).
	if ( key.len() > 0 )
		ClientCommand( "net_setKey " + key )

	printt( "[BRIDGE] connect target=" + host + " key_set=" + ( key.len() > 0 ? "1" : "0" ) )
	ClientCommand( "bridge_connect " + host )

	float giveUpTime = UITime() + BRIDGE_CONNECT_TIMEOUT

	while ( UITime() < giveUpTime )
	{
		if ( IsConnected() )
			return

		WaitFrame()
	}

	Bridge_SetAuthMessage( "" )
	SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#BRIDGE_CONNECT_FAILED_HINT_BROWSE" ), Localize( "#MAINMENU_BROWSE_SERVERS" ) )
}

void function Bridge_ConnectToDedi()
{
	if ( file.isWorking )
		return

	file.isWorking = true
	thread Bridge_ConnectAndShowProgress()
}

// No listen-server lobby on the bridge -- leave is a client disconnect.
void function Bridge_LeaveMatchToLobby()
{
	if ( !IsConnected() )
		return

	ClientCommand( "disconnect" )
}
