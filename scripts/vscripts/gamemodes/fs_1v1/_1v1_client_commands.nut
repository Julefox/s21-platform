// Flowstate 1v1. CafeFPS (makimakima, mkos).

global function ClientCommand_SpectateNew
global function MessagePlayer_Disabled

global function CC_1v1_ToggleRest
global function CC_1v1_SetIBMMWaitTime
global function CC_1v1_AcceptChallenges
global function CC_1v1_CamoColor
global function CC_1v1_IBMM
global function CC_1v1_MaxEnemyLatency
global function CC_1v1_MaxIBMMTime
global function CC_1v1_ShowInputBanner
global function CC_1v1_ShowVsUI
global function CC_1v1_StartInRest

void function CC_1v1_AcceptChallenges( entity player, array<string> args )
{
	if( !args.len() )
		return;
	if( !IsValid( player ) || !IsStringNumeric( args[0], 0, 1 ) )
		return;
	if( args[0] == "0" )
		player.p.lock1v1_setting = false
	else if( args[0] == "1" )
		player.p.lock1v1_setting = true

	return;}

void function CC_1v1_CamoColor( entity player, array<string> args )
{
	if( !args.len() )
		return;
	if( !IsValid( player ) || !IsStringNumeric( args[0] ) )
		return;
	player.p.playerCamo = ClampInt( args[0].tointeger(), 0, FS_1V1_CAMO_RANDOM )

	if( IsAlive( player ) && Gamemode1v1_IsPlayerInState( player, e1v1State.RESTING ) )
		FS_1v1_ApplyPlayerCamo( player )

	return;}

void function CC_1v1_IBMM( entity player, array<string> args )
{
	if( !args.len() )
		return;
	if( !IsValid( player ) || !IsStringNumeric( args[0], 0, 1 ) )
		return;
	// SavePlayerData is the single writer: it stores the value, applies it and
	// rearms the queue. Setting p.IBMM_grace_period here as well would leave the
	// stored value behind for the next bridge load to hand back.
	if(args[0] == "0")
	{
		SavePlayerData( player, "wait_time", 0.0 )
	}
	else if(args[0] == "1")
	{
		SavePlayerData( player, "wait_time", 3.0 )
	}

	return;}

void function CC_1v1_MaxEnemyLatency( entity player, array<string> args )
{
	if( !args.len() )
		return;
	if( !IsValid( player ) || !IsStringNumeric( args[0], 5, 999 ) )
		return;
	player.p.max_enemy_ping = Clamp( args[0].tofloat(), 5.0, 999.0 )

	return;}

void function CC_1v1_MaxIBMMTime( entity player, array<string> args )
{
	if( !args.len() )
		return;
	if( !IsValid( player ) || !IsStringNumeric( args[0], 0, 30 ) )
		return;
	// if( args[0].tofloat() <= 0 )
		// player.SetConVarInt( "fs_1v1_ibmm", 0 )
	// else
		// player.SetConVarInt( "fs_1v1_ibmm", 1 )

	SavePlayerData( player, "wait_time", Clamp( args[0].tofloat(), 0.0, 30.0 ) )

	return;}

void function CC_1v1_ShowInputBanner( entity player, array<string> args )
{
	if( !args.len() )
		return;
	if( !IsValid( player ) || !IsStringNumeric( args[0], 0, 1 ) )
		return;
	if( args[0] == "0" )
		player.p.enable_input_banner = false
	else if( args[0] == "1" )
		player.p.enable_input_banner = true

	return;}

void function CC_1v1_ShowVsUI( entity player, array<string> args )
{
	if( !args.len() )
		return;
	if( !IsValid( player ) || !IsStringNumeric( args[0], 0, 1 ) )
		return;
	if( args[0] == "0" )
		player.p.showvsui = false
	else if( args[0] == "1" )
		player.p.showvsui = true

	return;}

//1v1 Settings Client Commands
void function CC_1v1_StartInRest( entity player, array<string> args )
{
	if( !args.len() )
		return;
	if( !IsValid( player ) || !IsStringNumeric( args[0], 0, 1 ) )
		return;
	if(args[0] == "0")
	{
		player.p.start_in_rest_setting = false
	}
	else if(args[0] == "1")
	{
		player.p.start_in_rest_setting = true
	}

	return;}

void function CC_1v1_ToggleRest( entity player, array<string> args )
{
	if( !IsValid( player ) )
		return;
	if( GetTDMState() != eTDMState.IN_PROGRESS ) //(cafe) new
		return;
	if( Time() < player.p.lastRestUsedTime + 3 || Gamemode1v1_IsPlayerInState( player, e1v1State.PREMATCH ) || Gamemode1v1_IsPlayerInState( player, e1v1State.SEQUENCE ) )
	{
		LocalEventMsg( player, "#FS_RESTCOOLDOWN" )
		return;	}

	player.p.lastRestUsedTime = Time()

	int playerHandle = player.p.handle

	if( player.p.rest_request )
	{
		player.p.rest_request = false
		LocalSplashMsg( player, "REST REQUEST CANCELLED" )
		return;	}

	if( playerHandle in file.restingPlayers )
	{
		if( player.IsObserver() || player.p.isSpectating )
		{
			endSpectate( player )
		}

		// LocalMsg( player, "#FS_MATCHING" )
		Gamemode1v1_AddPlayerToQueue( player, false, true )
	}
	else
	{
		// Leaving a live duel is always deferred to the round end, so rest can
		// never be used to abandon a fight that is already under way.
		if( IsPlayerInProgress( playerHandle ) )
		{
			MatchGroup group = Gamemode1v1_GetPlayerSoloGroup( player )

			entity opponent
			if( group.isValid )
				opponent = player == group.player1 ? group.player2 : group.player1

			if( IsValid( opponent ) )
			{
				player.p.rest_request = true
				LocalMsg( player, "#FS_SendingToRestAfter" )

				#if DEVELOPER
					sqprint( "[1V1 REST] rest queued for round end" )
				#endif

				return;			}
		}

		if( !Gamemode1v1_IsPlayerInState( player, e1v1State.WAITING ) )
		{
			try
			{
				player.Die( null, null, { damageSourceId = eDamageSourceId.damagedef_despawn } )
			}
			catch (error)
			{
				#if DEVELOPER
					sqerror( "[1v1:RestCmdDie] " + error )
				#endif
			}
		}

		Gamemode1v1_AddPlayerToRest( player )

		thread Gamemode1v1_RespawnForMatch( player )
	}

	return;}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
void function ClientCommand_SpectateNew( entity user, array<string> args )
{
    if ( !IsValid( user ) )
		return;
	if ( !Gamemode1v1_IsPlayerResting( user ) )
    {
        LocalMsg( user, "#FS_MustBeInRest", "#FS_MustBeInRest_SUBSTR" )
        return;    }

	if( user.GetPlayerNetInt( "FS_1v1_PlayerState" ) != e1v1State.RESTING )
		return;
	if ( GetTDMState() != eTDMState.IN_PROGRESS )
    {
        LocalMsg( user, "#FS_GameNotPlaying" )
        return;    }

	if ( !CheckRate( user, "spectate", FS_1V1_SPECTATE_COOLDOWN, true ) )
		return;
    try
    {
        // Only players in a live duel are valid targets. A lobby player sits in
        // every realm, so FS_GetEntityPrimaryRealm would hand back slot 1 and drop
        // the spectator into an unrelated fight.
        array<entity> enemiesArray
        foreach ( entity candidate in GetPlayerArray_AliveConnected() )
        {
            if ( candidate == user )
                continue
            if ( !IsPlayerInProgress( candidate.p.handle ) )
                continue
            enemiesArray.append( candidate )
        }

		// entity messageBot = GetMessageBotEnt()
		// if ( bBotEnabled() && IsValid( messageBot ) && IsAlive( messageBot ) )
			// enemiesArray.fastremovebyvalue( messageBot )

		if ( enemiesArray.len() == 0 )
		{
			LocalMsg( user, "#FS_NO_PLAYERS_TO_SPEC" )
			return;		}

        entity specTarget = enemiesArray.getrandom()

        user.p.isSpectating = true
        user.SetPlayerNetInt( "spectatorTargetCount", GetPlayerArray().len() )
        int specRealm = FS_GetEntityPrimaryRealm( specTarget )
        FS_SetRealmForPlayer( user, specRealm )
        FS_1v1_TrackSpectatorRealm( user, specRealm )
        user.SetObserverTarget( specTarget )
        user.SetSpecReplayDelay( 0.5 )
        user.StartObserverMode( OBS_MODE_IN_EYE )
        user.p.lastTimeSpectateUsed = Time()

		Gamemode1v1_SetPlayerGamestate( user, e1v1State.SPECTATING )

		// Update resting panels with new counts (resting -> spectating)
		FS_1v1_RequestRestingNotificationRefresh()

        // LocalMsg( user, "#FS_JumpToStopSpec" )

        user.MakeInvisible()
        AddButtonPressedPlayerInputCallback( user, IN_JUMP, endSpectate )
    }
    catch ( e )
    {
		#if DEVELOPER
			sqerror( "[1v1:SpectateNew] " + e )
		#endif
	}
	return;}

void function CC_1v1_SetIBMMWaitTime( entity player, array<string> args )
{
	if ( !CheckRate( player ) )
		return;
	string param = ""
	int limit = settings.ibmm_wait_limit

	if ( args.len() > 0 )
		param = args[ 0 ]

	if  ( args.len() < 1 )
	{
		string status = " " //(mk): needs to be a char or var is treated as empty
		if ( player.p.IBMM_grace_period == 0 )
			status = " (disabled)"

		LocalMsg( player, "#FS_WAIT_TIME_CC", "", eMsgUI.SWEEP, 15.0, limit.tostring(), string( player.p.IBMM_grace_period ) + status )
		LocalSplashMsg( player, "IBMM wait limit " + limit.tostring() + " / current " + string( player.p.IBMM_grace_period ) + status, 8.0 )
		return;	}

	if ( args.len() > 0 && !IsStringNumeric( param, 0, limit ) )
	{
		LocalMsg( player, "#FS_FAILED", "#FS_IBMM_Time_Failed", eMsgUI.DEFAULT, 5, "", limit.tostring() )
		return;	}

	try
	{
		float user_value = float( param )

		if ( user_value > 0.0 && user_value < 3.0 )
			user_value = 3

		SavePlayerData( player, "wait_time", user_value )
		Remote_CallFunction_ByRef( player, "ForceScoreboardLoseFocus" )

		LocalMsg( player, "#FS_SUCCESS", "#FS_IBMM_Time_Changed", eMsgUI.DEFAULT, 3, "", user_value.tostring() )
		return;	}
	catch ( hiterr )
	{
		return;	}
}

void function MessagePlayer_Disabled( entity player, array<string> args )
{
	LocalEventMsg( player, "#FS_DisabledTDMWeps" )
	return;}

