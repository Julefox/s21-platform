// Cafe DevMenu: SetBodyModelOverride only. SetArmsModelOverride AVs the client.

global function CafeMod_PlayerModels_Init

const string PM_VER = "v4-bodyonly"

// Prefer studiohdr szname paths; long aliases also packed.
const asset PM_BODY_AMOGUS = $"mdl/Humans/pilots/w_amogino.rmdl"
const asset PM_BODY_PETE   = $"mdl/w_pete_mri.rmdl"

struct
{
	bool cmdBound = false
} file

void function CafeMod_PlayerModels_Init()
{
	PrecacheModel( PM_BODY_AMOGUS )
	PrecacheModel( PM_BODY_PETE )
	// Alias path still used by older call sites / GetModelName noise.
	PrecacheModel( $"mdl/flowstate_custom/w_pete_mri.rmdl" )

	if ( !file.cmdBound )
	{
		AddClientCommandCallback( "cafeplayermodel", CafePlayerModel_ClientCommand )
		file.cmdBound = true
	}

	printt( format( "[CafeMod] player_models %s ready (amogus|pete|clear BODY ONLY)", PM_VER ) )
}

void function CafePlayerModel_ClientCommand( entity player, array<string> args )
{
	if ( !IsValid( player ) || !player.IsPlayer() )
		return
	if ( !GetConVarBool( "sv_cheats" ) )
	{
		printt( format( "[CafePlayerModel] denied (sv_cheats 0) from %s", player.GetPlayerName() ) )
		return
	}

	if ( args.len() < 1 )
	{
		printt( "[CafePlayerModel] usage: cafeplayermodel amogus|pete|clear" )
		return
	}

	string id = args[0].tolower()
	CafePlayerModel_Apply( player, id )
}

void function CafePlayerModel_Apply( entity player, string id )
{
	if ( !IsValid( player ) || !player.IsPlayer() )
		return

	player.SetSkin( 0 )

	if ( id == "clear" || id == "none" || id == "default" || id == "off" )
	{
		// Body clear only -- empty arms override was a risk surface.
		player.SetBodyModelOverride( $"" )
		printt( format( "[CafePlayerModel] %s %s CLEAR body", PM_VER, player.GetPlayerName() ) )
		return
	}

	if ( id == "amogus" || id == "amogino" )
	{
		player.SetBodyModelOverride( PM_BODY_AMOGUS )
		printt( "[CafePlayerModel]", PM_VER, player.GetPlayerName(), "AMOGUS", player.GetModelName() )
		return
	}

	if ( id == "pete" || id == "mri" || id == "pete_mri" )
	{
		// BODY ONLY. SetArmsModelOverride(ptpov_pete_mri) AVs the client.
		player.SetBodyModelOverride( PM_BODY_PETE )
		printt( "[CafePlayerModel]", PM_VER, player.GetPlayerName(), "PETE arms-skipped", player.GetModelName() )
		return
	}

	printt( format( "[CafePlayerModel] %s unknown id='%s'", PM_VER, id ) )
}
