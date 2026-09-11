// Flowstate 1v1. CafeFPS (makimakima, mkos).

global function endSpectate
global function GetScore
global function Gamemode1v1_SetWaitingRoomRadius
global function _CleanupPlayerEntities
global function isScenariosMode
global function Gamemode1v1_CreatePanels
global function Gamemode1v1_FetchNotificationPanelCoordinates
global function FS_1v1_HasPanelLocation
global function Gamemode1v1_FetchNotificationPanelAngles
global function BannerImages_1v1Init
global function ClearAllNotifications
global function Gamemode1v1_GetNotificationPanel_Angles
global function Gamemode1v1_GetNotificationPanel_Coordinates
global function groupRecapStats

// =====================================================================================
// Functions from other sections (UI-related)
// =====================================================================================

void function BannerImages_1v1Init()
{
	LocPair main_banner__Coordinates = NewLocPair( Gamemode1v1_FetchNotificationPanelCoordinates(), Gamemode1v1_FetchNotificationPanelAngles() )
	main_banner__Coordinates.origin = main_banner__Coordinates.origin + < 0,0,245 >

	vector testOrigin 	= main_banner__Coordinates.origin + <0,0,16> //height offset for player eyes.
	vector testAngles 	= main_banner__Coordinates.angles
	float defaultWidth 	= 480 //todo playlistvar
	float defaultHeight	= 270 //todo playlistvar

	LocPair setBannerLoc = NewLocPair( BannerAssets_BannerVisibilityMover( Gamemode1v1_GetWaitingRoomLocation().origin, Gamemode1v1_GetWaitingRoomLocation().angles, testOrigin, testAngles, defaultWidth, defaultHeight ) + < 0, 0, -100 >, testAngles )

	BannerAssets_SetAllGroupsFunc
	(
		void function() : ( setBannerLoc, defaultWidth, defaultHeight )
		{
			BannerAssets_RegisterGroup
			(
				"main_banner",
				setBannerLoc,
				defaultWidth,
				defaultHeight,
				.95,
				5
			)
		}
	)

	BannerAssets_SetAllAssetsFunc
	(
		void function()
		{
			try
			{
				string assetList = GetCurrentPlaylistVarString( "banner_assets", "" )

				if( !empty( assetList ) )
				{
					array<string> playlistBannerAssets = StringToArray( assetList )

					foreach( assetRef in playlistBannerAssets )
					{
						int refID = WorldDrawAsset_AssetRefToID( assetRef )

						if( refID != -1 )
						{
							BannerAssets_GroupAppendAsset
							(
								"main_banner",
								refID
							)
						}
						else
						{
							sqerror( format( "Invalid BannerAsset. Skipping asset: '%s'", assetRef ) )
						}
					}
				}
			}
			catch(e)
			{
				sqerror( "[1v1:BannerInit] " + e )
			}
		}
	)

	BannerAssets_Init()

	FS_1v1_WorldBanner_StoreAndBroadcast( setBannerLoc.origin, setBannerLoc.angles, defaultWidth, defaultHeight )
}

void function endSpectate(entity player)
{
	FS_1v1_ForgetSpectatorRealm( player )
	FS_SetRealmForPlayer( player, 0 )
	player.SetSpecReplayDelay( 0 )
	player.SetObserverTarget( null )
	player.StopObserverMode()
	// Remote_CallFunction_NonReplay( player, "ServerCallback_KillReplayHud_Deactivate" ) //(cafe)not used atm revisit
    player.MakeVisible()

	try
	{
		player.Die( null, null, { damageSourceId = eDamageSourceId.damagedef_despawn } )
	}
	catch (error)
	{
		#if DEVELOPER
			sqerror( "[1v1:EndSpectate] " + error )
		#endif
	}

    RemoveButtonPressedPlayerInputCallback(player, IN_JUMP,endSpectate)
	Gamemode1v1_SetPlayerGamestate( player, e1v1State.RESTING )
	FS_1v1_ApplyLobbyLoadout( player )

	// Update resting panels with new counts (spectating -> resting)
	FS_1v1_RequestRestingNotificationRefresh()
}

void function Gamemode1v1_SetWaitingRoomRadius( float radius )
{
	if ( radius < 400.0 )
		radius = DEFAULT_WAITING_ROOM_RADIUS.tofloat()
	file.waitingRoomRadius = radius
}

//used for information display
string function GetScore( entity player )
{
	if ( !IsValid( player ) )
		return "INVALID_PLAYER"

	float lt_kd = getkd( (player.GetPlayerNetInt( "kills" ) + player.p.season_kills) , (player.GetPlayerNetInt( "deaths" ) + player.p.season_deaths) )
	float cur_kd = getkd( player.GetPlayerNetInt( "kills" ) , player.GetPlayerNetInt( "deaths" )  )
	float score = (  ( lt_kd * file.season_kd_weight ) + ( cur_kd * file.current_kd_weight ) )
	return format( "Player: %s, season KD: %.2f, Current KD: %.2f, Round Score: %.2f ", player.p.name, lt_kd, cur_kd, score )
}

void function _CleanupPlayerEntities( entity player )
{
	if ( !IsValid( player ) )
		return

	PROTO_CleanupTrackedProjectiles( player )
	player.Signal( "CleanUpPlayerAbilities" )
}

bool function isScenariosMode()
{
	return settings.isScenariosMode
}

// =====================================================================================
// SECTION 17: UI & NOTIFICATIONS
// User interface and notification systems
// =====================================================================================

// ChallengeNotificationsThread moved to _1v1_challenge.nut

void function ClearAllNotifications()
{
	foreach ( player in GetPlayerArray() )
	{
		if( !IsValid( player ) )
			continue

		ClearNotifications( player )
	}
}

void function Gamemode1v1_CreatePanels( vector origin, vector angles, table<string, entity> panels )
{
	angles =  < ceil( angles.x ), ceil( angles.y ), ( angles.z * 0 ) >
	vector baseAngles = angles - <0,90,0> //Normalize( angles )

	array<string> keys = []

	foreach ( title, panelEntity in panels )
		keys.append( title )

	float FORWARD_OFFSET = 40
	float SIDE_OFFSET = 100
	float SIDE_ANGLE_ADJUST = 40
	float FAR_OFFSET_INITIAL = 120
	float RIGHT_OFFSET_INITIAL = 80
	float POSITION_INCREMENT = 60

	int panelCount = keys.len()
	vector panelPos
	vector panelAngle

	for ( int i = 0; i < panelCount; ++i )
	{
		if ( i < 2 )
		{
			panelPos = origin + AnglesToForward( baseAngles ) * FORWARD_OFFSET * ( i % 2 == 0 ? 1 : -1 )
			panelAngle = baseAngles
		}
		else if ( i < 4 )
		{
			panelPos = origin + AnglesToForward( baseAngles ) * SIDE_OFFSET * ( i % 2 == 0 ? -1 : 1 ) + AnglesToRight( baseAngles ) * 25
			panelAngle = baseAngles + <0, SIDE_ANGLE_ADJUST * ( i % 2 == 0 ? 1 : -1 ), 0>
		}
		else
		{
			int groupIndex = ( i - 4 ) / 2
			float rightOffset = RIGHT_OFFSET_INITIAL + POSITION_INCREMENT * groupIndex;
			panelPos = origin + AnglesToForward( baseAngles ) * FAR_OFFSET_INITIAL * ( i % 2 == 0 ? -1 : 1 ) + AnglesToRight( baseAngles ) * rightOffset
			panelAngle = baseAngles + <0, 90 * ( i % 2 == 0 ? 1 : -1 ), 0>
		}

		entity panel = CreateFRButton( panelPos, panelAngle, keys[i] )
		panels[ keys[i] ] = panel
	}
}

vector function Gamemode1v1_FetchNotificationPanelAngles()
{
	return file.notificationPanel_Angles
}

vector function Gamemode1v1_FetchNotificationPanelCoordinates()
{
	return file.notificationPanel_Coordinates
}

// g_waitingRoomPanelLocation is only filled when a map's spawn data carries a
// panels row. Most do not, and an unset location puts the panel at the world
// origin instead of the waiting room -- which reads as "the panel is missing".
bool function FS_1v1_HasPanelLocation()
{
	return g_waitingRoomPanelLocation.origin != < 0, 0, 0 >
}

vector function Gamemode1v1_GetNotificationPanel_Angles()
{
	// A worldspace RUI plane reads correctly when its forward axis matches the
	// viewer's look direction, so the panel takes the spawn yaw unrotated --
	// yawing it 180 mirrors the text.
	if( !FS_1v1_HasPanelLocation() )
		return < 0, Gamemode1v1_GetWaitingRoomLocation().angles.y, 0 >

	return g_waitingRoomPanelLocation.angles
}

vector function Gamemode1v1_GetNotificationPanel_Coordinates()
{
	if( GetCurrentPlaylistName() == "fs_lgduels_1v1" && GetMapName() == "mp_rr_canyonlands_staging" )
		return file.WaitingRoom.origin + <0,-200,130>

	// Out along the spawn's forward axis rather than straight overhead, so it sits
	// in the player's view when they land on the pad. Yaw only: pitch would push
	// the panel into the floor or the ceiling.
	if( !FS_1v1_HasPanelLocation() )
	{
		LocPair waitingRoom = Gamemode1v1_GetWaitingRoomLocation()
		vector forward = AnglesToForward( < 0, waitingRoom.angles.y, 0 > )
		return waitingRoom.origin + ( forward * FS_1V1_PANEL_FORWARD_DIST ) + < 0, 0, FS_1V1_PANEL_HEIGHT >
	}

	return g_waitingRoomPanelLocation.origin + <0,0,120>
}

void function groupRecapStats( entity player, float damage, int hits, int shots, int kills, int deaths, string opponent, float opponentdamage, int opponenthits, int opponentshots, int opponentkills, int opponentdeaths, float startTime )
{
    float accuracy = 0.0
    float opponent_accuracy = 0.0

    if ( shots > 0.0 )
	{
        accuracy = ( hits.tofloat() / shots.tofloat() ) * 100.0

        if ( accuracy >= 100.0 )
            accuracy = 100.0
    }

	float kd = deaths > 0 ? kills.tofloat() / deaths.tofloat() : kills.tofloat()
	float opponentkd = opponentdeaths > 0 ? opponentkills.tofloat() / opponentdeaths.tofloat() : opponentkills.tofloat()

    if ( opponentshots > 0.0 )
	{
        opponent_accuracy = ( opponenthits.tofloat() / opponentshots.tofloat() ) * 100.0

        if ( opponent_accuracy >= 100.0 )
            opponent_accuracy = 100.0
    }

	float lasted = Time() - startTime;
    string print_totals = format("\n Fight lasted %d seconds. \n\n\n Your Dmg: %d \n Hits: %d \n Shots %d \n Your Accuracy: %d%% \n Your Kills: %d \n Your Deaths: %d \n Challenge KD: %.2f \n\n\n\n %s's Dmg: %d \n %s's Hits: %d \n %s's Shots %d \n %s's Accuracy: %d%% \n %s's Kills: %d \n %s's Deaths: %d \n %s's Challenge KD: %.2f", lasted, damage, hits, shots, accuracy, kills, deaths, kd, opponent, opponentdamage, opponent, opponenthits, opponent, opponentshots, opponent, opponent_accuracy, opponent, opponentkills, opponent, opponentdeaths, opponent, opponentkd);

	if( IsValid( player ) ) //Todo(mk): make ui. send this data to ui
		Message( player, "\n\n\n\n\n\n\n\n\n Recap vs: " + opponent, print_totals, 30 )
}
