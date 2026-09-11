// Flowstate 1v1 stress: fake-player fights, disconnects, rest toggles, reconnects.

global function DEV_1v1_StressTest_Start
global function DEV_1v1_StressTest_Stop
global function DEV_1v1_StressTest_SpawnBots
global function DEV_1v1_StressTest_Status
global function DEV_1v1_StressTest_KickBots

struct
{
	bool isRunning = false
	bool parked = false
	int botsSpawned = 0
	int totalKills = 0
	int totalDisconnects = 0
	int totalRestToggles = 0
	int totalReconnects = 0
	float startTime = 0.0
} stresstest

bool function _StressTest_IsPlaying()
{
	if ( GetScoreboardShowingState() || GetChampionShowingState() )
		return false
	if ( GetTDMState() != eTDMState.IN_PROGRESS )
		return false
	if ( GetGlobalNetTime( "FSDM_RoundIntroEndTime" ) > Time() )
		return false
	return true
}

bool function FS_1v1_StressCheatsOk()
{
	if ( GetConVarBool( "sv_cheats" ) )
		return true
	printt( "[FS-1V1][STRESS] requires sv_cheats 1" )
	return false
}

void function DEV_1v1_StressTest_SpawnBots( int count = 10 )
{
	if ( !FS_1v1_StressCheatsOk() )
		return

	int maxPlayers = GetCurrentPlaylistVarInt( "max_players", 60 )
	int used = GetNumHumanPlayers() + GetNumFakeClients()
	int remaining = maxPlayers - used
	if ( remaining < 2 )
	{
		printt( format( "[FS-1V1][STRESS] no seats humans=%d bots=%d max=%d", GetNumHumanPlayers(), GetNumFakeClients(), maxPlayers ) )
		return
	}
	if ( count < 2 )
		count = 2
	if ( count > remaining )
	{
		printt( format( "[FS-1V1][STRESS] clamp %d -> %d remaining (humans=%d bots=%d max=%d)", count, remaining, GetNumHumanPlayers(), GetNumFakeClients(), maxPlayers ) )
		count = remaining
	}

	printt( format( "[FS-1V1][STRESS] spawning %d fake players", count ) )
	SpawnBots( count )

	thread function() : ( count )
	{
		wait 3.0

		int marked = 0
		foreach ( player in GetPlayerArray() )
		{
			if ( IsValid( player ) && player.IsBot() )
				marked++
		}

		stresstest.botsSpawned = marked
		printt( format( "[FS-1V1][STRESS] %d bots live (asked %d)", marked, count ) )
		if ( _StressTest_IsPlaying() )
			thread TriggerMatchmaking()
		else
			printt( "[FS-1V1][STRESS] spawn done, waiting for playing to pair" )
	}()
}

void function DEV_1v1_StressTest_Start( float killInterval = 3.0, float disconnectChance = 0.05, float restChance = 0.1, float reconnectChance = 0.15 )
{
	if ( !FS_1v1_StressCheatsOk() )
		return

	if ( stresstest.isRunning )
	{
		printt( "[FS-1V1][STRESS] already running; stop first" )
		return
	}

	if ( killInterval < 0.5 )
		killInterval = 0.5

	stresstest.isRunning = true
	stresstest.totalKills = 0
	stresstest.totalDisconnects = 0
	stresstest.totalRestToggles = 0
	stresstest.totalReconnects = 0
	stresstest.startTime = Time()

	printt( format( "[FS-1V1][STRESS] start killInterval=%.1f disconnect=%.2f rest=%.2f reconnect=%.2f",
		killInterval, disconnectChance, restChance, reconnectChance ) )

	thread _StressTest_MainLoop( killInterval, disconnectChance, restChance, reconnectChance )
}

void function DEV_1v1_StressTest_Stop()
{
	stresstest.isRunning = false
	printt( "[FS-1V1][STRESS] stopping" )
	DEV_1v1_StressTest_Status()
}

void function DEV_1v1_StressTest_KickBots()
{
	if ( !FS_1v1_StressCheatsOk() )
		return

	stresstest.isRunning = false
	DisconnectAllBots()
	printt( "[FS-1V1][STRESS] kick_all_bots" )
}

void function DEV_1v1_StressTest_Status()
{
	float elapsed = stresstest.startTime > 0 ? Time() - stresstest.startTime : 0.0

	int waitingCount = 0
	int restingCount = 0
	int inMatchCount = 0
	int sequenceCount = 0
	int spectatingCount = 0
	int otherCount = 0
	int botCount = 0

	foreach ( player in GetPlayerArray() )
	{
		if ( !IsValid( player ) || !player.IsBot() )
			continue

		botCount++
		int state = Gamemode1v1_GetPlayerGamestate( player )

		switch ( state )
		{
			case e1v1State.WAITING:		waitingCount++; break
			case e1v1State.RESTING:		restingCount++; break
			case e1v1State.IN_MATCH:	inMatchCount++; break
			case e1v1State.SEQUENCE:	sequenceCount++; break
			case e1v1State.SPECTATING:	spectatingCount++; break
			default:					otherCount++; break
		}
	}

	printt( "[FS-1V1][STRESS] ========== STATUS ==========" )
	printt( format( "[FS-1V1][STRESS] running=%s parked=%s playing=%s tdm=%d elapsed=%.0fs",
		stresstest.isRunning ? "YES" : "NO",
		stresstest.parked ? "YES" : "NO",
		_StressTest_IsPlaying() ? "YES" : "NO",
		GetTDMState(),
		elapsed ) )
	printt( format( "[FS-1V1][STRESS] bots=%d waiting=%d resting=%d in_match=%d sequence=%d spectating=%d other=%d",
		botCount, waitingCount, restingCount, inMatchCount, sequenceCount, spectatingCount, otherCount ) )
	printt( format( "[FS-1V1][STRESS] kills=%d disconnects=%d rest=%d reconnects=%d",
		stresstest.totalKills, stresstest.totalDisconnects, stresstest.totalRestToggles, stresstest.totalReconnects ) )

	foreach ( player in GetPlayerArray() )
	{
		if ( !IsValid( player ) || !player.IsBot() )
			continue
		printt( format( "[FS-1V1][STRESS]   %s k=%d d=%d state=%d",
			player.GetPlayerName(),
			player.GetPlayerNetInt( "kills" ),
			player.GetPlayerNetInt( "deaths" ),
			Gamemode1v1_GetPlayerGamestate( player ) ) )
	}
}

void function _StressTest_ReconnectOne()
{
	int team = SpawnBots_ResolveTeam( false )
	if ( team <= TEAM_SPECTATOR )
	{
		printt( "[FS-1V1][STRESS] reconnect skipped (no team)" )
		return
	}

	int botIndex = stresstest.botsSpawned + stresstest.totalReconnects
	string botName = "stressbot_r" + botIndex.tostring()
	int edict = -1
	try
	{
		edict = CreateFakePlayer( botName, team )
	}
	catch ( spawnErr )
	{
		printt( format( "[FS-1V1][STRESS] reconnect CreateFakePlayer threw %s", spawnErr ) )
		return
	}

	if ( edict < 0 )
	{
		printt( "[FS-1V1][STRESS] reconnect CreateFakePlayer failed" )
		return
	}

	stresstest.totalReconnects++
	printt( format( "[FS-1V1][STRESS] reconnect %s team=%d", botName, team ) )
}

bool function _StressTest_FinishBotMatch( MatchGroup group )
{
	if ( !Gamemode1v1_IsMatchValid( group ) || group.IsFinished )
		return false
	if ( !IsValid( group.player1 ) || !IsValid( group.player2 ) )
		return false
	if ( !group.player1.IsBot() || !group.player2.IsBot() )
		return false

	entity winner = CoinFlip() ? group.player1 : group.player2
	entity loser = winner == group.player1 ? group.player2 : group.player1
	if ( !IsValid( winner ) || !IsValid( loser ) )
		return false

	if ( IsInvincible( loser ) )
		ClearInvincible( loser )

	HandleGroupIsFinished( loser, winner )
	stresstest.totalKills++
	printt( format( "[FS-1V1][STRESS] winner=%s k=%d loser=%s d=%d",
		winner.GetPlayerName(), winner.GetPlayerNetInt( "kills" ),
		loser.GetPlayerName(), loser.GetPlayerNetInt( "deaths" ) ) )

	if ( IsValid( loser ) && IsAlive( loser ) )
	{
		try
		{
			loser.Die( winner, winner, { damageSourceId = eDamageSourceId.mp_weapon_nemesis } )
		}
		catch ( dieErr )
		{
			printt( "[FS-1V1][STRESS] Die failed " + dieErr )
		}
	}

	return true
}

void function _StressTest_FinishAllBotMatches()
{
	if ( !_StressTest_IsPlaying() )
		return

	array<int> handles
	foreach ( groupHandle, group in file.activeMatches )
		handles.append( groupHandle )

	int finished = 0
	foreach ( int groupHandle in handles )
	{
		if ( !( groupHandle in file.activeMatches ) )
			continue
		MatchGroup group = file.activeMatches[ groupHandle ]
		if ( group.IsFinished )
			continue
		if ( _StressTest_FinishBotMatch( group ) )
			finished++
	}

	if ( finished < 1 && file.waitingQueue.len() >= 2 )
		thread TriggerMatchmaking()
}

void function _StressTest_MainLoop( float killInterval, float disconnectChance, float restChance, float reconnectChance )
{
	while ( stresstest.isRunning )
	{
		if ( !_StressTest_IsPlaying() )
		{
			if ( !stresstest.parked )
			{
				stresstest.parked = true
				printt( format( "[FS-1V1][STRESS] parked tdm=%d scoreboard=%s champion=%s",
					GetTDMState(),
					string( GetScoreboardShowingState() ),
					string( GetChampionShowingState() ) ) )
			}
			wait 0.5
			continue
		}

		if ( stresstest.parked )
		{
			stresstest.parked = false
			printt( "[FS-1V1][STRESS] resume playing" )
		}

		wait killInterval

		if ( !stresstest.isRunning )
			break
		if ( !_StressTest_IsPlaying() )
			continue

		try
		{
			array<entity> botsWaiting = []
			array<entity> botsResting = []
			array<entity> allBots = []

			foreach ( player in GetPlayerArray() )
			{
				if ( !IsValid( player ) || !player.IsBot() )
					continue

				allBots.append( player )
				int state = Gamemode1v1_GetPlayerGamestate( player )

				switch ( state )
				{
					case e1v1State.WAITING:
						botsWaiting.append( player )
						break
					case e1v1State.RESTING:
						botsResting.append( player )
						break
				}
			}

			_StressTest_FinishAllBotMatches()

			if ( allBots.len() > 2 && RandomFloat( 1.0 ) < disconnectChance )
			{
				entity botToKick = null
				if ( botsWaiting.len() > 0 )
					botToKick = botsWaiting.getrandom()
				else if ( botsResting.len() > 0 )
					botToKick = botsResting.getrandom()

				if ( IsValid( botToKick ) )
				{
					string botName = botToKick.GetPlayerName()
					stresstest.totalDisconnects++
					printt( format( "[FS-1V1][STRESS] disconnect %s state=%d", botName, Gamemode1v1_GetPlayerGamestate( botToKick ) ) )
					ServerCommand( "kick \"" + botName + "\"" )
				}
			}

			if ( RandomFloat( 1.0 ) < restChance )
			{
				entity restBot = null

				if ( botsWaiting.len() > 0 && ( botsResting.len() == 0 || CoinFlip() ) )
					restBot = botsWaiting.getrandom()
				else if ( botsResting.len() > 0 )
					restBot = botsResting.getrandom()

				if ( IsValid( restBot ) )
				{
					int state = Gamemode1v1_GetPlayerGamestate( restBot )

					if ( state == e1v1State.WAITING )
					{
						Gamemode1v1_AddPlayerToRest( restBot )
						thread Gamemode1v1_RespawnForMatch( restBot )
						stresstest.totalRestToggles++
					}
					else if ( state == e1v1State.RESTING )
					{
						Gamemode1v1_AddPlayerToQueue( restBot, false, true )
						stresstest.totalRestToggles++
					}
				}
			}

			if ( RandomFloat( 1.0 ) < reconnectChance && allBots.len() < stresstest.botsSpawned )
				_StressTest_ReconnectOne()

			if ( stresstest.totalKills % 10 == 0 && stresstest.totalKills > 0 )
				DEV_1v1_StressTest_Status()
		}
		catch ( loopErr )
		{
			printt( "[FS-1V1][STRESS] loop error " + loopErr )
		}
	}

	printt( "[FS-1V1][STRESS] loop ended" )
	DEV_1v1_StressTest_Status()
}
