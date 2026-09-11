// Guarantees devmenu shortcuts resolve in `script` console snippets on the dedi.
// Keep this file minimal so it cannot fail to load.

globalize_all_functions

#if SERVER
array<entity> function gp()
{
	return GetPlayerArray()
}

// Console helpers (prefer DevMenu Cafe Mods > Player Models).
// ClientCommand path: cafeplayermodel amogus|pete|clear (issuer-bound).
void function PortBatch_ApplyBody( asset mdl, string tag )
{
	array<entity> players = GetPlayerArray()
	if ( players.len() < 1 )
	{
		printt( "[" + tag + "] no players" )
		return
	}

	entity p = players[0]
	p.SetBodyModelOverride( mdl )
	printt( "[" + tag + "] applied model=", p.GetModelName(), " alive=", IsAlive( p ) )
}

void function AmogusApply()
{
	PortBatch_ApplyBody( $"mdl/Humans/pilots/w_amogino.rmdl", "AMOGUS" )
}

void function PortBatch_Pete()
{
	// Body only -- SetArmsModelOverride(ptpov_pete) AVs client.
	PortBatch_ApplyBody( $"mdl/w_pete_mri.rmdl", "PETE" )
}

void function PortBatch_Raygun()
{
	printt( "[RAYGUN] parked -- models not in common_flowstate" )
}

// void function PortBatch_Phantom()
// {
// 	PortBatch_ApplyBody( $"mdl/Humans/pilots/w_phantom.rmdl", "PHANTOM" )
// }
//
// void function PortBatch_Rhapsody()
// {
// 	PortBatch_ApplyBody( $"mdl/Humans/pilots/w_rhapsody.rmdl", "RHAPSODY" )
// }
//
// void function PortBatch_Marvin()
// {
// 	PortBatch_ApplyBody( $"mdl/flowstate_custom/w_marvin.rmdl", "MARVIN" )
// }
#endif
