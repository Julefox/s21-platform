global function OpenModsListDialog

struct ModsListRow
{
	int order
	string name
	string version
	string author
	string status
}

void function OpenModsListDialog( var button )
{
	array<ModsListRow> rows = ModsList_CollectRows()

	ConfirmDialogData data
	data.headerText = "#BRIDGE_MODS_LIST_TITLE"
	data.messageText = ModsList_BuildMessage( rows )
	OpenOKDialogFromData( data )
}

array<ModsListRow> function ModsList_CollectRows()
{
	array<ModsListRow> rows

	foreach ( mod in ModList_Get() )
	{
		ModsListRow row
		row.order   = mod.order
		row.name    = mod.name != "" ? mod.name : mod.id
		row.version = mod.version
		row.author  = mod.author
		row.status  = ModsList_Status( mod )
		rows.append( row )
	}

	rows.sort( int function( ModsListRow a, ModsListRow b ) {
		if ( a.order < b.order )
			return -1
		if ( a.order > b.order )
			return 1
		return 0
	} )

	return rows
}

string function ModsList_BuildMessage( array<ModsListRow> rows )
{
	if ( rows.len() < 1 )
		return Localize( "#BRIDGE_MODS_LIST_EMPTY" ) + "\n\n" + Localize( "#BRIDGE_MODS_LIST_HINT" )

	string body = ""
	for ( int i = 0; i < rows.len(); i++ )
	{
		ModsListRow row = rows[i]
		string line = row.name
		if ( row.version != "" )
			line += "  " + row.version
		if ( row.author != "" )
			line += "  " + row.author
		line += "  " + row.status

		if ( body != "" )
			body += "\n"
		body += line
	}

	return body + "\n\n" + Localize( "#BRIDGE_MODS_LIST_HINT" )
}

string function ModsList_Status( InstalledMod mod )
{
	if ( mod.realm.tolower() == "server" )
		return Localize( "#BRIDGE_MODS_STATUS_REALM" )

	if ( mod.enabled && mod.state.tolower() == "disabled" )
		return Localize( "#BRIDGE_MODS_STATUS_SUPPRESSED" )

	if ( mod.enabled )
		return Localize( "#BRIDGE_MODS_STATUS_ENABLED" )

	return Localize( "#BRIDGE_MODS_STATUS_DISABLED" )
}
