// Rotating chat announcements.
// Edit platform/datatable/chat_announcements.csv for text, color, and timings.
// One-off from the GAME console:
//   chat_announce restarting in 5 min
//   chat_announce red restarting in 5 min

global function ChatAnnounce_Init
global function ChatAnnounce_Broadcast
global function ChatAnnounce_ToPlayer
global function ChatAnnounce_Say
global function ChatSeg
global function ChatSegRainbow

const float CHATANNOUNCE_DEFAULT_SUSTAIN = 8.0
const float CHATANNOUNCE_DEFAULT_FADE = 2.0
const float CHATANNOUNCE_DEFAULT_ROTATE_WAIT = 60.0
const float CHATANNOUNCE_DEFAULT_WELCOME_WAIT = 10.0
const float CHATANNOUNCE_MIN_WAIT = 5.0
const int CHATANNOUNCE_MAX_SEG_TEXT = 64

const string CHATANNOUNCE_TABLE = "datatable/chat_announcements.rpak"

const int CHATANNOUNCE_TAG_R = 120
const int CHATANNOUNCE_TAG_G = 200
const int CHATANNOUNCE_TAG_B = 255

const int CHATANNOUNCE_BODY_R = 235
const int CHATANNOUNCE_BODY_G = 235
const int CHATANNOUNCE_BODY_B = 235

struct
{
	bool started = false
	int nextIndex = 0
	array< array<table> > messages
	array<float> messageWait
	array<table> welcome
	float welcomeWait = 10.0
} file

table function ChatSeg( string text, int r = CHATANNOUNCE_BODY_R, int g = CHATANNOUNCE_BODY_G, int b = CHATANNOUNCE_BODY_B, bool newline = true, float sustain = 0.0, float fade = 0.0 )
{
	return {
		text = text,
		r = r,
		g = g,
		b = b,
		rainbow = false,
		newline = newline,
		sustain = sustain,
		fade = fade
	}
}

table function ChatSegRainbow( string text, bool newline = true, float sustain = 0.0, float fade = 0.0 )
{
	return {
		text = text,
		r = 255,
		g = 255,
		b = 255,
		rainbow = true,
		newline = newline,
		sustain = sustain,
		fade = fade
	}
}

table function ChatAnnounce_Tag( string tag, float sustain = CHATANNOUNCE_DEFAULT_SUSTAIN, float fade = CHATANNOUNCE_DEFAULT_FADE )
{
	return ChatSeg( tag, CHATANNOUNCE_TAG_R, CHATANNOUNCE_TAG_G, CHATANNOUNCE_TAG_B, true, sustain, fade )
}

string function ChatAnnounce_Clip( string text )
{
	if ( text.len() <= CHATANNOUNCE_MAX_SEG_TEXT )
		return text

	printt( "[ChatAnnounce] truncated to " + CHATANNOUNCE_MAX_SEG_TEXT + " chars: " + text )
	return text.slice( 0, CHATANNOUNCE_MAX_SEG_TEXT )
}

array<int> function ChatAnnounce_ColorRGB( string color )
{
	array<int> rgb = [ CHATANNOUNCE_BODY_R, CHATANNOUNCE_BODY_G, CHATANNOUNCE_BODY_B ]

	string c = strip( color ).tolower()
	if ( c == "" || c == "white" )
		return rgb
	if ( c == "red" )
		return [ 255, 80, 80 ]
	if ( c == "gold" )
		return [ 255, 200, 80 ]
	if ( c == "green" )
		return [ 80, 220, 120 ]
	if ( c == "cyan" )
		return [ 120, 200, 255 ]

	array<string> parts = split( c, " " )
	if ( parts.len() == 3 )
	{
		rgb[0] = parts[0].tointeger()
		rgb[1] = parts[1].tointeger()
		rgb[2] = parts[2].tointeger()
	}

	return rgb
}

bool function ChatAnnounce_IsRainbow( string color )
{
	return strip( color ).tolower() == "rainbow"
}

array<table> function ChatAnnounce_RowToSegments( string tag, string text, string color, float sustain = CHATANNOUNCE_DEFAULT_SUSTAIN, float fade = CHATANNOUNCE_DEFAULT_FADE )
{
	array<table> segs
	tag = strip( tag )
	text = rstrip( text )

	if ( tag == "" && strip( text ) == "" )
		return segs

	if ( tag != "" && tag.slice( tag.len() - 1 ) != " " )
		tag += " "

	if ( sustain < 1.0 )
		sustain = CHATANNOUNCE_DEFAULT_SUSTAIN
	if ( fade < 0.1 )
		fade = CHATANNOUNCE_DEFAULT_FADE

	bool rainbow = ChatAnnounce_IsRainbow( color )
	array<int> rgb = ChatAnnounce_ColorRGB( color )
	int r = rgb[0]
	int g = rgb[1]
	int b = rgb[2]

	if ( tag != "" )
		segs.append( ChatAnnounce_Tag( ChatAnnounce_Clip( tag ), sustain, fade ) )

	if ( text != "" )
	{
		bool newline = ( tag == "" )
		string clipped = ChatAnnounce_Clip( text )
		if ( rainbow )
			segs.append( ChatSegRainbow( clipped, newline, sustain, fade ) )
		else
			segs.append( ChatSeg( clipped, r, g, b, newline, sustain, fade ) )
	}

	return segs
}

float function ChatAnnounce_CellFloat( var dt, int row, int col, float fallback )
{
	if ( col < 0 )
		return fallback

	float v = 0.0
	try
	{
		v = GetDataTableFloat( dt, row, col )
	}
	catch ( eFloat )
	{
		return fallback
	}

	if ( v <= 0.0 )
		return fallback

	return v
}

void function ChatAnnounce_LoadFallback()
{
	file.messages.clear()
	file.messageWait.clear()
	file.welcome.clear()
	file.welcomeWait = CHATANNOUNCE_DEFAULT_WELCOME_WAIT

	file.messages.append( ChatAnnounce_RowToSegments( "[Cafe]", "Have fun and be respectful.", "" ) )
	file.messageWait.append( CHATANNOUNCE_DEFAULT_ROTATE_WAIT )
	file.messages.append( ChatAnnounce_RowToSegments( "[Cafe]", "Join the community at play.r5flowstate.org", "" ) )
	file.messageWait.append( CHATANNOUNCE_DEFAULT_ROTATE_WAIT )
	file.welcome = ChatAnnounce_RowToSegments( "", "Welcome to Cafe FPS. Good luck out there.", "green" )
}

void function ChatAnnounce_LoadFromTable()
{
	file.messages.clear()
	file.messageWait.clear()
	file.welcome.clear()
	file.welcomeWait = CHATANNOUNCE_DEFAULT_WELCOME_WAIT

	var dt = null
	try
	{
		asset tableAsset = GetKeyValueAsAsset( { kn = CHATANNOUNCE_TABLE }, "kn" )
		dt = GetDataTable( tableAsset )
	}
	catch ( eLoad )
	{
		printt( "[ChatAnnounce] GetDataTable failed path=" + CHATANNOUNCE_TABLE + " err=" + eLoad )
		ChatAnnounce_LoadFallback()
		return
	}

	if ( dt == null )
	{
		printt( "[ChatAnnounce] GetDataTable null path=" + CHATANNOUNCE_TABLE )
		ChatAnnounce_LoadFallback()
		return
	}

	int colKind = GetDataTableColumnByName( dt, "kind" )
	int colTag = GetDataTableColumnByName( dt, "tag" )
	int colText = GetDataTableColumnByName( dt, "text" )
	int colColor = GetDataTableColumnByName( dt, "color" )
	int colSustain = GetDataTableColumnByName( dt, "sustain" )
	int colFade = GetDataTableColumnByName( dt, "fade" )
	int colWait = GetDataTableColumnByName( dt, "wait" )
	if ( colKind < 0 || colText < 0 )
	{
		printt( "[ChatAnnounce] csv needs kind and text columns" )
		ChatAnnounce_LoadFallback()
		return
	}

	int rows = GetDataTableRowCount( dt )
	for ( int r = 0; r < rows; r++ )
	{
		string kind = ""
		string tag = ""
		string text = ""
		string color = ""
		try
		{
			kind = strip( GetDataTableString( dt, r, colKind ) ).tolower()
			text = GetDataTableString( dt, r, colText )
			if ( colTag >= 0 )
				tag = GetDataTableString( dt, r, colTag )
			if ( colColor >= 0 )
				color = GetDataTableString( dt, r, colColor )
		}
		catch ( eRow )
		{
			continue
		}

		float sustain = ChatAnnounce_CellFloat( dt, r, colSustain, CHATANNOUNCE_DEFAULT_SUSTAIN )
		float fade = ChatAnnounce_CellFloat( dt, r, colFade, CHATANNOUNCE_DEFAULT_FADE )
		array<table> segs = ChatAnnounce_RowToSegments( tag, text, color, sustain, fade )
		if ( segs.len() == 0 )
			continue

		if ( kind == "welcome" )
		{
			if ( file.welcome.len() + segs.len() > 8 )
			{
				printt( "[ChatAnnounce] welcome exceeds 8 segments -- dropping the tail" )
				continue
			}
			if ( file.welcome.len() == 0 )
				file.welcomeWait = ChatAnnounce_CellFloat( dt, r, colWait, CHATANNOUNCE_DEFAULT_WELCOME_WAIT )
			if ( file.welcome.len() > 0 && strip( tag ) == "" )
			{
				for ( int i = 0; i < segs.len(); i++ )
					segs[i].newline = false
			}
			file.welcome.extend( segs )
			continue
		}

		if ( kind == "rotate" || kind == "loop" || kind == "msg" )
		{
			file.messages.append( segs )
			file.messageWait.append( ChatAnnounce_CellFloat( dt, r, colWait, CHATANNOUNCE_DEFAULT_ROTATE_WAIT ) )
			continue
		}

		printt( "[ChatAnnounce] unknown kind '" + kind + "' row=" + r )
	}

	if ( file.messages.len() == 0 )
	{
		printt( "[ChatAnnounce] csv had no rotate rows -- using fallback" )
		ChatAnnounce_LoadFallback()
		return
	}

	printt( "[ChatAnnounce] loaded " + file.messages.len() + " rotate, " + file.welcome.len() + " welcome segs, welcomeWait=" + file.welcomeWait )
}

void function ChatAnnounce_Init()
{
	if ( file.started )
		return

	file.started = true
	ChatAnnounce_LoadFromTable()

	AddCallback_OnClientConnected( ChatAnnounce_OnClientConnected )
	AddClientCommandCallback( "chat_announce", ChatAnnounce_ClientCommand )

	thread ChatAnnounce_Loop()
}

void function ChatAnnounce_Broadcast( array<table> segments )
{
	if ( !GetConVarBool( "bridge_chat_announce" ) )
		return

	if ( segments.len() == 0 )
		return

	printt( "[ChatAnnounce] broadcast segs=" + segments.len() )

	array<entity> players = GetPlayerArray()
	foreach ( entity p in players )
		ChatAnnounce_ToPlayer( p, segments )
}

void function ChatAnnounce_ClientCommand( entity player, array<string> args )
{
	if ( !IsValid( player ) || !player.IsPlayer() )
		return

	if ( GetConVarInt( "sv_cheats" ) != 1 && !IsAdmin( player ) )
	{
		printt( format( "[ChatAnnounce] denied from %s", player.GetPlayerName() ) )
		return
	}

	if ( args.len() == 0 )
	{
		printt( "[ChatAnnounce] usage: chat_announce [color] text..." )
		return
	}

	string color = ""
	int start = 0
	string first = args[0].tolower()
	if ( first == "red" || first == "gold" || first == "green" || first == "cyan" || first == "white" || first == "rainbow" )
	{
		color = first
		start = 1
	}

	if ( start >= args.len() )
	{
		printt( "[ChatAnnounce] usage: chat_announce [color] text..." )
		return
	}

	string text = args[start]
	for ( int i = start + 1; i < args.len(); i++ )
		text += " " + args[i]

	printt( "[ChatAnnounce] cmd from " + player + " color='" + color + "' text='" + text + "'" )
	ChatAnnounce_Say( text, color )
}

void function ChatAnnounce_ToPlayer( entity player, array<table> segments )
{
	if ( !IsValid( player ) || !player.IsPlayer() || segments.len() == 0 )
		return

	player.ChatBuilder( segments )
}

void function ChatAnnounce_Say( string text, string color = "", string tag = "[Cafe]" )
{
	printt( "[ChatAnnounce] Say tag='" + tag + "' color='" + color + "' text='" + text + "'" )
	ChatAnnounce_Broadcast( ChatAnnounce_RowToSegments( tag, text, color ) )
}

void function ChatAnnounce_Loop()
{
	if ( file.messages.len() == 0 )
		return

	bool sentOne = false

	for ( ;; )
	{
		if ( sentOne )
		{
			int waitIdx = file.nextIndex - 1
			if ( waitIdx < 0 )
				waitIdx = file.messageWait.len() - 1
			float interval = CHATANNOUNCE_DEFAULT_ROTATE_WAIT
			if ( waitIdx >= 0 && waitIdx < file.messageWait.len() )
				interval = file.messageWait[ waitIdx ]
			if ( interval < CHATANNOUNCE_MIN_WAIT )
				interval = CHATANNOUNCE_MIN_WAIT
			wait interval
		}
		else
		{
			wait CHATANNOUNCE_MIN_WAIT
		}

		if ( !GetConVarBool( "bridge_chat_announce" ) )
			continue

		if ( GetPlayerArray().len() == 0 )
			continue

		if ( file.nextIndex >= file.messages.len() )
			file.nextIndex = 0

		printt( "[ChatAnnounce] rotate " + ( file.nextIndex + 1 ) + "/" + file.messages.len() )
		ChatAnnounce_Broadcast( file.messages[ file.nextIndex ] )
		file.nextIndex++
		sentOne = true
	}
}

void function ChatAnnounce_OnClientConnected( entity player )
{
	if ( !GetConVarBool( "bridge_chat_announce" ) )
		return

	if ( file.welcome.len() == 0 )
		return

	if ( !IsValid( player ) || !player.IsPlayer() )
		return

	thread ChatAnnounce_WelcomeDelayed( player )
}

void function ChatAnnounce_WelcomeDelayed( entity player )
{
	EndSignal( player, "OnDestroy" )

	float delay = file.welcomeWait
	if ( delay < 1.0 )
		delay = CHATANNOUNCE_DEFAULT_WELCOME_WAIT

	wait delay

	if ( !GetConVarBool( "bridge_chat_announce" ) )
		return

	if ( file.welcome.len() == 0 )
		return

	ChatAnnounce_ToPlayer( player, file.welcome )
}
