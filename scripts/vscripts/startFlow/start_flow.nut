//-----------------
//This is a new file being created to slowly refactor sh_character_select_new.gnut
//that file has grown too bloated and is controlling a lot more than just the character select part of the flow
//If you have any questions please reach out to Tarek Chaya @tchaya
//-----------------
global function SquadMuteLegendSelectEnabled

bool function SquadMuteLegendSelectEnabled()
{
	return GetCurrentPlaylistVarBool( "squad_mute_legend_select_enable", true )
}
