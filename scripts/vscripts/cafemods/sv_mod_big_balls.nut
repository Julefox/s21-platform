// CafeMod: Big Balls -- Maggie wrecking ball is 5x model scale.
// Scale applied at ball spawn in mp_ability_wrecking_ball.nut.

global function CafeMod_BigBalls_Init

void function CafeMod_BigBalls_Init()
{
	bool playlistDefault = GetCurrentPlaylistVarBool( "cafemod_big_balls", false )

	CafeMod_Register( "big_balls", BigBalls_OnEnable, BigBalls_OnDisable, playlistDefault )
}

void function BigBalls_OnEnable()
{
	printt( "[CafeMod] big_balls ON scale=5.0 (next ult throw / mitosis child)" )
}

void function BigBalls_OnDisable()
{
	printt( "[CafeMod] big_balls OFF (live balls keep current scale)" )
}
