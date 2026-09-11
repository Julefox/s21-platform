global function DividedMoon_MapInit_Common
global function CodeCallback_PlayerEnterUpdraftTrigger
global function CodeCallback_PlayerLeaveUpdraftTrigger

#if SERVER
global function DividedMoon_UpdraftInit_Common

const DIVIDED_MOON_CRAFTER_COUNT = 14
const DIVIDED_MOON_BEACON_COUNT = 14
const DIVIDED_MOON_CONSOLE_COUNT = 11
#endif // SERVER

// Updraft logic taken from Desertlands & Canyonlands MU3 (Caustic TT)
void function CodeCallback_PlayerEnterUpdraftTrigger( entity trigger, entity player )
{
	float entZ = player.GetOrigin().z
	OnEnterUpdraftTrigger( trigger, player, entZ + 100 )
}

void function CodeCallback_PlayerLeaveUpdraftTrigger( entity trigger, entity player )
{
	OnLeaveUpdraftTrigger( trigger, player )
}

#if SERVER
// When this becomes a production map, we should change the Canyonlands updraft into a shared function
void function DividedMoon_UpdraftInit_Common( entity player )
{
	ApplyUpdraftModUntilTouchingGround( player )
	                        
		Control_PrintSkydiveDebug( player, " DividedMoon_UpdraftInit_Common going to trigger PlayerSkydiveFromCurrentPosition" )
                               
	thread PlayerSkydiveFromCurrentPosition ( player )

	// JM changing this to use the version of the Skydive function that grants initial velocity. For now just inheriting the player's current velocity.
	//thread PlayerSkydiveFromCurrentPositionWithInitVelocity( player, < player.GetVelocity().x, player.GetVelocity().y, 0 >, false)
}
#endif // SERVER

void function DividedMoon_MapInit_Common()
{
	printf( "%s()", FUNC_NAME() )

	UpdraftTriggerSettings dividedMoonUpdraftSettings = {
		minShakeActivationHeight = 500.0               // At what z-position to start shaking the player's view
		maxShakeActivationHeight = 400.0               // At what z-position will the player's view be shaking at the maximum
		liftSpeed                = 425.0               // Maximum upward speed
		liftAcceleration         = 200.0               // How fast to accelerate to the maximum upward speed
		liftExitDuration         = 2.0                 // After clearing the updraft trigger, how many extra seconds to continue lifting for
	}
	OverrideUpdraftTriggerSettings ( dividedMoonUpdraftSettings )

	#if SERVER
		thread KillPlayersUnderMap_Thread( MAP_KILL_VOLUME_OFFSET_DIVIDED_MOON ) //-2400

                       
                                                                                   
                             
		Crafting_SetCrafterGoalCount( DIVIDED_MOON_CRAFTER_COUNT )
		SurveyBeacon_SetBeaconGoalCount( DIVIDED_MOON_BEACON_COUNT )
		RingConsole_SetConsoleGoalCount( DIVIDED_MOON_CONSOLE_COUNT )
	#endif

	#if CLIENT
                       
                                                              
                             
	#endif
}

