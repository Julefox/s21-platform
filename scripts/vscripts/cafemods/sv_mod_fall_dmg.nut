// CafeMod fall_dmg: custom fall damage from leave/touch ground.
// Uses player.e.IsFalling + FallDamageJumpOrg (ServerEntityStruct).

global function CafeMod_FallDmg_Init

const float FALL_DMG_MIN_DIST = 400.0
const float FALL_DMG_MULT = 0.035
const float FALL_DMG_MULT_HIGH = 0.05
const float FALL_DMG_HIGH_DIST = 1000.0

struct
{
	bool connectHooked = false
} file

void function CafeMod_FallDmg_Init()
{
	bool def = GetCurrentPlaylistVarBool( "cafemod_fall_dmg", false )

	CafeMod_Register( "fall_dmg", FallDmg_OnEnable, FallDmg_OnDisable, def )

	if ( !file.connectHooked )
	{
		AddCallback_OnClientConnected( FallDmg_OnClientConnected )
		file.connectHooked = true
	}
}

void function FallDmg_OnEnable()
{
	printt( "[CafeMod] fall_dmg ON" )
	foreach ( entity player in GetPlayerArray() )
		FallDmg_Attach( player )
}

void function FallDmg_OnDisable()
{
	printt( "[CafeMod] fall_dmg OFF" )
	foreach ( entity player in GetPlayerArray() )
		FallDmg_Detach( player )
}

void function FallDmg_OnClientConnected( entity player )
{
	if ( !IsValid( player ) || !player.IsPlayer() )
		return
	if ( CafeMod_IsEnabled( "fall_dmg" ) )
		FallDmg_Attach( player )
}

void function FallDmg_Attach( entity player )
{
	if ( !IsValid( player ) || !player.IsPlayer() )
		return

	if ( !HasPlayerMovementEventCallback( player, ePlayerMovementEvents.TOUCH_GROUND, FallDmg_OnTouchGround ) )
		AddPlayerMovementEventCallback( player, ePlayerMovementEvents.TOUCH_GROUND, FallDmg_OnTouchGround )

	if ( !HasPlayerMovementEventCallback( player, ePlayerMovementEvents.LEAVE_GROUND, FallDmg_OnLeaveGround ) )
		AddPlayerMovementEventCallback( player, ePlayerMovementEvents.LEAVE_GROUND, FallDmg_OnLeaveGround )

	player.e.IsFalling = false
}

void function FallDmg_Detach( entity player )
{
	if ( !IsValid( player ) || !player.IsPlayer() )
		return

	if ( HasPlayerMovementEventCallback( player, ePlayerMovementEvents.TOUCH_GROUND, FallDmg_OnTouchGround ) )
		RemovePlayerMovementEventCallback( player, ePlayerMovementEvents.TOUCH_GROUND, FallDmg_OnTouchGround )

	if ( HasPlayerMovementEventCallback( player, ePlayerMovementEvents.LEAVE_GROUND, FallDmg_OnLeaveGround ) )
		RemovePlayerMovementEventCallback( player, ePlayerMovementEvents.LEAVE_GROUND, FallDmg_OnLeaveGround )

	player.e.IsFalling = false
}

void function FallDmg_OnLeaveGround( entity player )
{
	if ( !CafeMod_IsEnabled( "fall_dmg" ) )
		return
	if ( !IsValid( player ) )
		return
	if ( player.e.IsFalling )
		return
	if ( player.IsNoclipping() )
		return

	player.e.IsFalling = true
	player.e.FallDamageJumpOrg = player.GetOrigin()
}

void function FallDmg_OnTouchGround( entity player )
{
	if ( !CafeMod_IsEnabled( "fall_dmg" ) )
		return
	if ( !IsValid( player ) )
		return
	if ( !player.e.IsFalling )
		return
	if ( player.IsNoclipping() )
	{
		player.e.IsFalling = false
		return
	}

	player.e.IsFalling = false

	vector landingDist = <player.e.FallDamageJumpOrg.x, player.e.FallDamageJumpOrg.y, player.GetOrigin().z>
	float fallDist = Distance( player.e.FallDamageJumpOrg, landingDist )

	if ( fallDist < FALL_DMG_MIN_DIST )
		return

	float mult = FALL_DMG_MULT
	if ( fallDist > FALL_DMG_HIGH_DIST )
		mult = FALL_DMG_MULT_HIGH

	float dmg = mult * fallDist
	player.TakeDamage( dmg, null, null, { damageSourceId = damagedef_suicide } )
}
