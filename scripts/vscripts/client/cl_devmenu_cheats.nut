// Always-CLIENT bridge for DevMenu (not gated by -dev / When DEV).
// Legacy cafe: DEV_SendCheatsStateToUI lived in always-loaded client survival scripts.
// UI calls RunClientScript( "DEV_SendDevMenuStateToUI" ) from menu_dev.SetupDefaultDevCommandsMP.

global function DEV_SendDevMenuStateToUI
global function DEV_SendCheatsStateToUI
global function ServerCallback_DevAutoRespawnOverlay
global function DevHud_ClientSet

struct
{
	bool hudHidden = false
	bool resetCb = false
} file

void function DevHud_ClientRegister()
{
	if ( file.resetCb )
		return
	file.resetCb = true
	AddCallback_UIScriptReset( DevHud_ClientOnUIScriptReset )
}

void function DevHud_ClientSet( bool hidden )
{
	file.hudHidden = hidden
	DevHud_ClientRegister()
}

void function DevHud_ClientOnUIScriptReset()
{
	RunUIScript( "DevHud_SetHidden", file.hudHidden )
}

void function DEV_SendDevMenuStateToUI()
{
	DevHud_ClientRegister()
	bool cheats = GetConVarBool( "sv_cheats" )
	bool isPlayer0 = false
	entity localPlayer = GetLocalClientPlayer()
	if ( IsValid( localPlayer ) )
	{
		array<entity> players = GetPlayerArray()
		if ( players.len() > 0 && IsValid( players[0] ) && players[0] == localPlayer )
			isPlayer0 = true
	}
	RunUIScript( "UpdateDevMenuServerState", cheats, isPlayer0 )
}

// Legacy alias name (scripts_old menu_dev).
void function DEV_SendCheatsStateToUI()
{
	DEV_SendDevMenuStateToUI()
}

// freeDM-style death-screen countdown: "RESPAWNING IN" + timer to endTime.
void function ServerCallback_DevAutoRespawnOverlay( float endTime )
{
	RunUIScript( "SetRespawnOverlayTime", Time(), endTime )
	RunUIScript( "SetRespawnOverlayString", "#RESPAWNING_IN" )
	RunUIScript( "SetRespawnOverlayIdleString", "#READY_TO_SPAWN" )
}
